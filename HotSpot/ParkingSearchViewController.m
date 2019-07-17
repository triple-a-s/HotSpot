//
//  MapSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ParkingSearchViewController.h"
#import "MapKit/MapKit.h"
#import "SearchCell.h"
#define METERS_PER_MILE 1609.344

@interface ParkingSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
/*
 the map isn't currently set to a specific location, but I will update
 this as soon as I merge with the datamanager.
 */
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableSearchTableView;


@end

@implementation ParkingSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableSearchTableView.dataSource = self;
    self.tableSearchTableView.delegate = self;
    self.tableSearchTableView.rowHeight = 134 ;
    self.tableSearchTableView.hidden = YES;
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
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    
    //placehodlder information
    cell.searchTableAddress.text= @"100 West Lake";
    cell.searchTableMilesAway.text = @"50 miles away";
    cell.searchTablePrice.text= @"$5/hr";
    cell.searchTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    
    // trying to resize text to work with Autolayout

    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
     
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}

#pragma mark - Action Items

- (IBAction)modeButtonPressed:(id)sender {
    if(!self.tableSearchTableView.hidden){
        self.tableSearchTableView.hidden = YES;
        self. searchMap.hidden = NO;
    }
    else{
    self.tableSearchTableView.hidden = NO;
    self.searchMap.hidden = YES;
    }
    
}

#pragma mark - Helper methods

- (void)searchInMap{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    
}
@end
