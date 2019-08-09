//
//  ConfirmationViewController.m
//  HotSpot
//
//  Created by drealin on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *tabBar = segue.destinationViewController;
    tabBar.selectedIndex = 2;
}

- (void) animateBounce{
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

@end
