//
//  ProfileViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "CarCell.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    self.profileImage.image = currentUser[@"profilePicture"];
    self.name.text = currentUser[@"name"];
    self.phone.text = currentUser[@"phone"];
    self.email.text = currentUser[@"email"];
    self.username.text = currentUser.username;
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
