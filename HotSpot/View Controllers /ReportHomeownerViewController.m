//
//  ReportHomeownerViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/6/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ReportHomeownerViewController.h"
#import "RegexHelper.h"
#import "EmailHelper.h"

@interface ReportHomeownerViewController ()

@property (weak, nonatomic) IBOutlet UITextView *reportField;

@end

@implementation ReportHomeownerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:(YES)];
}

//checks if the report field is empty, if not sends a specialized report
- (IBAction)didTapSendReport:(UIButton *)sender {
    if ([RegexHelper isEmpty:self.reportField.text]) {
        UIAlertController *alert = [RegexHelper createAlertController:@"Empty text field" withMessage:@"Please give a report of what went wrong"];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        sendEmail(self.reportField.text, nil, self.nameLabel.text, @"Homeowner");
        [self performSegueWithIdentifier:@"homeownerReportSegue" sender:nil];
    }
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
