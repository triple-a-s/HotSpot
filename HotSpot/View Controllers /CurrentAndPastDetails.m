//
//  CurrentAndPastDetails.m
//  HotSpot
//
//  Created by aodemuyi on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CurrentAndPastDetails.h"
#import "DataManager.h"
#import "BookingViewController.h"

@interface CurrentAndPastDetails ()

@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UILabel *houseAddress;
@property (weak, nonatomic) IBOutlet UILabel *moneySpent;
@property (weak, nonatomic) IBOutlet UILabel *homeOwner;
@property (weak, nonatomic) IBOutlet UILabel *timeParked;
@property (weak, nonatomic) IBOutlet UILabel *bookingProcessing;
@property (strong, nonatomic) Listing *listing;
@end

@implementation CurrentAndPastDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // image
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
        [DataManager getAddressNameFromPoint:object[@"address"] withCompletion:^(NSString *name, NSError * _Nullable error){
            if(error) {
                NSLog(@"%@", error);
            }
            else {
                self.houseAddress.text = name;
            }
        }];
        PFFileObject *img = object[@"picture"];
        [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
            UIImage *imageToLoad = [UIImage imageWithData:imageData];
            self.houseImage.image = imageToLoad;
        }];
        int priceSet = [object[@"price"] intValue];
        CGFloat duration = [self.booking.duration doubleValue] / 60.0f;
        self.moneySpent.text = [NSString stringWithFormat: @"$%.2f", priceSet * duration];
        PFUser *homeowner = object[@"homeowner"];
        [homeowner fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.homeOwner.text = object[@"name"];
        }];
        
    }];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
    if([segue.identifier isEqualToString:@"bookingSegue2"]) {
        BookingViewController *bookingViewController = [segue destinationViewController];
        bookingViewController.listing = listing;
    }
    }];
}
- (IBAction)bookAgain:(id)sender {
    if (!self.bookAgainButton.hidden){
    [self performSegueWithIdentifier:@"bookingSegue2" sender:self];
    }
}

- (IBAction)bookingBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
