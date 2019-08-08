//
//  LoadingViewController.m
//  HotSpot
//
//  Created by aodemuyi on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "LoadingViewController.h"


@interface LoadingViewController ()
@property (weak, nonatomic) IBOutlet UIView *loadingGif;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    [self.loadingGif addSubview:imageView];
    
}


@end
