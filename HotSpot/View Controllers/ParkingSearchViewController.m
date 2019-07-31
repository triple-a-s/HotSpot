
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
#import "SearchResult.h"
#import "MainContainerViewController.h"
#import "Listing.h"
#import "DataManager.h"
#import "DetailsViewController.h"

@interface ParkingSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ParkingSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.rowHeight = 134;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.initialLocation = [[CLLocation alloc] initWithLatitude:37.44 longitude:45.344];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    [DataManager getListingsNearLocation:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        self.listings = listings;
        [self.searchTableView reloadData];
    }];
    NSLog(@"%@ LISTINGSS:" , self.listings);
}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    Listing *listing = self.listings[indexPath.row];
    [DataManager getAddressNameFromPoint:listing.address withCompletion:^(NSString *name, NSError * _Nullable error){
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            cell.searchTableAddress.text = name;
        }
    }];
    cell.searchTablePrice.text = [NSString stringWithFormat: @"$%@/hr", listing.price];
    
    //placehodlder information
    cell.searchTableMilesAway.text = @"50 miles away";
    PFFileObject *img = listing.picture;
    [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
        UIImage *imageToLoad = [UIImage imageWithData:imageData];
        cell.searchTableImage.image = imageToLoad;
    }];
    // trying to resize text to work with Autolayout
    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // perform segue
    [self performSegueWithIdentifier:@"detailsSegue"
                              sender:self.listings[indexPath.row]];
}
 */ 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsSegue"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.listing = sender;
    }
}

#pragma mark - Action Items

@end
