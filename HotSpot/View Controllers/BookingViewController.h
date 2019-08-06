//
//  BookingViewController.h
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookingViewController : UIViewController
@property (nonatomic, strong) Listing *listing;
@property (nonatomic, strong) Booking *booking; 

@end

NS_ASSUME_NONNULL_END
