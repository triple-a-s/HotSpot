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

@interface DetailsViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingNotesLabel;
@property (strong, nonatomic) NSString *homeownerNumber;
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
    
    
    self.listingPriceLabel.text = [NSString stringWithFormat: @"$%@/hr", self.listing.price];
    PFUser *homeowner = self.listing.homeowner;
    [homeowner fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.listingOwnerLabel.text = object[@"name"];
        
        self.homeownerNumber = object[@"phone"];
    }];
    
    
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
        NSLog(@"Message services are not available.");
    }
    
    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;
    
    // Configure the fields of the interface.
    composeVC.recipients = @[self.homeownerNumber];
    composeVC.body = @"Hello! I am interested in parking at your HotSpot listing. I was wondering ";
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];
}


@end
