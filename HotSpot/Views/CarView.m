//
//  CarView.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CarView.h"
#import "Parse/Parse.h"

@interface CarView()
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carColor;
@property (weak, nonatomic) IBOutlet UILabel *licensePlate;
@property (strong, nonatomic) PFUser *currentUser;

@end

@implementation CarView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.currentUser = [PFUser currentUser];

    if (self.currentUser[@"defaultCar"]  == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New User: Add a car"
                                                                       message:@"Please add a car before proceeding" preferredStyle:UIAlertControllerStyleAlert];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             nil;
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [[self viewController] presentViewController:alert animated:YES completion:^{
            [[self viewController] performSegueWithIdentifier:(@"carSegue") sender:(nil)];
        }];
        self.licensePlate.text = @"TBD";
        self.carColor.text = @"TBD";
    } else {
        PFObject *defaultCar = self.currentUser[@"defaultCar"];
        [defaultCar fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(object) {
                self.licensePlate.text = object[@"licensePlate"];
                self.carColor.text = object[@"carColor"];
                PFFileObject *imageFile = object[@"carImage"];
                [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
                    if (!error) {
                        UIImage *carImage = [UIImage imageWithData:imageData];
                        self.carImage.image = carImage;
                    }
                }];
            }
        }];
    }
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

@end
