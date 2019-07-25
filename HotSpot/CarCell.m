//
//  CarCell.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CarCell.h"
#import "Car.h"

@interface CarCell ()

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *licensePlate;
@property (weak, nonatomic) IBOutlet UILabel *carColor;
@property (weak, nonatomic) IBOutlet UIImageView *isDefault;

@end

@implementation CarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell: (Car *)car {
    //self.carImage.image = car.carImage;
    BOOL isDefault = [car[@"isDefault"] boolValue];
    if (isDefault) {
        self.isDefault.hidden = NO;
    } else {
        self.isDefault.hidden = YES;
    }
    self.licensePlate.text = car.licensePlate;
    self.carColor.text = car.carColor;
}

@end
