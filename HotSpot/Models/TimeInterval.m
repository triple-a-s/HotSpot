//
//  TimeInterval.m
//  HotSpot
//
//  Created by drealin on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TimeInterval.h"

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

# pragma mark - Instance Methods
- (NSDateInterval * _Nullable)intersectionWithTimeInterval:(TimeInterval *)timeInterval {
    if(!dateInterval) {
        dateInterval = [[NSDateInterval alloc] initWithStartDate:self.startTime endDate:self.endTime];
    }
    NSDateInterval *theirDateInterval = [[NSDateInterval alloc] initWithStartDate:timeInterval.startTime endDate:timeInterval.endTime];
    if (self.repeatsWeekly) {
        double secondsPerDay = 60 * 60 * 24;
        int differenceInDays = [dateInterval.startDate timeIntervalSinceReferenceDate] / secondsPerDay - [theirDateInterval.startDate timeIntervalSinceReferenceDate] / secondsPerDay;
        if( differenceInDays % 7 == 0) {
            NSDateInterval *adjustedDAteInterval = [[NSDateInterval alloc] initWithStartDate:[dateInterval.startDate dateByAddingTimeInterval:differenceInDays] endDate:[dateInterval.endDate dateByAddingTimeInterval:differenceInDays]];
            return [adjustedDAteInterval intersectionWithDateInterval:theirDateInterval];
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
