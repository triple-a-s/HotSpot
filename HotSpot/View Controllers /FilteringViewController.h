//
//  FilteringViewController.h
//  HotSpot
//
//  Created by aodemuyi on 8/9/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilteringViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UIButton *distanceLH;
@property (weak, nonatomic) IBOutlet UIButton *distanceHL;
@property (weak, nonatomic) IBOutlet UIButton *priceLH;
@property (weak, nonatomic) IBOutlet UIButton *priceHL;




@end

NS_ASSUME_NONNULL_END
