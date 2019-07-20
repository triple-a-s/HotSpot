//
//  ParkingSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "ParkingSearchViewController.h"
#import "MapKit/MapKit.h"
#import "SearchCell.h"
#import "searchResult.h"
#import "MainContainerViewController.h"

@interface ParkingSearchViewController () <UITableViewDataSource, UITableViewDelegate>
/*
 the map isn't currently set to a specific location, but I will update
 this as soon as I merge with the datamanager.
 */
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@end

@implementation ParkingSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.searchTableView.rowHeight = 134;
    [self.searchTableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 10;
}
 
@end
