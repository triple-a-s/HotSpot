//
//  CheckoutViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CheckoutViewController.h"

#import "Booking.h"
#import "DataManager.h"
#import "MoreTimeViewController.h"

@interface CheckoutViewController ()
@property (strong, nonatomic) Booking *booking;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DataManager getNextBookingWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            Booking *booking = object;
            self.booking = booking;
        }
    }];
}
- (IBAction)checkoutClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"moreTimeSegue"]) {
        MoreTimeViewController *moreTimeViewController = [segue destinationViewController];
        moreTimeViewController.booking = self.booking;
    }
}
@end
