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
#import "ImagePickerHelper.h"
#import "RegexHelper.h"

@interface EditCarViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UITextField *licensePlate;
@property (weak, nonatomic) IBOutlet UITextField *carColor;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic) BOOL isSameCar;

@end

@implementation EditCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.licensePlate.text = self.car.licensePlate;
    self.carColor.text = self.car.carColor;
    [self.defaultButton setSelected:(self.car.isDefault)];
    PFFileObject *imageFile = self.car.carImage;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.carImage.image = image;
        }
    }];
}

- (void)configureCar {
    self.car[@"licensePlate"] = self.licensePlate.text;
    self.car[@"carColor"] = self.carColor.text;
    self.car[@"carImage"] = [Car getPFFileObjectFromImage:(self.carImage.image)];
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"cars"];
    if (self.defaultButton.selected) {
        [Car changeDefaultCar:relation withCar:self.car withUser:currentUser];
        [self.car setObject:[NSNumber numberWithBool:YES] forKey:@"isDefault"];
    }
    [self.car saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [currentUser saveInBackgroundWithBlock:nil];
        }
    }];
}


- (IBAction)didTapImage:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [ImagePickerHelper imageHelper:imagePickerVC withViewController:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [ImagePickerHelper resizeImage:originalImage withSize:CGSizeMake(100, 100)];
    self.carImage.image = resizedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapDefaultButton:(UIButton *)sender {
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


- (IBAction)didTapDone:(UIBarButtonItem *)sender {
    UIAlertController *alert = [RegexHelper createAlertController];
    if ([self.car[@"licensePlate"] isEqualToString:self.licensePlate.text]) {
        self.isSameCar = YES;
    }
    if (isValidCar(self.licensePlate.text, self.carColor.text, alert, self.isSameCar)) {
        [self configureCar];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}

@end
