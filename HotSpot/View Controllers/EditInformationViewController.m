//
//  EditInformationViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "EditInformationViewController.h"
#import "Parse/Parse.h"
#import "RegexHelper.h"

@interface EditInformationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL isSameProfile;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSameProfile = NO;
    self.currentUser = [PFUser currentUser];
    [self.currentUser saveInBackground];
    self.fullName.text = self.currentUser[@"name"];
    self.phoneNumber.text = self.currentUser[@"phone"];
    self.email.text = self.currentUser[@"email"];
    self.username.text = self.currentUser.username;
    
}

//checks if each field is equal to its corresponding field in the database
//if not, sets the database field to the one inputted by the user
- (IBAction)didTapSaveChanges:(UIButton *)sender {
    UIAlertController *alert = [RegexHelper createAlertController:@"" withMessage:@""];
    
    if ([self.currentUser.username isEqualToString:self.username.text]) {
        self.isSameProfile = YES;
    }
    if ([RegexHelper isValidProfile:self.username.text withPassword:self.username.text withEmail:self.email.text withFullName:self.fullName.text withPhoneNumber:self.phoneNumber.text withAlertController:alert withSameProfile:self.isSameProfile]) {
        self.currentUser[@"name"] = self.fullName.text;
        self.currentUser.username = self.username.text;
        self.currentUser[@"phone"] = self.phoneNumber.text;
        self.currentUser[@"email"] = self.email.text;
        [self.currentUser saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}



- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}




@end
