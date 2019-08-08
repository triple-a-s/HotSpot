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
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media.giphy.com/media/TdcmrLMF0TVqDLUjAT/giphy.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(50.0, 50.0, 150.0, 150.0);
    [self.loadingGif addSubview:imageView];
    
}
/*
- (void) fadeIn{
        [_label setAlpha:0.0f];
        //fade in
        [UIView animateWithDuration:2.0f animations:^{
            
            [_label setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            
            //fade out
            [UIView animateWithDuration:2.0f animations:^{
                
                [_label setAlpha:0.0f];
                
            } completion:nil];
            
        }];
    }
}
*/ 
@end
