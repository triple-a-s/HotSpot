//
//  RegexHelper.m
//  HotSpot
//
//  Created by aaronm17 on 7/26/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "RegexHelper.h"
#import "Parse/Parse.h"
#import "Car.h"
#import <UIKit/UIKit.h>

BOOL isValidCar(NSString *licensePlate, NSString *carColor, UIAlertController *alert, BOOL isSameLicensePlate) {
    if ([RegexHelper isEmpty:licensePlate] || [RegexHelper isEmpty:carColor]) {
        alert.title = @"Empty field(s)";
        alert.message = @"Both a license plate and color are required.";
        return false;
    } else if (licensePlate.length != 7) {
        alert.title = @"Invalid license plate";
        alert.message = @"The license plate must be 7 characters";
        return false;
    } else if ([RegexHelper isTaken:licensePlate]) {
        if (isSameLicensePlate) {
            return true;
        }
        alert.title = @"License Plate Taken";
        alert.message = @"That license plate has already been taken.";
        return false;
    }
    return true;
}

BOOL isProfileTaken(NSString * _Nonnull username) {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    PFObject *object = [query getFirstObject];
    return (object != nil);
}


@implementation RegexHelper

+ (BOOL)isEmpty:(NSString *)givenString {
    return (givenString.length == 0);
}

+ (BOOL)isTaken:(NSString *)givenString {
    PFQuery *query = [Car query];
    [query whereKey:@"licensePlate" equalTo:givenString];
    PFObject *object = [query getFirstObject];
    return (object != nil);
}

+ (BOOL) validateEmail: (NSString *) emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL)isValidProfile:(NSString *)username
          withPassword:(NSString *)password
             withEmail:(NSString *)email
          withFullName:(NSString *)fullName
       withPhoneNumber:(NSString *)phoneNumber
    withAlertController:(UIAlertController *)alert
        withSameProfile:(BOOL)isSameProfile{
    if ([self isEmpty:fullName] || [self isEmpty:username] || [self isEmpty:phoneNumber] || [self isEmpty:email] || [self isEmpty:password]) {
        alert.title = @"Invalid";
        alert.message = @"One or more of your fields is empty.";
        return false;
    } else if (!(phoneNumber.length == 10 || phoneNumber.length == 7)) {
        alert.title = @"Phone Number Change Error";
        alert.message = @"Your phone number is invalid";
        return false;
    } else if (![self validateEmail:email] || [self isTaken:email]) {
        alert.title = @"Email invalid";
        alert.message = @"Your email is invalid.";
        return false;
    } else if (isProfileTaken(username)) {
        if (isSameProfile) {
            return true;
        }
        alert.title = @"Username invalid";
        alert.message = @"That username has already been taken";
        return false;
    }
    return true;
}

+ (UIAlertController*)createAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    return alert;
}



@end
