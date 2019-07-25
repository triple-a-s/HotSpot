//
//  Listing.h
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN
@class Booking;
@interface Listing : PFObject
@property (nonatomic, strong) PFGeoPoint *address;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) PFUser *homeowner;
- (void)canBook:(Booking *)booking withCompletion:(void(^)(BOOL can, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
