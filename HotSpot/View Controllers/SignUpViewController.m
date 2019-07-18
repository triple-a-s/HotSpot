//
//  SignUpViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//registers a user, throws up an alert with an "empty" error message if one of the fields is empty.
//if there's a different error, it throws up an alert with the specific error description
- (void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    
    //will be initialized once changes in app delegate are pulled
    //newUser.fullName = self.fullName.text;
    //newUser.phoneNumber = self.phoneNumber.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error"
                                                                   message:@"" preferredStyle:UIAlertControllerStyleAlert];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    /*once phone number functionality is working on login, will check
    if there are letters present in the phone number and throw up an alert
    
    NSRange range = {1, self.phoneNumber.text.length};
    if (![self textField:self.phoneNumber shouldChangeCharactersInRange:range replacementString:self.phoneNumber.text]) {
        alert.title = @"Invalid input";
        alert.message = @"The phone number must only contain numbers";
    }*/
    
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        alert.message = @"One or more of your fields is empty";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                alert.message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                [self presentViewController:alert animated:YES completion:^{
                }];
            } else {
                [self performSegueWithIdentifier:(@"signupSegue") sender:nil];
            }
        }];
    }
}

//when the user taps the view, to dismiss the keyboard
- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}

//a method that checks if the current text field has only numbers in it
//returns yes if it does, not if it does not
/*- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
}*/

//dismisses the sign in view controller if the user already has an account
- (IBAction)didTapSignIn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapCreateAccount:(UIButton *)sender {
    [self registerUser];
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
