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
#import <MessageUI/MessageUI.h>
#import "CallViewController.h"
#import "LocationManagerSingleton.h"
#import "MapKit/MapKit.h"


@interface DetailsViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingNotesLabel;

@property (strong, nonatomic) LocationManagerSingleton *locationManager;

@property (strong, nonatomic) NSString *homeownerNumber;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [DataManager getAddressNameFromListing:self.listing withCompletion:^(NSString *name, NSError * _Nullable error){
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
    
     self.locationManager = [LocationManagerSingleton sharedSingleton];
    
    self.listingPriceLabel.text = [NSString stringWithFormat: @"$%@/hr", self.listing.price];
    PFUser *homeowner = self.listing.homeowner;
    [homeowner fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.listingOwnerLabel.text = object[@"name"];
        self.homeownerNumber = object[@"phone"];
    }];
    
    NSLog(@"%@", self.listing);
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    // Check the result or perform other tasks.    // Dismiss the message compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if([segue.identifier isEqualToString:@"bookingSegue"]) {
        BookingViewController *bookingViewController = [segue destinationViewController];
        bookingViewController.listing = self.listing;
    }
    else if([segue.identifier isEqualToString:@"callSegue"]) {
        CallViewController *callViewController = [segue destinationViewController];
        callViewController.listing = self.listing;
    }
}

- (IBAction)bookingBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactPressed:(id)sender {
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Messaging Error"
                                                                       message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        
        alert.message = @"Message services are not available.";
        
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }
    else {
        MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
        composeVC.messageComposeDelegate = self;
        
        // Configure the fields of the interface.
        composeVC.recipients = @[self.homeownerNumber];
        composeVC.body = @"Hello! I am interested in parking at your HotSpot listing. I was wondering ";
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}

- (IBAction)directionsPressed:(id)sender {
 [self openMap];
 }
 

- (void) openMap{
    Listing *listing = self.listing;
        CLLocationDegrees longitude = listing.address.longitude;
        CLLocationDegrees latitude= listing.address.latitude;
        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", self.locationManager.locationManager.location.coordinate.latitude, self.locationManager.locationManager.location.coordinate.longitude,  latitude, longitude];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving} completionHandler:^(BOOL success) {}];
        } else {
        }
}


@end
