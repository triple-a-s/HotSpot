//
//  SignUpViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "RegexHelper.h"
#import <AccountKit/AKFAccountKit.h>
#import <AccountKit/AKFViewController.h>
#import <AccountKit/AKFSkinManager.h>
#import <AccountKit/AKFPhoneNumber.h>

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) BOOL isAuthenticated;

@end

@implementation SignUpViewController {
    AKFAccountKit *accountKit;
    NSString *authorizationCode;
    UIViewController<AKFViewController> *pendingSignUpViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    pendingSignUpViewController = [accountKit viewControllerForLoginResume];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (pendingSignUpViewController != nil) {
        [self _prepareSignUpViewController:pendingSignUpViewController];
        [self presentViewController:pendingSignUpViewController animated:YES completion:nil];
        pendingSignUpViewController = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.isAuthenticated) {
        UIAlertController *alert = [RegexHelper createAlertController];
        PFUser *newUser = [PFUser user];
        
        newUser.username = self.username.text;
        newUser.password = self.password.text;
        newUser[@"name"] = self.fullName.text;
        newUser[@"phone"] = self.phoneNumber.text;
        newUser.email = self.email.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                //if there's an error, throw up an alert with the specific error as the message
                alert.message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }];
        [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text block:^(PFUser *user, NSError *error) {
            if (error != nil) {
                alert.message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                [self presentViewController:alert animated:YES completion:^{
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
                    self.isAuthenticated = NO;
                });
            }
        }];
    }
}
//registers a user, throws up an alert with an "empty" error message if one of the fields is empty.
//if there's a different error, it throws up an alert with the specific error description
- (void)registerUser {
    UIAlertController *alert = [RegexHelper createAlertController];
    
    //checks if any of the fields are empty
    //checks if the phone number is 7 or 10 digits
    //if anything is wrong it will throw up an appropriate error
    if ([RegexHelper isValidProfile:self.username.text withPassword:self.password.text withEmail:self.email.text withFullName:self.fullName.text withPhoneNumber:self.phoneNumber.text withAlertController:alert withSameProfile:NO]) {
        AKFPhoneNumber *phoneNumber = [[AKFPhoneNumber alloc] initWithCountryCode:@"" phoneNumber:self.phoneNumber.text];
        UIViewController<AKFViewController> *viewController = [accountKit viewControllerForPhoneLoginWithPhoneNumber:phoneNumber state:nil];
        [self _prepareSignUpViewController:viewController];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

//when the user taps the view, to dismiss the keyboard
- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}

//dismisses the sign in view controller if the user already has an account
- (IBAction)didTapSignIn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapCreateAccount:(UIButton *)sender {
    [self registerUser];
}

#pragma mark - AKFViewController methods

- (void) _prepareSignUpViewController:(UIViewController<AKFViewController> *)signUpVC {
    signUpVC.delegate = self;
    signUpVC.uiManager = [[AKFSkinManager alloc] initWithSkinType:AKFSkinTypeClassic primaryColor:[UIColor blueColor]];
}

#pragma mark - AKFViewController delegate methods

- (void) viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(nonnull NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void) viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(nonnull id<AKFAccessToken>)accessToken state:(nonnull NSString *)state {
    self.isAuthenticated = YES;
}

@end
