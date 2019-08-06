//
//  TransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapProfilePage:(UIButton *)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 0;
}


@end
