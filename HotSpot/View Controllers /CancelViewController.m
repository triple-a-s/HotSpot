//
//  CancelViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController ()

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelConfirmClicked:(id)sender {
    [self.booking cancel];
    [self performSegueWithIdentifier:@"cancelSegue" sender:nil];
}
- (IBAction)goBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"cancelSegue"]) {
        UITabBarController *tabBar = segue.destinationViewController;
        tabBar.selectedIndex = 2;
    }
}

@end
