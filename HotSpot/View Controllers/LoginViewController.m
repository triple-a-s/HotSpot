//
//  LoginViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Helper Methods

//logs in the user, throws up errors if one of the fields is empty,
//or if there's an error during login
- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                         }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    if ([self.username.text isEqual:@""] || [self.password.text isEqual:@""]) {
        alert.message = @"Your username or password is empty";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                alert.message = [NSString stringWithFormat:@"%@", error.localizedDescription];
            } else {
                NSLog(@"User logged in successfully");
                //[self performSegueWithIdentifier:@"LoginSegue" sender:nil];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
