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
@property (weak, nonatomic) IBOutlet UIButton *add15MinButton;
@property (weak, nonatomic) IBOutlet UIButton *add1HourButton;
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
            [self updateViews];
        }
    }];
    
    self.addedDuration = 0;
}
- (IBAction)fifteenClicked:(id)sender {
    self.addedDuration += 15 * 60;
    [self updateViews];
}
- (IBAction)hourClicked:(id)sender {
    self.addedDuration += 60 * 60;
    [self updateViews];
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
- (void)updateViews {
    self.endTimeLabel.text = [NSString stringWithFormat:@"End time: %@", [self.timeInterval.endTime dateByAddingTimeInterval:self.addedDuration]];
    [self.booking canAddDuration:self.addedDuration + 15 * 60 WithCompletion:^(BOOL can, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else if (can) {
            self.add15MinButton.enabled = YES;
            self.add15MinButton.alpha = 1.0;
        }
        else {
            self.add15MinButton.enabled = NO;
            self.add15MinButton.alpha = 0.2;
        }
    }];
    [self.booking canAddDuration:self.addedDuration + 60 * 60 WithCompletion:^(BOOL can, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else if (can) {
            self.add1HourButton.enabled = YES;
            self.add1HourButton.alpha = 1.0;
        }
        else {
            self.add1HourButton.enabled = NO;
            self.add1HourButton.alpha = 0.2;
        }
    }];
}

@end
