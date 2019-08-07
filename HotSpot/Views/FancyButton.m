//
//  FancyButton.m
//  HotSpot
//
//  Created by drealin on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "FancyButton.h"

@implementation FancyButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 18;
    self.backgroundColor = [UIColor colorWithDisplayP3Red:0.89406615499999997
                                                    green:0.3239448667
                                                     blue:0.2989487052
                                                    alpha:1.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.contentEdgeInsets = UIEdgeInsetsMake(8, 30, 8, 30);
}

@end
