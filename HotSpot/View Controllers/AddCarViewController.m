//
//  AddCarViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "AddCarViewController.h"
#import "Parse/Parse.h"
#import "Car.h"

@interface AddCarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UITextField *licensePlate;
@property (weak, nonatomic) IBOutlet UITextField *carColor;

@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.defaultButton setSelected:NO];

}

- (void)addCar {
    BOOL selected = [self.defaultButton isSelected];
    Car *car = [Car new];
    car.licensePlate = self.licensePlate.text;
    car.carColor = self.carColor.text;
    [Car addCar:self.carImage withColor:self.carColor.text withLicense:self.licensePlate.text withDefault:selected withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self.delegate didAddCar:car];
    }];
}
- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapConfirm:(UIBarButtonItem *)sender {
    [self addCar];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapDefault:(UIButton *)sender {
    [self.defaultButton setSelected:(![self.defaultButton isSelected])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
