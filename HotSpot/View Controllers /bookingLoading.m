//
//  bookingLoading.m
//  HotSpot
//
//  Created by aodemuyi on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//
int countTime;

#import "bookingLoading.h"
#import "FancyButton.h"

@interface bookingLoading ()
// I realize now that this would've been easier programatically
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UILabel *bookingText;
@property (weak, nonatomic) IBOutlet UILabel *successfullyLoaded;
@property (weak, nonatomic) IBOutlet FancyButton *ResultsButton;


@end

@implementation bookingLoading

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
    self.successfullyLoaded.hidden = YES;
    self.ResultsButton.hidden = YES;
    [self.bookingText setAlpha:0.0f];
    [UIView animateWithDuration:1.5f animations:^{
        [self.bookingText setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5f animations:^{
            [self.bookingText setAlpha:0.0f];
        } completion:^(BOOL finished){
            //self.bookingText.hidden = YES;
            self.successfullyLoaded.hidden = NO;
            self.ResultsButton.hidden = NO;
        }];
    }];
    self.progressView.progress = 0;
    
    for (int i =0; i<=100; i++){
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car3"]];
        imageView.tintColor = [UIColor colorWithDisplayP3Red:0.89406615499999997
                                                       green:0.3239448667
                                                        blue:0.2989487052
                                                       alpha:1.0];
        imageView.frame = CGRectMake(0, 0, 35,35);
    [self.view addSubview:imageView];
    [self animateBounce];
    }
}


- (void) animateBounce{
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                        selector:@selector(timerFireMethod:)
                                   userInfo:nil
                                    repeats:YES];
    CGRect frame = self.view.frame;
    frame.size.height = 7/8 *frame.size.height;
    self.view.frame = frame;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    for (int i =0; i<=self.view.subviews.count-1; i++){
        if ([self.view.subviews[i] isKindOfClass:[UIImageView class]])
        {
        UIGravityBehavior* gravityBehavior =
        [[UIGravityBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        [self.animator addBehavior:gravityBehavior];
        
        UICollisionBehavior* collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:collisionBehavior];
        
        UIDynamicItemBehavior *elasticityBehavior =
        [[UIDynamicItemBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        elasticityBehavior.elasticity = 1;
        [self.animator addBehavior:elasticityBehavior];
    }
             }
}

- (void) timerFireMethod:(NSTimer*)timer{
    [self.progressView setProgress: countTime / 3 animated: true];
    if (countTime >= 3)  {
        [timer invalidate];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 2;
}

@end
