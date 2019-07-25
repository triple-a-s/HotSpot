//
//  EditCarViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/24/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "EditCarViewController.h"
#import "Car.h"
#import "CarsViewController.h"

@interface EditCarViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UITextField *licensePlate;
@property (weak, nonatomic) IBOutlet UITextField *carColor;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;


@end

@implementation EditCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.licensePlate.text = self.car.licensePlate;
    self.carColor.text = self.car.carColor;
    [self.defaultButton setSelected:(self.car.isDefault)];
}

- (void)configureCar {
    //PFQuery *query = [PFQuery queryWithClassName:@"cars"];
    //maybe just say self.car.carColor = self.carColor.text? try later, if not use query
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)didTapDone:(UIBarButtonItem *)sender {
    [self configureCar];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
