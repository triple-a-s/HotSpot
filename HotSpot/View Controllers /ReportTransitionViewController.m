//
//  ReportTransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ReportTransitionViewController.h"

@interface ReportTransitionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *transitionButton;

@end

@implementation ReportTransitionViewController

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
    if ([segue.identifier isEqualToString:@"returnSegue"]) {
        UITabBarController *tabBar = segue.destinationViewController;
        tabBar.selectedIndex = 2;
    }
}

@end
