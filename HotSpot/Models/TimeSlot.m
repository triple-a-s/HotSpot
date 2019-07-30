//
//  TimeSlot.m
//  HotSpot
//
//  Created by drealin on 7/24/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TimeSlot.h"

@implementation TimeSlot
- (instancetype)init {
    self = [super init];
    self.chosen = NO;
    self.available = YES;
    return self;
}
- (void)setTime:(NSInteger)item withDate:(NSDate *)date{
    /**
     transforms the indexpath.item, a number from 0 to 95, to a time in 15 minute intervals from 0:00 to 23:45
     **/
    NSInteger buffer = 2; // buffer for calculations, in terms of seconds
    self.hour = item / 4;
    self.minute = item % 4 * 15;
    self.date = [date dateByAddingTimeInterval:(self.hour * 60 + self.minute) * 60 + buffer];
}
@end
