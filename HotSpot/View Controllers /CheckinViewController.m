//
//  CheckinViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CheckinViewController.h"

#import "Booking.h"
#import "CancelViewController.h"
#import "DataManager.h"

@interface CheckinViewController ()
@property (strong, nonatomic) Booking *booking;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DataManager getNextBookingWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            Booking *booking = object;
            self.booking = booking;
            [booking.listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                Listing *listing = object;
                [DataManager getAddressNameFromPoint:listing.address withCompletion:^(NSString *name, NSError * _Nullable error){
                    if(error) {
                        NSLog(@"%@", error);
                    }
                    else {
                        self.addressLabel.text = name;
                    }
                }];
            }];
            self.startTimeLabel.text = [NSString stringWithFormat:@"Start time: %@", booking.startTime];
        }
    }];
}
- (IBAction)checkinClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"cancelSegue"]) {
        CancelViewController *cancelViewController = [segue destinationViewController];
        cancelViewController.booking = self.booking;
    }
}

@end
