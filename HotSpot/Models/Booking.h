//
//  Booking.h
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>
#import "TimeInterval.h"

NS_ASSUME_NONNULL_BEGIN
@class Listing;
@interface Booking : PFObject
@property (nonatomic, strong) PFUser *driver;
@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) TimeInterval *timeInterval;

+ (void)bookDriveway:(Listing * _Nullable)listing
       withStartTime:(NSDate * _Nullable)startTime
   withDurationInSec:(NSNumber * _Nullable)duration
      withCompletion:(PFBooleanResultBlock  _Nullable)completion;

+ (void)getBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block;

+ (void)getCurrentBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block;

+ (void)getPastBookingsWithBlock:(void(^)(NSArray<Booking *> *bookings, NSError *error))block;

- (void)cancel;
- (void)canAddDuration:(CGFloat)duration WithCompletion:(void(^)(BOOL can, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
