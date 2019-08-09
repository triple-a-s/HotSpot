//
//  ReportTransitionViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ReportTransitionViewController.h"
#import "DetailsViewController.h"
#import "DataManager.h"
#import "ParkingSearchViewController.h"

@interface ReportTransitionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *transitionButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ReportTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.needNearestSpot) {
        [self.transitionButton setTitle:@"Go to nearest spot" forState:UIControlStateNormal];
        self.descriptionLabel.text = @"Meanwhile, we've found the nearest available spot for you.";
    } else {
        [self.transitionButton setTitle:@"Return to Search Page" forState:UIControlStateNormal];
        self.descriptionLabel.text = @"We'll look into that as soon as possible for you.";
    }
}


- (IBAction)didTapReturn:(UIButton *)sender {
    if (self.needNearestSpot) {
        [DataManager getListingsNearLocation:self.listing.address withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", error);
            }
            else {
                CLLocation *locationEnter = [[CLLocation alloc] initWithLatitude:self.listing.address.latitude longitude:self.listing.address.longitude];
                NSArray *transitionListings = [ParkingSearchViewController sortListingArraybyAscending:listings withLocation:locationEnter];
                [self performSegueWithIdentifier:@"newSpotSegue" sender:transitionListings[0]];
            }
        }];
    } else {
        [self performSegueWithIdentifier:@"returnSegue" sender:nil];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"returnSegue"]) {
        UITabBarController *tabBar = segue.destinationViewController;
        tabBar.selectedIndex = 2;
    }
    else if([segue.identifier isEqualToString:@"newSpotSegue"]){
        DetailsViewController *reportTransitionVC = segue.destinationViewController;
        reportTransitionVC.listing = sender;
     }
    }

- (IBAction)closeSpotClicked:(id)sender {
    [DataManager getListingsNearLocation:self.listing.address
                          withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
    CLLocation *locationEnter = [[CLLocation alloc] initWithLatitude:self.listing.address.latitude longitude:self.listing.address.longitude];
    NSArray *transitionListings = [ParkingSearchViewController sortListingArraybyAscending:listings withLocation:locationEnter];
    Listing *senderListing = transitionListings[0];
    [self performSegueWithIdentifier:@"newSpotSegue" sender:senderListing];
                          }];
}



@end
