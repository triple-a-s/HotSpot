//
//  MoreTimeViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MoreTimeViewController.h"

#import "Parse/Parse.h"
#import "TimeInterval.h"
@interface MoreTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, assign, readwrite) CGFloat addedDuration;
@property (strong, nonatomic) TimeInterval* timeInterval;
@end

@implementation MoreTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.booking.timeInterval fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            TimeInterval *timeInterval = object;
            self.timeInterval = timeInterval;
            self.endTimeLabel.text = [NSString stringWithFormat:@"End time: %@", timeInterval.endTime];
        }
    }];
    
    self.addedDuration = 0;
    
}
- (IBAction)fifteenClicked:(id)sender {
    self.addedDuration += 15 * 60;
    [self updateTimeLabel];
}
- (IBAction)hourClicked:(id)sender {
    self.addedDuration += 60 * 60;
    [self updateTimeLabel];
}
- (IBAction)doneClicked:(id)sender {
    self.timeInterval.endTime = [self.timeInterval.endTime dateByAddingTimeInterval:self.addedDuration];
    [self.timeInterval saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}
- (IBAction)nevermindClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateTimeLabel {
    self.endTimeLabel.text = [NSString stringWithFormat:@"End time: %@", [self.timeInterval.endTime dateByAddingTimeInterval:self.addedDuration]];
}

@end
