//
//  ConfirmationViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 2;
}

@end
