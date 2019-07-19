//
//  TimeInterval.h
//  HotSpot
//
//  Created by drealin on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeInterval : PFObject
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSNumber *repeatsWeekly;
- (NSDateInterval * _Nullable)intersectionWithTimeInterval:(TimeInterval *)timeInterval;
@end

NS_ASSUME_NONNULL_END
