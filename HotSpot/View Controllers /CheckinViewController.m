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

@interface CheckinViewController ()
@property (strong, nonatomic) Booking *booking;
@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // get the next booking for this user
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"bookings"];
    PFQuery *query = relation.query;
    [query orderByAscending:@"startTime"];
    [query whereKey:@"startTime" greaterThan:[[NSDate alloc] init]];
    
    // fetch data asynchronously
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            self.booking = object;
        }
    }];
}
- (IBAction)checkinClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"cancelSegue"]) {
        CancelViewController *cancelViewController = [segue destinationViewController];
        cancelViewController.booking = self.booking;
    }
}

@end
