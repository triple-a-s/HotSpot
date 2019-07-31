//
//  AddCarViewController.h
//  HotSpot
//
//  Created by aaronm17 on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddCarViewControllerDelegate

- (void)didAddCar:(Car *)car;

@end

@interface AddCarViewController : UIViewController

@property (nonatomic, weak) id<AddCarViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
