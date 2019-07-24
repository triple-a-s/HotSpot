//
//  BookingViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "BookingViewController.h"

#import "Booking.h"
#import "DataManager.h"
#import "TimeCell.h"

@interface BookingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation BookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

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
}

- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

# pragma mark - Private Methods

- (IBAction)confirmClicked:(id)sender {
    Listing *listing = self.listing;
    [Booking bookDriveway:listing
            withStartTime:_startDatePicker.date
        withDurationInSec:[[NSNumber alloc] initWithDouble:[self.endDatePicker.date timeIntervalSinceDate:self.startDatePicker.date]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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
    [cell setTime:indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return 24 * 4;
}

@end
