//
//  Booking.m
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Booking.h"

#import "Listing.h"

@interface Booking()<PFSubclassing>
@end

@implementation Booking

@dynamic driver;
@dynamic listing;
@dynamic startTime;
@dynamic duration;
@dynamic timeInterval;

# pragma mark - Class Methods

+ (nonnull NSString *)parseClassName {
    return @"Booking";
}

+ (void)bookDriveway:(Listing * _Nullable)listing
       withStartTime:(NSDate * _Nullable)startTime
   withDurationInSec:(NSNumber * _Nullable)duration
      withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    PFUser *user = [PFUser currentUser];
    
    Booking *newBooking = [Booking new];
    newBooking.driver = user;
    newBooking.listing = listing;
    
    if (startTime) {
        newBooking.startTime = startTime;
    }
    else {
        newBooking.startTime = [[NSDate alloc] init]; // by default the booking time slot starts now
    }
    
    if (duration) {
        newBooking.duration = duration;
    }
    else {
        newBooking.duration = @3600; // by default the booking lasts for an hour
    }
    
    TimeInterval *requestedTime = [TimeInterval new];
    
    requestedTime.startTime = startTime;
    requestedTime.endTime = [startTime initWithTimeInterval:[duration doubleValue] sinceDate:startTime];
    requestedTime.repeatsWeekly = NO; // homeowners can book one continuguous time interval only
    
    newBooking.timeInterval = requestedTime;
 
    
    [listing canBook:newBooking
      withCompletion:^(BOOL can, NSError * _Nullable error) {
          if(error) {
              NSLog(@"%@", error);
          }
          else if(can) {
              PFRelation *relation = [user relationForKey:@"bookings"];
              PFRelation *listingBookingsRelation = [listing relationForKey:@"bookings"];
              PFRelation *listingUnavailableRelation = [listing relationForKey:@"unavailable"];
              
              [newBooking saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                  if (succeeded) {
                      [relation addObject:newBooking];
                      [user saveInBackground];
                      [listingBookingsRelation addObject:newBooking];
                      [listingUnavailableRelation addObject:requestedTime];
                      [listing saveInBackground];
                      if(completion) {
                          completion(succeeded, error);
                      }
                  }
                  else {
                      NSLog(@"%@", error);
                  }
              }];
          }
          else {
              completion(NO, error);
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

# pragma mark - Public Methods
- (void)cancel {
    PFUser *user = self.driver;
    [[user relationForKey:@"bookings"] removeObject:self];
    
    Listing *listing = self.listing;
    [[listing relationForKey:@"bookings"] removeObject:self];
    
    [self deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@ error deleting booking", error);
        }
    }];
}

- (void)canAddDuration:(CGFloat)duration WithCompletion:(void(^)(BOOL can, NSError * _Nullable error))completion{
    Booking *newBooking = [Booking new];
    newBooking.timeInterval = [TimeInterval new];
    newBooking.timeInterval.startTime = self.timeInterval.endTime;
    newBooking.timeInterval.endTime = [newBooking.timeInterval.startTime dateByAddingTimeInterval:duration];
    [self.listing canBook:newBooking
           withCompletion:completion];
}

@end
