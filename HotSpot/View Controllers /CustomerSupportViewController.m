//
//  CustomerSupportViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CustomerSupportViewController.h"
#import "RegexHelper.h"
#import "EmailHelper.h"

@interface CustomerSupportViewController ()

@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextView *reportField;

@end

@implementation CustomerSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmit:(UIButton *)sender {
    if ([RegexHelper isEmpty:self.subjectField.text] || [RegexHelper isEmpty:self.reportField.text]) {
        UIAlertController *alert = [RegexHelper createAlertController:@"Invalid fields" withMessage:@"One or both of your fields are empty. Please input a subject and description of your issue so we can help you"];
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        reportIssue(self.reportField.text, self.subjectField.text);
        [self performSegueWithIdentifier:@"reportSegue" sender:nil];
    }
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
