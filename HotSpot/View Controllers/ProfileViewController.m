//
//  ProfileViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "CarCell.h"
#import "Car.h"
#import "ImagePickerHelper.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carColor;
@property (weak, nonatomic) IBOutlet UILabel *licensePlate;
@property (strong, nonatomic) PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PFUser currentUser] fetchIfNeededInBackground];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    self.currentUser = [PFUser currentUser];
    [self configureProfilePage];
}

#pragma mark - Private methods

//this retrieves the current user and sets the fields of the objects
//on the profile page to the user's information, and sets up an alert
//if it's a new user to tell them to add a car
- (void)configureProfilePage {
    
    PFFileObject *imageFile = self.currentUser[@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        if (!error) {
            UIImage *profilePicture = [UIImage imageWithData:imageData];
            self.profileImage.image = profilePicture;
        }
    }];
    
    self.name.text = self.currentUser[@"name"];
    self.phone.text = self.currentUser[@"phone"];
    self.email.text = self.currentUser.email;
    self.username.text = self.currentUser.username;
    
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
        [self presentViewController:alert animated:YES completion:^{
            [self performSegueWithIdentifier:(@"carSegue") sender:(nil)];
        }];
        self.licensePlate.text = @"TBD";
        self.carColor.text = @"TBD";
    } else {
        PFObject *defaultCar = self.currentUser[@"defaultCar"];
        [defaultCar fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if(object) {
            self.licensePlate.text = object[@"licensePlate"];
            self.carColor.text = object[@"carColor"];
            }
            else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (IBAction)didTapProfileImage:(UITapGestureRecognizer *)sender {
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
    UIImage *resizedImage = [ImagePickerHelper resizeImage:originalImage withSize:CGSizeMake(100, 100)];
    self.profileImage.image = resizedImage;
    
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    PFFileObject *imageFile = [PFFileObject fileObjectWithData:imageData];
    self.currentUser[@"profilePicture"] =
    imageFile;
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)didTapCarCell:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:(@"carSegue") sender:(nil)];
}

/*- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
