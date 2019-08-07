//
//  DamagesViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/6/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "DamagesViewController.h"
#import "RegexHelper.h"
#import "EmailHelper.h"
#import "ImagePickerHelper.h"

@interface DamagesViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *damageImage;

@end

@implementation DamagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//checks if the image field is nil, if not sends a specialized report for damages
- (IBAction)didTapSendReport:(UIButton *)sender {
    if (self.damageImage.image == nil) {
        UIAlertController *alert = [RegexHelper createAlertController];
        alert.title = @"No image detected";
        alert.message = @"Please upload a picture so we can assess your car's damages";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        sendEmail(@"Damage report", self.damageImage, self.reportedUser, @"Homeowner");
    }
}

//brings up the image picker
- (IBAction)didTapCarImage:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [ImagePickerHelper imageSelector:imagePickerVC withViewController:self];
}

//sets the image view's image field to the selected image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [ImagePickerHelper resizeImage:originalImage withSize:self.damageImage.image.size];
    self.damageImage.image = resizedImage;
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
