//
//  MainContainerViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MainContainerViewController.h"
#import "ParkingSearchViewController.h"
#import "SearchCell.h"
#import "SearchResultsViewController.h"


@interface MainContainerViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;

@property (weak, nonatomic) IBOutlet UIButton *mainSearchButton;
@property (weak, nonatomic) IBOutlet UIView *spotListView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;


@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spotListView.hidden = YES;
}

- (void) didReceieveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)switchMode:(id)sender {
    
}



@end
