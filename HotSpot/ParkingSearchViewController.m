//
//  ParkingSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ParkingSearchViewController.h"
#import "MapKit/MapKit.h"
#import "SpotCell.h"
#define METERS_PER_MILE 1609.344

@interface ParkingSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
/*
 the map isn't currently set to a specific location, but I will update
 this as soon as I merge with the datamanager.
 */
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;


@end

@implementation ParkingSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.searchTableView.rowHeight = 134 ;
    self.searchTableView.hidden = YES;
    // we will initialize the map to show the user's current location
    // self.searchMap.showsUserLocation = YES;
    
    // testing using a specific latitude
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.484928, -122.148201), MKCoordinateSpanMake(0.1, 0.1));
    [self.searchMap setRegion:initialRegion animated:YES];
}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SpotCell *parkingCell = [tableView dequeueReusableCellWithIdentifier:@"SpotCell"];
    if(parkingCell == nil){
        parkingCell = [[SpotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpotCell"];
    }
    
    //placehodlder information
    parkingCell.spotTableAddress.text= @"100 West Lake";
    parkingCell.spotTableDetails.text = @"50 miles away";
    parkingCell.spotTablePrice.text= @"$5/hr";
    parkingCell.spotTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    
    // trying to resize text to work with Autolayout

    parkingCell.spotTablePrice.adjustsFontSizeToFitWidth = YES;
     
    
    return parkingCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}

#pragma mark - Action Items

- (IBAction)modeButtonPressed:(id)sender {
    if(!self.searchTableView.hidden){
        self.searchTableView.hidden = YES;
        self. searchMap.hidden = NO;
    }
    else{
    self.searchTableView.hidden = NO;
    self.searchMap.hidden = YES;
    }
    
}

#pragma mark - Helper methods


@end
