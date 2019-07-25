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
    Listing *listing = self.listing;
    [Booking bookDriveway:listing
            withStartTime:startTime
        withDurationInSec:[[NSNumber alloc] initWithDouble:[endTime timeIntervalSinceDate:startTime]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                [self performSegueWithIdentifier:@"confirmationSegue" sender:nil];
            }
            else {
                NSLog(@"%@", error);
            }
        }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
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
    return 24 * 4;
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
    PFRelation *relation = [self.listing relationForKey:@"unavailable"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"repeatsWeekly"];
    
    NSDate *date = self.datePicker.date;
    NSInteger secondsPerDay = 60 * 60 * 24;
    NSInteger timeSinceBeginningOfDay = (int)[date timeIntervalSinceReferenceDate] % secondsPerDay; // TODO: consider time zones
    NSDate *beginningOfDay = [date dateByAddingTimeInterval: -timeSinceBeginningOfDay];
    NSDate *endOfDay = [date dateByAddingTimeInterval: secondsPerDay];
    
    [query whereKey:@"endTime" greaterThan:beginningOfDay];
    [query whereKey:@"startTime" lessThan:endOfDay];
    
    self.timeSlots = [NSMutableArray new];
    for (NSInteger i = 0; i < 24 * 4; i ++) {
        TimeSlot *newTimeSlot = [TimeSlot new];
        [newTimeSlot setTime:i
                    withDate:beginningOfDay];
        [self.timeSlots addObject:newTimeSlot];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<TimeInterval *> *timeIntervals, NSError * _Nullable error) {
        if (timeIntervals) {
            for (TimeInterval *timeInterval in timeIntervals) {
                // map to 0 through 95
                
                NSDate *startTime = timeInterval.startTime;
                NSDate *endTime = timeInterval.endTime;
                
                CGFloat startTimeIntervalSinceBeginningOfDay = [startTime timeIntervalSinceDate:beginningOfDay];
                NSInteger startMinute = (int)startTimeIntervalSinceBeginningOfDay / 60;
                NSInteger start = startMinute / 15;
                if ( start < 0 ) {
                    start = 0;
                }
                
                
                CGFloat endTimeIntervalSinceBeginningOfDay = [endTime timeIntervalSinceDate: beginningOfDay];
                NSInteger endMinute = (int)endTimeIntervalSinceBeginningOfDay / 60;
                NSInteger end = endMinute / 15;
                if (end > 4 * 24 - 1 ) {
                    end = 4 * 24 - 1;
                }
                
                NSInteger i = 0;
                for (i = start; i <= end; i++) {
                    self.timeSlots[i].available = NO;
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

@end
