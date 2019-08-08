//
//  TransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/5/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TransitionViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface TransitionViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *carImage;

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media.giphy.com/media/TdcmrLMF0TVqDLUjAT/giphy.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    
    imageView.frame = CGRectMake(self.view.frame.origin.x-50, self.view.frame.origin.y-50, 300, 300.0);
    [self.carImage addSubview:imageView];
}

- (IBAction)didTapProfilePage:(UIButton *)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 0;
}


@end
