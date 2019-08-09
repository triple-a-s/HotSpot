//
//  bookingLoading.m
//  HotSpot
//
//  Created by aodemuyi on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "bookingLoading.h"

@interface bookingLoading ()
@property (weak, nonatomic) IBOutlet UIImageView *car1;
@property (weak, nonatomic) IBOutlet UIImageView *car2;
@property (weak, nonatomic) IBOutlet UIImageView *car3;
@property (weak, nonatomic) IBOutlet UIImageView *car4;
@property (weak, nonatomic) IBOutlet UIImageView *car5;
@property (weak, nonatomic) IBOutlet UIImageView *car6;
@property (weak, nonatomic) IBOutlet UIImageView *car7;
@property (weak, nonatomic) IBOutlet UIImageView *car8;
@property (weak, nonatomic) IBOutlet UIImageView *car9;
@property (weak, nonatomic) IBOutlet UIImageView *car10;
@property (weak, nonatomic) IBOutlet UIImageView *car11;
@property (weak, nonatomic) IBOutlet UIImageView *car12;
@property (weak, nonatomic) IBOutlet UIImageView *car13;
@property (weak, nonatomic) IBOutlet UIImageView *car14;
@property (weak, nonatomic) IBOutlet UIImageView *car15;
@property (weak, nonatomic) IBOutlet UIImageView *car16;
@property (weak, nonatomic) IBOutlet UIImageView *car17;
@property (weak, nonatomic) IBOutlet UIImageView *car18;
@property (weak, nonatomic) IBOutlet UIImageView *car19;
@property (weak, nonatomic) IBOutlet UIImageView *car20;
@property (strong, nonatomic) UIDynamicAnimator *animator;



@end

@implementation bookingLoading

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void) animateBounce:(UIImageView*)car{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    for (int i =0; i<=self.view.subviews.count; i++){
        UIGravityBehavior* gravityBehavior =
        [[UIGravityBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        [self.animator addBehavior:gravityBehavior];
        
        UICollisionBehavior* collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:collisionBehavior];
        
        UIDynamicItemBehavior *elasticityBehavior =
        [[UIDynamicItemBehavior alloc] initWithItems:@[self.view.subviews[i]]];
        elasticityBehavior.elasticity = 0.7f;
        [self.animator addBehavior:elasticityBehavior];
    }
}

@end
