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
#import "ReportHomeownerViewController.h"
#import "ReportDriverViewController.h"
#import "DamagesViewController.h"
#import <SendGrid.h>
#import <SendGridEmail.h>
#import "EmailHelper.h"

@interface CurrentAndPastDetails ()

@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UILabel *houseAddress;
@property (weak, nonatomic) IBOutlet UILabel *moneySpent;
@property (weak, nonatomic) IBOutlet UILabel *homeOwner;
@property (weak, nonatomic) IBOutlet UILabel *timeParked;
@property (weak, nonatomic) IBOutlet UILabel *bookingProcessing;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@property (strong, nonatomic) Listing *listing;

@end

@implementation CurrentAndPastDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkinButton.hidden = !self.showCheckInCheckOut;
    self.checkoutButton.hidden = !self.showCheckInCheckOut;
    
    // image
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
        [DataManager getAddressNameFromListing:object withCompletion:^(NSString *name, NSError * _Nullable error){
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
        CGFloat duration = [self.booking.duration doubleValue] / 60.0f / 60.0f;
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

//tapping this button brings up an action sheet that allows users
//to choose between predetermined reports to send automatically
//or gives them the option to write their own report
- (IBAction)reportHomeowner:(UIButton *)sender {
    UIAlertController *reportAlert = [UIAlertController alertControllerWithTitle:@"Choose report type"
                                                                        message:@"You can choose between these automated report options, or write your own." preferredStyle:UIAlertControllerStyleActionSheet];
    
    [reportAlert addAction:[UIAlertAction actionWithTitle:(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [reportAlert addAction:[UIAlertAction actionWithTitle:(@"There were damages to my car") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"reportDamagesSegue" sender:nil];
    }]];
    [reportAlert addAction:[UIAlertAction actionWithTitle:(@"My listing was cancelled without 24 hour notice.") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sendEmail(@"My listing was cancelled without 24 hour notice", nil, self.homeOwner.text, @"Homeowner");
        [self performSegueWithIdentifier:@"directReportSegue" sender:nil];
    }]];
    [reportAlert addAction:[UIAlertAction actionWithTitle:(@"There wasn't enough space to park my car.") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sendEmail(@"There wasn't enough space to park my car", nil, self.homeOwner.text, @"Homeowner");
        [self performSegueWithIdentifier:@"directReportSegue" sender:nil];
    }]];
    [reportAlert addAction:[UIAlertAction actionWithTitle:(@"Write Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"reportHomeownerSegue" sender:nil];
    }]];
    [self presentViewController:reportAlert animated:YES completion:nil];
}
- (IBAction)didTapReportDriver:(UIButton *)sender {
    [self performSegueWithIdentifier:@"reportDriverSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Listing *listing = self.booking.listing;
    if ([segue.identifier isEqualToString:@"bookingSegue2"]) {
        BookingViewController *bookingViewController = [segue destinationViewController];
        bookingViewController.listing = listing;
    } else if ([segue.identifier isEqualToString:@"reportHomeownerSegue"]) {
        ReportHomeownerViewController *reportHomeownerViewController = [segue destinationViewController];
        reportHomeownerViewController.houseImage.image = self.houseImage.image;
        reportHomeownerViewController.addressLabel.text = self.houseAddress.text;
        reportHomeownerViewController.nameLabel.text = self.homeOwner.text;
    } else if ([segue.identifier isEqualToString:@"reportDamagesSegue"]) {
        DamagesViewController *damagesViewController = [segue destinationViewController];
        damagesViewController.reportedUser = self.homeOwner.text;
    } else if ([segue.identifier isEqualToString:@"reportDriverSegue"]) {
        ReportDriverViewController *reportDriverViewController = [segue destinationViewController];
        reportDriverViewController.listing = listing;
    }
}
- (IBAction)bookAgain:(id)sender {
    Listing *listing = self.booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
        [self performSegueWithIdentifier:@"bookingSegue2" sender:object];
        }];
}

- (IBAction)bookingBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

