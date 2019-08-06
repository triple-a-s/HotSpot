//
//  SettingsViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fullName;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    self.fullName.text = currentUser[@"name"];
}

//logs out the user and takes them to login page
- (IBAction)didTapLogout:(UIButton *)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginSignUp" bundle:nil];
        
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        appDelegate.window.rootViewController = loginViewController;
    }];
}

@end
