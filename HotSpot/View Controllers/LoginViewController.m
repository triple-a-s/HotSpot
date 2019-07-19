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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                                                                   message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        alert.message = @"Your username or password is empty";
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
