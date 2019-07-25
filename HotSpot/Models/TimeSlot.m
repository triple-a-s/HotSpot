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
@end
