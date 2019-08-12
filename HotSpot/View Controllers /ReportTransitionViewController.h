//
//  ReportTransitionViewController.h
//  HotSpot
//
//  Created by aaronm17 on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportTransitionViewController : UIViewController

@property (nonatomic) BOOL needNearestSpot;
@property (strong, nonatomic) Listing *listing;

@end

NS_ASSUME_NONNULL_END
