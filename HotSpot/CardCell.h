//
//  CardCell.h
//  
//
//  Created by aaronm17 on 8/7/19.
//

#import <UIKit/UIKit.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCell : UITableViewCell

- (void)configureCell: (Card *)card;

@end

NS_ASSUME_NONNULL_END
