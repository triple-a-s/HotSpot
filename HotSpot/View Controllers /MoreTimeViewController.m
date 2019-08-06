//
//  MoreTimeViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MoreTimeViewController.h"

@interface MoreTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation MoreTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)fifteenClicked:(id)sender {
}
- (IBAction)hourClicked:(id)sender {
}
- (IBAction)doneClicked:(id)sender {
}
- (IBAction)nevermindClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
