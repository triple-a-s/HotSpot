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
@property (nonatomic, assign, readwrite) BOOL selected;
@property (nonatomic, assign, readwrite) BOOL available;
@end

NS_ASSUME_NONNULL_END
