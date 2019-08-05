
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
    // initializing our table
    self.searchTableView.rowHeight = 134;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    // will replace this with user location
    self.initialLocation = [[CLLocation alloc] initWithLatitude:37.44 longitude:-122.344];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.initialLocation.coordinate.latitude longitude:self.initialLocation.coordinate.longitude]; // san francisco
    [DataManager getListingsNearLocation:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"%@ oops", error);
        }
        else{
            self.listings = listings;
            // in case the update is done on the wrong thread
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchTableView reloadData];
            });
        }
    }];
    

}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listings.count == 0){
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if(cell == nil){
            cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
        }
        cell.searchTableImage.image = [UIImage imageNamed:@"ourlogo"];
        cell.searchTablePrice.text = @"No Spots";
        cell.searchTableAddress.text = @" ";
        cell.searchTableMilesAway.text = @" please try a different location";
        return cell;
    }
    else{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    Listing *listing = self.listings[indexPath.row];
    [DataManager getAddressNameFromPoint: listing.address withCompletion:^(NSString *name, NSError * _Nullable error){
        if(error) {
            NSLog(@"%@", error);
        }
        else {
            cell.searchTableAddress.text = name;
        }
    }];
    cell.searchTablePrice.text = [NSString stringWithFormat: @"$%@/hr", listing.price];
    
    CLLocationCoordinate2D spotLocation = CLLocationCoordinate2DMake(listing.address.latitude,
                                                                     listing.address.longitude);
    CGFloat distanceBetweenPoints = [DataManager getDistancebetweenAddressOne:spotLocation andAddressTwo:self.initialLocation.coordinate];
    cell.searchTableMilesAway.text = [NSMutableString stringWithFormat:@"%.02f miles away",distanceBetweenPoints];
    
    PFFileObject *img = listing.picture;
    [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
        UIImage *imageToLoad = [UIImage imageWithData:imageData];
        cell.searchTableImage.image = imageToLoad;
    }];
    // trying to resize text to work with Autolayout
    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    return cell;
    }
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.listings.count == 0){
        return 1;
    }
    return self.listings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // perform segue
    [self performSegueWithIdentifier:@"detailsSegue"
                              sender:self.listings[indexPath.row]];
}
 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsSegue"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.listing = sender;
    }
}

#pragma mark - Action Items

@end
