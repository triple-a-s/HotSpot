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
#import "Card.h"
#import <UIKit/UIKit.h>

//returns whether the car is "valid", by performing checks such as empty fields,
//incorrect field lengths, and if the license plate is taken
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

BOOL isValidCard(NSString *type, NSString *bank, NSString *expiration, NSString *number, UIAlertController *cardAlert, BOOL isSameNumber) {
    if ([RegexHelper isEmpty:type] || [RegexHelper isEmpty:bank] || [RegexHelper isEmpty:expiration] || [RegexHelper isEmpty:number]) {
        cardAlert.title = @"Empty field(s)";
        cardAlert.message = @"All fields are required";
        return false;
    } else if (number.length != 4) {
        cardAlert.title = @"Invalid number";
        cardAlert.message = @"The number must be 4 characters";
        return false;
    } else if ([RegexHelper isCardTaken:number]) {
        if (isSameNumber) {
            return true;
        }
        cardAlert.title = @"Number Taken";
        cardAlert.message = @"That number has already been taken.";
        return false;
    }
    return true;
}

//returns whether or not there are any profiles with a certain username passed in as a parameter
BOOL isProfileTaken(NSString * _Nonnull info, NSString * _Nonnull key) {
    PFQuery *query = [PFUser query];
    [query whereKey:key equalTo:info];
    PFObject *object = [query getFirstObject];
    return (object != nil);
}

@implementation RegexHelper

//returns whether or not the passed in string is empty
+ (BOOL)isEmpty:(NSString *)givenString {
    return (givenString.length == 0);
}

//returns whether there's a licensePlate matching the passed in string in the database
+ (BOOL)isTaken:(NSString *)givenString {
    PFQuery *query = [Car query];
    [query whereKey:@"licensePlate" equalTo:givenString];
    PFObject *object = [query getFirstObject];
    return (object != nil);
}

//returns whether there's a card number matching the one passed in as a string
//in the database
+ (BOOL)isCardTaken:(NSString *)givenString {
    PFQuery *query = [Card query];
    [query whereKey:@"number" equalTo:givenString];
    PFObject *object = [query getFirstObject];
    return (object != nil);
}
//returns whether or not the email passed in is valid using regex
+ (BOOL) validateEmail: (NSString *) emailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
}

//returns whether the profile is valid by performing numerous checks,
//such as checking whether fields are empty, checking for correct field lengths
//checking whether the email is valid and checking whether the username has been used before
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
    } else if (![self validateEmail:email] || isProfileTaken(email, @"email")) {
        alert.title = @"Email invalid";
        alert.message = @"Your email is invalid.";
        return false;
    } else if (isProfileTaken(username, @"username")) {
        if (isSameProfile) {
            return true;
        }
        alert.title = @"Username invalid";
        alert.message = @"That username has already been taken";
        return false;
    }
    return true;
}

//creates an alert controller
+ (UIAlertController*)createAlertController:(NSString *)title
                                withMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message preferredStyle:UIAlertControllerStyleAlert];
    
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
