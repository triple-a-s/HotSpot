//
//  CancelViewController.m
//  HotSpot
//
//  Created by drealin on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController ()

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelConfirmClicked:(id)sender {
    [self.booking cancel];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
