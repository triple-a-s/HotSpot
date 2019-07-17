//
//  MapSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MapSearchViewController.h"
#import "MapKit/MapKit.h"
#import "SearchCell.h"

@interface MapSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
/*
 the map isn't currently set to a specific location, but I will update
 this as soon as I merge with the datamanager.
 */
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.searchTableView.rowHeight = 134 ;
    self.searchTableView.hidden = TRUE;
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
    
    //trying to resize text to work with Autolayout 
    cell.searchTableAddress.adjustsFontSizeToFitWidth = YES;
    cell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES; 
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}

#pragma mark - Action Items

- (IBAction)modeButtonPressed:(id)sender {
    if(!self.searchTableView.hidden){
        self.searchTableView.hidden = TRUE;
        self. searchMap.hidden = FALSE;
    }
    else{
    self.searchTableView.hidden = FALSE;
    self.searchMap.hidden = TRUE;
    }
    
}


@end
