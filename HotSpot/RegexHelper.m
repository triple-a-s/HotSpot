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

BOOL isValidCar(NSString *licensePlate, NSString *carColor, UIAlertController *alert) {
    if ([RegexHelper isEmpty:licensePlate] || [RegexHelper isEmpty:carColor]) {
        alert.title = @"Empty field(s)";
        alert.message = @"Both a license plate and color are required.";
        return false;
    } else if ([RegexHelper isTaken:licensePlate withKey:@"licensePlate"]) {
        alert.title = @"License Plate Taken";
        alert.message = @"That license plate has already been taken.";
        return false;
    } else {
        return true;
    }
}

@implementation RegexHelper

+ (BOOL)isEmpty:(NSString *)givenString {
    if (givenString.length == 0) {
        return true;
    }
    return false;
}

+ (BOOL)isTaken:(NSString *)givenString
        withKey:(NSString *)givenKey {
    PFQuery *query = [Car query];
    [query whereKey:givenKey equalTo:givenString];
    PFObject *object = [query getFirstObject];
    if (object != nil) {
        return true;
    }
    return false;
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
    withAlertController:(UIAlertController *)alert {
    if ([self isEmpty:fullName] || [self isEmpty:username] || [self isEmpty:phoneNumber] || [self isEmpty:email] || [self isEmpty:password]) {
        alert.title = @"Invalid";
        alert.message = @"One or more of your fields is empty.";
        return false;
    } else if (!(phoneNumber.length == 10 || phoneNumber.length == 7)) {
        alert.title = @"Phone Number Change Error";
        alert.message = @"Your phone number is invalid";
        return false;
    } else if (![self validateEmail:email] || [self isTaken:email withKey:@"email"]) {
        alert.title = @"Email invalid";
        alert.message = @"Your email is invalid.";
        return false;
    } else {
        return true;
    }
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
