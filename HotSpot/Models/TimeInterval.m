//
//  TimeInterval.m
//  HotSpot
//
//  Created by drealin on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TimeInterval.h"
#import <UIKit/UIKit.h>

@interface TimeInterval()<PFSubclassing>
@end

@implementation TimeInterval
{
    NSDateInterval *dateInterval;
}
@dynamic startTime;
@dynamic endTime;
@dynamic repeatsWeekly;

# pragma mark - Class Methods
+ (nonnull NSString *)parseClassName {
    return @"TimeInterval";
}

# pragma mark - Public Methods
- (NSDateInterval * _Nullable)intersectionWithTimeInterval:(TimeInterval *)timeInterval {
    CGFloat buffer = 2; // in seconds
    if(!dateInterval) {
        dateInterval = [[NSDateInterval alloc] initWithStartDate:[self.startTime dateByAddingTimeInterval:buffer] endDate:[self.endTime dateByAddingTimeInterval:-buffer]];
    }
    NSDateInterval *theirDateInterval = [[NSDateInterval alloc] initWithStartDate:timeInterval.startTime endDate:timeInterval.endTime];
    if (self.repeatsWeekly) {
        CGFloat secondsPerDay = 60 * 60 * 24;
        NSInteger differenceInDays = [theirDateInterval.startDate timeIntervalSinceReferenceDate] / secondsPerDay - [dateInterval.startDate timeIntervalSinceReferenceDate] / secondsPerDay;
        if( differenceInDays % 7 == 0) {
            NSDateInterval *adjustedDateInterval = [[NSDateInterval alloc] initWithStartDate:[dateInterval.startDate dateByAddingTimeInterval:differenceInDays * secondsPerDay] endDate:[dateInterval.endDate dateByAddingTimeInterval:differenceInDays * secondsPerDay]];
            return [adjustedDateInterval intersectionWithDateInterval:theirDateInterval];
        }
        else {
            return nil;
        }
    }
    else {
        return [dateInterval intersectionWithDateInterval:theirDateInterval];
    }
}


@end
