//
//  MapSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MapSearchViewController.h"
#import "MapKit/MapKit.h"

@interface MapSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
/*
 the map isn't currently set to a specific location, but I will update
 this as soon as I merge with the datamanager.
 */
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@property (weak, nonatomic) IBOutlet UIButton *buttonToTable;

- (IBAction)buttonPressed:(id)sender;

@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action Items

- (IBAction)buttonPressed:(id)sender {
      [self performSegueWithIdentifier:@"toTableMode" sender:nil];
}

@end
