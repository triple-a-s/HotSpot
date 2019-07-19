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

@interface BookingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@end

@implementation BookingViewController

# pragma mark - Private Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DataManager sampleListingForTestingWithCompletion:^(Listing * _Nonnull listing, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            self.listing = listing;
            
            // image
            [DataManager getAddressNameFromPoint:listing.address withCompletion:^(NSString *name, NSError * _Nullable error){
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
    }];
}

- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

- (IBAction)confirmClicked:(id)sender {
    [Booking bookDriveway:self.listing
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

@end
