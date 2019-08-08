//
//  Car.m
//  HotSpot
//
//  Created by aaronm17 on 7/22/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Card.h"
#import "Parse/Parse.h"

@interface Card()<PFSubclassing>

@end

@implementation Card

@dynamic type;
@dynamic bank;
@dynamic expiration;
@dynamic number;
@dynamic isDefault;

+ (nonnull NSString *)parseClassName {
    return @"Card";
}

//allows the user to initialize a car with all the info
- (instancetype)initWithInfo:(NSString *)type
                    withBank:(NSString *)bank
              withExpiration:(nonnull NSString *)expiration
                  withNumber:(nonnull NSString *)number
                 withDefault:(BOOL)isDefault {
    if ((self = [super init])) {
        self.type = type;
        self.bank = bank;
        self.expiration = expiration;
        self.number = number;
        self.isDefault = isDefault;
    }
    return self;
}

//adds the passed in car to the database utilizing the changeDefaultCar method
+ (void)addCard:(Card *)newCard
withCompletion: (PFBooleanResultBlock _Nullable) completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"cards"];
    if (newCard.isDefault) {
        [self changeDefaultCard:newCard withUser:user];
    }
    [newCard saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newCard];
            [user saveInBackgroundWithBlock:nil];
        }
    }];
}

//Changes the user's default car to the new default car
+ (void)changeDefaultCard:(Card *)card
                 withUser: (PFUser *)user {
    [user setObject:card forKey:@"defaultCard"];
}

@end
