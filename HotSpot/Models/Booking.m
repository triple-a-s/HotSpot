//
//  Booking.m
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Booking.h"

#import "Parse.h"
#import "Listing.h"

@interface Booking()<PFSubclassing>
@end

@implementation Booking

@dynamic driver;
@dynamic listing;
@dynamic startTime;

# pragma mark - Class Methods

+ (nonnull NSString *)parseClassName {
    return @"Booking";
}

+ (void)bookDriveway:(Listing * _Nullable)listing
      withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    PFUser *user = [PFUser currentUser];
    
    Booking *newBooking = [Booking new];
    newBooking.driver = user;
    newBooking.listing = listing;
    newBooking.startTime = [[NSDate alloc] init]; // by default the booking time slot starts now
    
    PFRelation *relation = [user relationForKey:@"bookings"];
    PFRelation *listingBookingsRelation = [listing relationForKey:@"bookings"];

    [newBooking saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newBooking];
            [user saveInBackgroundWithBlock:nil];
            [listingBookingsRelation addObject:newBooking];
            [listing saveInBackgroundWithBlock:nil];
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

+ (void)getCurrentBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"bookings"];
    PFQuery *query = relation.query;
    [query orderByAscending:@"startTime"];
    [query whereKey:@"startTime" greaterThan:[[NSDate alloc] init]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:block];
}

+ (void)getPastBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"bookings"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"startTime"]; // most recent is listed first
    [query whereKey:@"startTime" lessThanOrEqualTo:[[NSDate alloc] init]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:block];
}

@end
