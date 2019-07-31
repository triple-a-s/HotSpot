//
//  CarCell.h
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarCell : UITableViewCell

- (void)configureCell: (Car *)car;

@end

NS_ASSUME_NONNULL_END
