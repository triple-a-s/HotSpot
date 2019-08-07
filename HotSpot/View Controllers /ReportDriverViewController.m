//
//  ReportDriverViewController.m
//  
//
//  Created by aaronm17 on 8/6/19.
//

#import "ReportDriverViewController.h"
#import "DataManager.h"
#import "ReportTransitionViewController.h"
#import <Parse/Parse.h>
#import "RegexHelper.h"
#import "EmailHelper.h"
#import "ImagePickerHelper.h"
#import "ParkingSearchViewController.h"

@interface ReportDriverViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UITextField *licensePlate;
@property (weak, nonatomic) IBOutlet UITextView *reportMessage;
@property (strong, nonatomic) NSArray<Listing*> *transitionListings;

@end

@implementation ReportDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//checks if the license plate is invalid, if not retrieves the driver
//of that car and sends a specialized report
- (IBAction)didTapSendReport:(UIButton *)sender {
    UIAlertController *alert = [RegexHelper createAlertController:@"Invalid license plate" withMessage:@""];
    if ([RegexHelper isEmpty:@"licensePlate"]) {
        alert.message = @"Please provide a license plate so we can identify the driver";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else if (self.licensePlate.text.length != 7) {
        alert.message = @"The license plate must be 7 characters";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else if (![RegexHelper isTaken:self.licensePlate.text]) {
        alert.message = @"That license plate doesn't exist in our database.";
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        PFQuery *query = [Car query];
        [query whereKey:@"licensePlate" equalTo:self.licensePlate.text];
        Car *car = [query getFirstObject];
        if (car != nil) {
            PFUser *driver = car[@"driver"];
            [driver fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                NSString *reportedUser = object[@"username"];
                sendEmail(self.reportMessage.text, self.carImage, reportedUser, @"Driver");
                [self performSegueWithIdentifier:@"driverReportSegue" sender:nil];
            }];
        }
        
    }
}

//brings up the imagepicker
- (IBAction)didTapCarImage:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [ImagePickerHelper imageSelector:imagePickerVC withViewController:self];
}

//sets the picked image to the imageView's image field
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [ImagePickerHelper resizeImage:originalImage withSize:self.carImage.image.size];
    self.carImage.image = resizedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"driverReportSegue"]) {
        
        [DataManager getListingsNearLocation:self.listing.address
                              withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
                                  if(!error){
                                ReportTransitionViewController *reportTransitionVC = segue.destinationViewController;
                                      reportTransitionVC.needNearestSpot = YES;
                                CLLocation *locationEnter = [[CLLocation alloc] initWithLatitude:self.listing.address.latitude longitude:self.listing.address.longitude];
                                  self.transitionListings = [ParkingSearchViewController sortListingArraybyAscending:listings withLocation:locationEnter];
                                  reportTransitionVC.listing = self.transitionListings[0];
                                  }
                                  else{
                                      NSLog(@"FML");
                                  }
                              }];
    }
}


@end
