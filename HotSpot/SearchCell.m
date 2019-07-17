//
//  SearchCell.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell()


@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.searchTableAddress sizeToFit];
    [self.searchTableMilesAway sizeToFit];
    [self.searchTablePrice sizeToFit]; 
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
