//
//  SearchCell.h
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *searchTableImage;
@property (weak, nonatomic) IBOutlet UILabel *searchTableAddress;
@property (weak, nonatomic) IBOutlet UILabel *searchTableMilesAway;
@property (weak, nonatomic) IBOutlet UILabel *searchTablePrice;

@end

NS_ASSUME_NONNULL_END
