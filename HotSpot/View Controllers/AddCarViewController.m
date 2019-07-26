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
#import "ImagePickerHelper.h"

@interface AddCarViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

#pragma mark - Public methods

//the add car method that creates a new car with the inputted licensePlate,
//carColor and whether or not it's the new default
- (void)addCar {
    BOOL selected = [self.defaultButton isSelected];
    Car *car = [Car new];
    car.licensePlate = self.licensePlate.text;
    car.carColor = self.carColor.text;
    car.isDefault = selected;
    car.carImage = [Car getPFFileObjectFromImage:self.carImage.image];
    [Car addCar:self.carImage.image withColor:self.carColor.text withLicense:self.licensePlate.text withDefault:selected withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self.delegate didAddCar:car];
    }];
}


#pragma mark - Private methods

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

- (IBAction)didTapCar:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    /*UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        
        [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Photo Library") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }]];
        
        [self presentViewController:imageAlert animated:YES completion:nil];
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }*/
    
    [ImagePickerHelper imageHelper:imagePickerVC withViewController:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [ImagePickerHelper resizeImage:originalImage withSize:self.carImage.image.size];
    self.carImage.image = resizedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
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
