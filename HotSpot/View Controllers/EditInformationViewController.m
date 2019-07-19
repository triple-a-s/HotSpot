//
//  EditInformationViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "EditInformationViewController.h"
#import "Parse/Parse.h"

@interface EditInformationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    self.alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         nil;
                                                     }];
    // add the OK action to the alert controller
    [self.alert addAction:okAction];
}

- (IBAction)didTapSaveChanges:(UIButton *)sender {
    //need to add an alert controller and check for empty strings, then save the user in the background
}

- (IBAction)didEditFullName:(UITextField *)sender {
    if (self.fullName.text.length == 0) {
        self.alert.title = @"Full Name Change Error";
        self.alert.message = @"Your full name cannot be empty";
        [self presentViewController:self.alert animated:YES completion:^{
        }];
    } else {
        self.currentUser[@"name"] = self.fullName.text;
    }
}

- (IBAction)didEditUsername:(UITextField *)sender {
    if (self.username.text.length == 0) {
        self.alert.title = @"Username Change Error";
        self.alert.message = @"Your username cannot be empty";
        [self presentViewController:self.alert animated:YES completion:^{
        }];
    } else {
        self.currentUser.username = self.username.text;
    }
}

- (IBAction)didEditPassword:(UITextField *)sender {
    if (self.password.text.length == 0) {
        self.alert.title = @"Password Change Error";
        self.alert.message = @"Your password cannot be empty";
        [self presentViewController:self.alert animated:YES completion:^{
        }];
    } else {
        self.currentUser.password = self.password.text;
    }
}

- (IBAction)didEditEmail:(UITextField *)sender {
    if (self.email.text.length == 0) {
        self.alert.title = @"Email Change Error";
        self.alert.message = @"Your email cannot be empty";
        [self presentViewController:self.alert animated:YES completion:^{
        }];
    } else {
        self.currentUser[@"email"] = self.email.text;
    }
}

- (IBAction)didEditPhoneNumber:(UITextField *)sender {
    if (self.phoneNumber.text.length != 10) {
        self.alert.title = @"Phone Number Change Error";
        self.alert.message = @"Your phone number is invalid";
        [self presentViewController:self.alert animated:YES completion:^{
        }];
    } else {
        self.currentUser[@"phone"] = self.phoneNumber.text;
    }
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
