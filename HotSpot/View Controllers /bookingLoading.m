//
//  bookingLoading.m
//  HotSpot
//
//  Created by aodemuyi on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//
int countTime;

#import "bookingLoading.h"

@interface bookingLoading ()
// I realize now that this would've been easier programatically
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UILabel *bookingText;


@end

@implementation bookingLoading

- (void)viewDidLoad {
    countTime= 0;
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFireMethod:)
                                                    userInfo:nil
                                                     repeats:NO];
    
    [self.bookingText setAlpha:0.0f];
    [UIView animateWithDuration:1.5f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat   animations:^{
        [self.bookingText setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [self.bookingText setAlpha:0.0f];
        } completion:nil];
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
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    countTime += 0.1;
    [self.progressView setProgress: countTime / 3 animated: true];
    if (countTime >= 3)  {
        [timer invalidate];
    }
}

@end
