//
//  RegexHelper.h
//  HotSpot
//
//  Created by aaronm17 on 7/26/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Car.h"

BOOL isValidCar(NSString * _Nonnull licensePlate, NSString * _Nonnull carColor, UIAlertController * _Nonnull alert);

NS_ASSUME_NONNULL_BEGIN

@interface RegexHelper : NSObject

+ (BOOL)isEmpty:(NSString *)givenString;

+ (BOOL)isTaken:(NSString *)givenString
          withKey:(NSString *)givenKey;

+ (BOOL)validateEmail:(NSString *)emailAddress;

+ (BOOL)isValidProfile:(NSString *)username
        withPassword:(NSString *)password
           withEmail:(NSString *)email
        withFullName:(NSString *)fullName
     withPhoneNumber:(NSString *)phoneNumber
 withAlertController:(UIAlertController *)alert;

+ (UIAlertController*)createAlertController;


@end

NS_ASSUME_NONNULL_END
