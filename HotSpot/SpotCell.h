//
//  SpotCell.h
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *spotTableImage;
@property (weak, nonatomic) IBOutlet UILabel *spotTableAddress;
@property (weak, nonatomic) IBOutlet UILabel *spotTablePrice;
@property (weak, nonatomic) IBOutlet UILabel *spotTableDetails;




@end

NS_ASSUME_NONNULL_END
