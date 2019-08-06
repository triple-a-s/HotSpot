//
//  TimeSlot.h
//  HotSpot
//
//  Created by drealin on 7/24/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeSlot : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign, readwrite) NSInteger item;
@property (nonatomic, assign, readwrite) NSInteger hour;
@property (nonatomic, assign, readwrite) NSInteger minute;
@property (nonatomic, assign, readwrite) BOOL chosen;
@property (nonatomic, assign, readwrite) BOOL available;
- (void)setTime:(NSInteger)item withDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
