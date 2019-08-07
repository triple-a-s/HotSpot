//
//  SettingsReportTransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SettingsReportTransitionViewController.h"

@interface SettingsReportTransitionViewController ()

@end

@implementation SettingsReportTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapReturn:(UIButton *)sender {
    [self performSegueWithIdentifier:@"returnSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 4;
}


@end
