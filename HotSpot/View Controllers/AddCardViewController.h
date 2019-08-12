//
//  AddCardViewController.h
//  HotSpot
//
//  Created by aaronm17 on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddCardViewControllerDelegate

- (void)didAddCard:(Card *)card;

@end

@interface AddCardViewController : UIViewController

@property (nonatomic, weak) id<AddCardViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
