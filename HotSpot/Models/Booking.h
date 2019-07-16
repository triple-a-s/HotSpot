//
//  Booking.h
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Booking : PFObject
@property (nonatomic, strong) PFUser *driver;
@property (nonatomic, strong) PFUser *homeowner;

+ (void)bookDriveway:(PFUser * _Nullable)homeowner
      withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
