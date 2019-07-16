//
//  Booking.m
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Booking.h"
#import "Parse.h"

@interface Booking()<PFSubclassing>
@end

@implementation Booking

@dynamic driver;
@dynamic homeowner;

# pragma mark - Class Methods

+ (nonnull NSString *)parseClassName {
    return @"Booking";
}

+ (void)bookDriveway:(PFUser * _Nullable)homeowner
      withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Booking *newBooking = [Booking new];
    newBooking.driver = [PFUser currentUser];
    newBooking.homeowner = homeowner;
    
    [newBooking saveInBackgroundWithBlock: completion];
}
@end
