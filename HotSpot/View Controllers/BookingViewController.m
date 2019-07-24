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

@interface BookingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *timeIsUnavailable;
@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *chosenIndexPaths;
@end

@implementation BookingViewController
{
    NSDate *startTime;
    NSDate *endTime;
    BOOL pickingStartTime;
    BOOL pickingEndTime;
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
    
    PFRelation *relation = [self.listing relationForKey:@"unavailable"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"repeatsWeekly"];
    
    NSDate *startDate = self.datePicker.date;
    NSInteger secondsPerDay = 60 * 60 * 24;
    NSInteger timeSinceBeginningOfDay = (int)[startDate timeIntervalSinceReferenceDate] % secondsPerDay; // TODO: consider time zones
    NSDate *beginningOfStartDay = [startDate dateByAddingTimeInterval: -timeSinceBeginningOfDay];
    NSDate *endOfStartDay = [startDate dateByAddingTimeInterval: secondsPerDay];
    
    [query whereKey:@"endTime" greaterThan:beginningOfStartDay];
    [query whereKey:@"startTime" lessThan:endOfStartDay];
    
    self.timeIsUnavailable = [NSMutableArray new];
    for (NSInteger i = 0; i < 24 * 4; i ++) {
        [self.timeIsUnavailable addObject:[NSNumber numberWithBool:NO]];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<TimeInterval *> *timeIntervals, NSError * _Nullable error) {
        if (timeIntervals) {
            for (TimeInterval *timeInterval in timeIntervals) {
                // map to 0 through 95
                
                NSDate *startTime = timeInterval.startTime;
                NSDate *endTime = timeInterval.endTime;
                
                CGFloat startTimeIntervalSinceBeginningOfDay = [startTime timeIntervalSinceDate:beginningOfStartDay];
                NSInteger startMinute = (int)startTimeIntervalSinceBeginningOfDay / 60;
                NSInteger start = startMinute / 15;
                
                CGFloat endTimeIntervalSinceBeginningOfDay = [endTime timeIntervalSinceDate: beginningOfStartDay];
                NSInteger endMinute = (int)endTimeIntervalSinceBeginningOfDay / 60;
                NSInteger end = endMinute / 15;

                NSInteger i = 0;
                for (i =start; i <= end; i++) {
                    self.timeIsUnavailable[i] = [NSNumber numberWithBool:YES];
                }
//                 for now it is set to today.
                
                [self.collectionView reloadData];
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    pickingStartTime = YES;
    pickingEndTime = NO;
    self.chosenIndexPaths = [NSMutableArray new];
    
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
    if (pickingStartTime) {
        [cell setTime:indexPath.item withDate:self.datePicker.date];
    }
    else {
        [cell setTime:indexPath.item withDate:self.datePicker.date];
    }
    if ([self.timeIsUnavailable[indexPath.item] boolValue]) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:.2 blue:.4 alpha:1.0];
    }
    else if ([self.chosenIndexPaths containsObject:indexPath]) {
        cell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0 green:.8 blue:.2 alpha:1.0];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return 24 * 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TimeCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSDate *date = cell.date;
    if (pickingStartTime) {
        startIndexPath = indexPath;
        startTime = cell.date;
        pickingStartTime = NO;
        pickingEndTime = YES;
        [self.chosenIndexPaths addObject: indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
    }
    else if (pickingEndTime){
        pickingEndTime = NO;
        endTime = cell.date;
        for( int i = startIndexPath.item + 1; i <= indexPath.item; i++ ) {
            NSIndexPath *inBetweenIndexPath = [NSIndexPath indexPathForItem:i inSection:startIndexPath.section];
            TimeCell *inBetweenCell = [collectionView cellForItemAtIndexPath:inBetweenIndexPath];
            [self.chosenIndexPaths addObject:[collectionView indexPathForCell:inBetweenCell]];
            inBetweenCell.backgroundColor = [UIColor colorWithRed:0 green:.4 blue:1.0 alpha:1.0];
        }
    }
}

@end
