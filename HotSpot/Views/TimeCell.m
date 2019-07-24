//
//  TimeCell.m
//  HotSpot
//
//  Created by drealin on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TimeCell.h"

@interface TimeCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation TimeCell
- (void)setTime:(NSInteger)item {
    NSInteger hour = item / 4;
    NSInteger minute = item % 4 * 15;
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%d", hour, minute];
}
@end
