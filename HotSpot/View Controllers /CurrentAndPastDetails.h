//
//  CurrentAndPastDetails.h
//  HotSpot
//
//  Created by aodemuyi on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Booking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentAndPastDetails : UIViewController

@property (nonatomic, strong) Booking *booking;
@property (weak, nonatomic) IBOutlet UIButton *bookAgainButton;


@end

NS_ASSUME_NONNULL_END
