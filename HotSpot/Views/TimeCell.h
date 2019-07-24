//
//  TimeCell.h
//  HotSpot
//
//  Created by drealin on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeCell : UICollectionViewCell
@property (nonatomic, strong) NSDate *date;
- (void)setTime:(NSInteger)item withDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
