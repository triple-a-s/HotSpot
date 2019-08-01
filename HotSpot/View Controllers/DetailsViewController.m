//
//  DetailsViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "DetailsViewController.h"
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"bookingSegue"]) {
        BookingViewController *bookingViewController = [segue destinationViewController];
        bookingViewController.listing = self.listing;
    }
}

- (IBAction)bookingBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
