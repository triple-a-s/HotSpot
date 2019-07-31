//
//  LoginViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "RegexHelper.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//logs in a user, throws up an alert with an "empty" error message if one of the fields is empty.
//if there's a different error, it throws up an alert with the specific error description
- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    UIAlertController *alert = [RegexHelper createAlertController];
    
    if ([RegexHelper isEmpty:self.username.text] || [RegexHelper isEmpty:self.password.text]) {
        alert.message = @"Your username or password is empty";
        alert.title = @"Login Error";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error != nil) {
                alert.message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                [self presentViewController:alert animated:YES completion:^{
                }];
            } else {
                [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
            }
        }];
    }
}

//when the user taps the view, to dismiss the keyboard
- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}


- (IBAction)didTapLogin:(UIButton *)sender {
    [self loginUser];
}

@end
