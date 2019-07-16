//
//  SearchCell.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell()

@property (weak, nonatomic) IBOutlet UIImageView *searchTableImage;
@property (weak, nonatomic) IBOutlet UILabel *searchTableAddress;
@property (weak, nonatomic) IBOutlet UILabel *searchTableMilesAway;
@property (weak, nonatomic) IBOutlet UILabel *searchTablePrice;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
