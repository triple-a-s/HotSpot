//
//  TransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TransitionViewController.h"
#import "FancyButton.h"

@interface TransitionViewController ()
@property (weak, nonatomic) IBOutlet FancyButton *profileButton;

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [UIView animateWithDuration: 2
                     animations:^{
                         self.profileButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                          }completion:^(BOOL finished) {
                         [UIView animateWithDuration:2
                                          animations:^{
                         }];
                     }];
    
    [super viewDidLoad];
    [super viewDidLoad];
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
