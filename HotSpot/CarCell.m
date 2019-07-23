//
//  CarCell.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CarCell.h"
#import "Car.h"

@implementation CarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell: (Car *)car {
    self.car = car;
 //self.carImage.image = car.carImage;
    //self.licensePlate.text = car[@"license"];
    //self.carColor.text = car[@"Color"];
    BOOL isDefault = [car[@"isDefault"] boolValue];
    if (isDefault) {
        self.isDefault.hidden = NO;
    } else {
        self.isDefault.hidden = YES;
    }
    self.licensePlate.text = car[@"licensePlate"];
    self.carColor.text = car[@"carColor"];
}

@end
