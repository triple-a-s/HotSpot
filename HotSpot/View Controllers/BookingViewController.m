//
//  BookingViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "BookingViewController.h"

#import <UIKit/UIKit.h>
#import "Booking.h"
#import "DataManager.h"
#import "TimeCell.h"
#import "TimeSlot.h"
#import "ColorUtilities.h"

@interface BookingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray<TimeSlot *> *timeSlots;
@end

@implementation BookingViewController
{
    NSDate *startTime;
    NSDate *endTime;
    BOOL pickingStartTime;
    NSIndexPath *startIndexPath;
    NSDateFormatter *formatter;
    UIColor *themeRedColor;
    BOOL viewDidLayoutSubviewsForTheFirstTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0;
    
    viewDidLayoutSubviewsForTheFirstTime = YES;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 4;
    
    layout.itemSize = CGSizeMake(85, 50);
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // today
    self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:3 * 30 * 24 * 60 * 60]; // around three months from now

    // image
    [DataManager getAddressNameFromListing:self.listing withCompletion:^(NSString *name, NSError * _Nullable error){
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            self.listingAddressLabel.text = name;
        }
    }];
    
    self.listingPriceLabel.text = [NSString stringWithFormat: @"$%@/hr", self.listing.price];
    
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mmaa"];
    
    [self updateCells];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(viewDidLayoutSubviewsForTheFirstTime) {
        viewDidLayoutSubviewsForTheFirstTime = NO;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [gregorian setTimeZone:[NSTimeZone localTimeZone]];
        
        NSDate *currentTime = [NSDate date];
        
        NSDate *beginningOfToday = [gregorian startOfDayForDate:currentTime];
        
        CGFloat minutesSinceBeginningOfToday = [currentTime timeIntervalSinceDate:beginningOfToday] / 60;
        
        NSIndexPath *currentTimeIndexPath = [NSIndexPath indexPathForItem:minutesSinceBeginningOfToday / 15 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:currentTimeIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
    }
    
}

- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

# pragma mark - Private Methods

- (IBAction)confirmClicked:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Booking Error"
                                                                   message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    [NSTimer scheduledTimerWithTimeInterval:.05
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:nil
                                    repeats:NO];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    Listing *listing = self.listing;
    [Booking bookDriveway:listing
            withStartTime:startTime
        withDurationInSec:[[NSNumber alloc] initWithDouble:[endTime timeIntervalSinceDate:startTime]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                self.progressView.progress =1;
                [self performSegueWithIdentifier:@"confirmationSegue" sender:nil];
            }
            else if (error) {
                self.progressView.progress=0;
                NSLog(@"%@", error);
            }
            else {
                alert.message = @"Time requested is not available";
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell"
                                                               forIndexPath:indexPath];
    TimeSlot *timeSlot = self.timeSlots[indexPath.item];
    [cell setTime:timeSlot];
    if (!timeSlot.available) { // grayed out, unavailable
        cell.backgroundColor = [UIColor grayColor];
        cell.layer.borderColor = [UIColor grayColor].CGColor;
        cell.timeLabel.textColor = [UIColor whiteColor];
    }
    else if (timeSlot.chosen) { // red, chosen
        cell.backgroundColor = redThemeColor();
        cell.layer.borderColor = redThemeColor().CGColor;
        cell.timeLabel.textColor = [UIColor whiteColor];
    }
    else { // white, available but unchosen
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = redThemeColor().CGColor;
        cell.timeLabel.textColor = redThemeColor();
    }
    cell.layer.borderWidth = 1;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return 96; // 24 * 4, number of 15 minute intervals in a day
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.timeSlots[indexPath.item].available) {
        TimeCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        NSDate *date = self.timeSlots[indexPath.item].date;
        if ([startIndexPath isEqual:indexPath]) {
            // repick start time
            [self reset];
        }
        else if (pickingStartTime) {
            startIndexPath = indexPath;
            startTime = date;
            endTime = [date dateByAddingTimeInterval:15 * 60];
            self.timeRangeLabel.text = [NSString stringWithFormat:@"%@ to %@", [formatter stringFromDate:startTime], [formatter stringFromDate:endTime]];
            pickingStartTime = NO;
            self.confirmButton.enabled = YES;
            self.instructionsLabel.text = @"Adjust your end time:";
            self.timeSlots[indexPath.item].chosen = YES;
            cell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
            [self.collectionView reloadData];
        }
        else {
            self.confirmButton.enabled = YES;
            self.instructionsLabel.text = @"Adjust your end time:";
            for (int i = startIndexPath.item; i < indexPath.item; i++) {
                if ( self.timeSlots[i].available == NO) {
                    return;
                }
            }
            if (startIndexPath.item > indexPath.item) {
                // start date cannot be later than end date
                return;
            }
            endTime = [date dateByAddingTimeInterval:15 * 60];
            self.timeRangeLabel.text = [NSString stringWithFormat:@"%@ to %@", [formatter stringFromDate:startTime], [formatter stringFromDate:endTime]];
            for (int i = startIndexPath.item; i < self.timeSlots.count; i++) {
                if (i<=indexPath.item) {
                    self.timeSlots[i].chosen = YES;
                }
                else {
                    self.timeSlots[i].chosen = NO;
                }
                [self.collectionView reloadData];
            }
        }
    }
    
}

- (void)updateCells {
    PFRelation *relation = [self.listing relationForKey:@"unavailable"]; // get relation for unavailable times for a listing
    PFQuery *query = relation.query;// the query

    NSDate *date = self.datePicker.date; // date chosen by the user
    NSInteger secondsPerDay = 60 * 60 * 24;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];

    NSDate *beginningOfDay = [gregorian startOfDayForDate:date];
    
    NSDate *endOfDay = [date dateByAddingTimeInterval: secondsPerDay];
    
    // only care about unavailable times on day chosen
    [query whereKey:@"endTime" greaterThan:beginningOfDay];
    [query whereKey:@"startTime" lessThan:endOfDay];
    
    // initiate array of TimeSlots, one for each cell in the schedule UI, a.k.a. one for each 15 minute time interval in the day
    self.timeSlots = [NSMutableArray new];
    for (NSInteger i = 0; i < 24 * 4; i ++) {
        TimeSlot *newTimeSlot = [TimeSlot new];
        [newTimeSlot setTime:i
                    withDate:beginningOfDay];
        [self.timeSlots addObject:newTimeSlot];
    }
    
    [self makeTimeSlotsUnavailableGivenStartDate:beginningOfDay andEndDate:[NSDate dateWithTimeIntervalSinceNow:-15 * 60] andBeginningOfDay:beginningOfDay]; // cannot select a time earlier in the day
    
    // fetch the relevant time intervals
    [query findObjectsInBackgroundWithBlock:^(NSArray<TimeInterval *> *timeIntervals, NSError * _Nullable error) {
        if (timeIntervals) {
            for (TimeInterval *timeInterval in timeIntervals) {
                [self makeTimeSlotsUnavailableGivenStartDate:timeInterval.startTime andEndDate:timeInterval.endTime andBeginningOfDay:beginningOfDay];
                
            }
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    PFQuery *repeatsWeeklyQuery = relation.query;
    
    [repeatsWeeklyQuery whereKey:@"repeatsWeekly" equalTo:@YES];
    
    [repeatsWeeklyQuery findObjectsInBackgroundWithBlock:^(NSArray<TimeInterval *> *timeIntervals, NSError * _Nullable error) {
        if (timeIntervals) {
            for (TimeInterval *timeInterval in timeIntervals) {
                // map to 0 through 95
                
                TimeInterval *chosenDateInterval = [TimeInterval new];
                chosenDateInterval.startTime = beginningOfDay;
                chosenDateInterval.endTime = endOfDay;
                
                NSDateInterval *intersection = [timeInterval intersectionWithTimeInterval:chosenDateInterval];
                
                if(intersection) { // if the chosen date is the same week day as the repeating unavailable time interval
                    [self makeTimeSlotsUnavailableGivenStartDate:intersection.startDate andEndDate:intersection.endDate andBeginningOfDay:beginningOfDay];
                }
            }
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    pickingStartTime = YES;
    self.confirmButton.enabled = NO;
    self.instructionsLabel.text = @"Select a start time:";
    self.timeRangeLabel.text = @"";
}

- (void)makeTimeSlotsUnavailableGivenStartDate:(NSDate *)startDate
                                    andEndDate:(NSDate *)endDate
                             andBeginningOfDay:(NSDate *)beginningOfDay {
    CGFloat startTimeIntervalSinceBeginningOfDay = [startDate timeIntervalSinceDate:beginningOfDay];
    NSInteger startMinute = (int)startTimeIntervalSinceBeginningOfDay / 60;
    NSInteger start = startMinute / 15; // transform minute to an index for the cells, 0 to 95
    if ( start < 0 ) {
        start = 0; // if starts before today, normalize to beginning of day
    }
    
    CGFloat buffer = 2; // in seconds
    CGFloat endTimeIntervalSinceBeginningOfDay = [endDate timeIntervalSinceDate: beginningOfDay] - buffer;
    NSInteger endMinute = (int)endTimeIntervalSinceBeginningOfDay / 60;
    NSInteger end = endMinute / 15; // transform minute to an index for the cells, 0 to 95
    if (end > 4 * 24 - 1 ) {
        end = 4 * 24 - 1; // if ends after today, normalize to end of day
    }
    
    for (NSInteger i = start; i <= end; i++) {
        self.timeSlots[i].available = NO;
    }
}
- (IBAction)dateChanged:(id)sender {
    [self updateCells];
}

- (void)reset {
    startTime = nil;
    startIndexPath = nil;
    endTime = nil;
    pickingStartTime = YES;
    self.confirmButton.enabled = NO;
    self.instructionsLabel.text = @"Select a start time:";
    self.timeRangeLabel.text = @"";
    for (NSInteger i = 0; i < 24 * 4; i ++) {
        self.timeSlots[i].chosen = NO;
    }
    [self.collectionView reloadData];
}

- (void) timerFireMethod:(NSTimer*)timer{
    self.progressView.progress+=.3;
}

- (IBAction)resetClicked:(id)sender {
    [self reset];
}


- (IBAction)didTapCarCell:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:(@"carSegue") sender:(nil)];
}

@end
