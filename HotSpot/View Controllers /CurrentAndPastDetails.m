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
#import "MapKit/MapKit.h"
#import "LocationManagerSingleton.h"

@interface CurrentAndPastDetails ()

@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UILabel *houseAddress;
@property (weak, nonatomic) IBOutlet UILabel *moneySpent;
@property (weak, nonatomic) IBOutlet UILabel *homeOwner;
@property (weak, nonatomic) IBOutlet UILabel *timeParked;
@property (weak, nonatomic) IBOutlet UILabel *bookingProcessing;
@property (strong, nonatomic) Listing *listing;
@property (strong, nonatomic) LocationManagerSingleton *locationManager;

@end

@implementation CurrentAndPastDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [LocationManagerSingleton sharedSingleton];
    // image
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
        [DataManager getAddressNameFromListing:object[@"address"] withCompletion:^(NSString *name, NSError * _Nullable error){
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
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy' at 'hh:mm"];
        self.bookingProcessing.text = [formatter stringFromDate: self.booking.createdAt];
        self.timeParked.text = [formatter stringFromDate:self.booking.startTime];
        
        
    }];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Listing *listing = self.booking.listing;
    if([segue.identifier isEqualToString:@"bookingSegue2"]) {
        BookingViewController *bookingsViewController = [segue destinationViewController];
        bookingsViewController.listing = listing;
    }
}



- (IBAction)bookingBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)directionsPressed:(id)sender {
    [self openMap];
}


- (void) openMap{
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
        CLLocationDegrees longitude = listing.address.longitude;
        CLLocationDegrees latitude= listing.address.latitude;
        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", self.locationManager.locationManager.location.coordinate.latitude, self.locationManager.locationManager.location.coordinate.longitude,  latitude, longitude];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving} completionHandler:^(BOOL success) {}];
        } else {
        }
    }];
}



@end
