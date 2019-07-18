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
    
    //once database information is pulled from app delegate,
    //these lines will set the current user's text to the current user's full name
    //PFUser *currentUser = [PFUSer currentUser];
    //self.fullName.text = currentUser.fullName;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end