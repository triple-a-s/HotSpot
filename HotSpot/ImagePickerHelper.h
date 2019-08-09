//
//  ImagePickerHelper.h
//  HotSpot
//
//  Created by aaronm17 on 7/25/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePickerHelper : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (void)imageSelector: (UIImagePickerController *)imagePicker
 withViewController:(UIViewController *)UIViewController;

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
