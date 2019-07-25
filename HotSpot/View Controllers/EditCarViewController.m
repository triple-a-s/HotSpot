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
    PFFileObject *imageFile = self.car.carImage;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.carImage.image = image;
        }
    }];
    [self.defaultButton setSelected:(self.car.isDefault)];
}

- (void)configureCar {
    PFQuery *query = [Car query];
    [query whereKey:@"licensePlate"equalTo:(self.car.licensePlate)];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            Car *currentCar = objects[0];
            currentCar[@"licensePlate"] = self.licensePlate.text;
            currentCar[@"carColor"] = self.carColor.text;
            currentCar[@"carImage"] = [Car getPFFileFromImage:(self.carImage.image)];
        }
    }];
    [currentCar ]
    
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
