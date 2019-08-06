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

@interface BookingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<TimeSlot *> *timeSlots;
@end

@implementation BookingViewController
{
    NSDate *startTime;
    NSDate *endTime;
    BOOL pickingStartTime;
    NSIndexPath *startIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;

    // image
    [DataManager getAddressNameFromPoint:self.listing.address withCompletion:^(NSString *name, NSError * _Nullable error){
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            self.listingAddressLabel.text = name;
        }
    }];
    
    PFFileObject *img = self.listing.picture;
    [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
        UIImage *imageToLoad = [UIImage imageWithData:imageData];
        self.listingImageView.image = imageToLoad;
    }];
    self.listingPriceLabel.text = [NSString stringWithFormat: @"$%@/hr", self.listing.price];
    PFUser *homeowner = self.listing.homeowner;
    [homeowner fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.listingOwnerLabel.text = object[@"name"];
    }];
    
    
    [self updateCells];
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
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    Listing *listing = self.listing;
    [Booking bookDriveway:listing
            withStartTime:startTime
        withDurationInSec:[[NSNumber alloc] initWithDouble:[endTime timeIntervalSinceDate:startTime]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                [self performSegueWithIdentifier:@"confirmationSegue" sender:nil];
            }
            else if (error) {
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
    if (!timeSlot.available) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:.2 blue:.4 alpha:1.0];
    }
    else if (timeSlot.chosen) {
        cell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0 green:.8 blue:.2 alpha:.6];
    }
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
            pickingStartTime = NO;
            self.timeSlots[indexPath.item].chosen = YES;
            cell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
            [self.collectionView reloadData];
        }
        else {
            for (int i = startIndexPath.item; i < indexPath.item; i++) {
                if ( self.timeSlots[i].available == NO) {
                    return;
                }
            }
            if (startIndexPath.item > indexPath.item) {
                // start date cannot be later than end date
                return;
            }
            endTime = date;
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
    NSInteger timeSinceBeginningOfDay = (int)[date timeIntervalSinceReferenceDate] % secondsPerDay; // TODO: consider time zones
    NSDate *beginningOfDay = [date dateByAddingTimeInterval: -timeSinceBeginningOfDay];
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
    
    CGFloat endTimeIntervalSinceBeginningOfDay = [endDate timeIntervalSinceDate: beginningOfDay];
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
    for (NSInteger i = 0; i < 24 * 4; i ++) {
        self.timeSlots[i].chosen = NO;
    }
    [self.collectionView reloadData];
}


- (IBAction)resetClicked:(id)sender {
    [self reset];
}


- (IBAction)didTapCarCell:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:(@"carSegue") sender:(nil)];
}

@end
