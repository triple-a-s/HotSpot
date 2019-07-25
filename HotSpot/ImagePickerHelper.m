//
//  ImagePickerHelper.m
//  HotSpot
//
//  Created by aaronm17 on 7/25/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ImagePickerHelper.h"
#import <UIKit/UIKit.h>

@interface ImagePickerHelper() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ImagePickerHelper 

+ (void)imageHelper: (UIImagePickerController *)imagePicker
        withViewController:(nonnull UIViewController *)UIViewController{
    
    UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [UIViewController presentViewController:imagePicker animated:YES completion:nil];
        }]];
        
        [imageAlert addAction:[UIAlertAction actionWithTitle:(@"Photo Library") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [UIViewController presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [UIViewController presentViewController:imageAlert animated:YES completion:nil];
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [UIViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
