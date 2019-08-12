//
//  TimeCell.h
//  HotSpot
//
//  Created by drealin on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSlot.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeCell : UICollectionViewCell
@property (nonatomic, assign, readwrite) BOOL chosen;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)setTime:(TimeSlot *)timeSlot;
@end

NS_ASSUME_NONNULL_END
