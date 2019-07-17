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
    PFUser *user = [PFUser currentUser];
    
    Booking *newBooking = [Booking new];
    newBooking.driver = user;
    newBooking.homeowner = homeowner;
    
    // Add a relation between the Post and Comment
    PFRelation *relation = [user relationForKey:@"bookings"];
    
    [newBooking saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newBooking];
            [user saveInBackgroundWithBlock:nil];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

+ (void)getBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block {
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"bookings"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:block];
}

@end
