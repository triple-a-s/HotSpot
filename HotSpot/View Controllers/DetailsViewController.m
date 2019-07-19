//
//  DetailsViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "DetailsViewController.h"

#import "Listing.h"
#import "BookingViewController.h"
#import "DataManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingNotesLabel;

@end

@implementation DetailsViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([@"bookingSegue" isEqualToString:segue.identifier]) {
        UINavigationController *navigationController = [segue destinationViewController];
        BookingViewController *bookingViewController = navigationController.topViewController;
        bookingViewController.listing = self.listing;
    }
}

@end
