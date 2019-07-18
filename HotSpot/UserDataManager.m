//
//  UserDataManager.m
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "UserDataManager.h"

#import "Parse/Parse.h"

@implementation UserDataManager
{
    PFRelation *bookingRelation;
    PFUser *user;
}

# pragma mark - Class Methods
+ (instancetype)shared {
    static UserDataManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[self alloc] init];
    });
    return sharedUserManager;
}

# pragma mark - Instance Methods
- (instancetype)init {
    if (self = [super init]) {
        user = [PFUser currentUser];
        bookingRelation = [user relationForKey:@"bookings"];
    }
    return self;
    
}

@end
