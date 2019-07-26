
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
<<<<<<< Updated upstream
<<<<<<< HEAD:HotSpot/View Controllers/ParkingSearchViewController.m
    self.searchTableView.dataSource = self;
=======
    self.searchTableView.dataSource = self; 
>>>>>>> a48aac273aa4b1675d8b78c8496db89752d39c98:HotSpot/ParkingSearchViewController.m
=======
    self.searchTableView.dataSource = self;
>>>>>>> Stashed changes
    self.initialLocation = [[CLLocation alloc] initWithLatitude:37.44 longitude:45.344];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    [DataManager getListingsNearLocation:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
    self.listings = listings;
    [self.searchTableView reloadData];
    }];
<<<<<<< HEAD:HotSpot/View Controllers/ParkingSearchViewController.m
}
<<<<<<< Updated upstream
=======
     }
>>>>>>> a48aac273aa4b1675d8b78c8496db89752d39c98:HotSpot/ParkingSearchViewController.m
=======
>>>>>>> Stashed changes
# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
<<<<<<< Updated upstream
    cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
=======
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    return cell;
<<<<<<< HEAD:HotSpot/View Controllers/ParkingSearchViewController.m
    
=======
     
>>>>>>> a48aac273aa4b1675d8b78c8496db89752d39c98:HotSpot/ParkingSearchViewController.m
=======
    return cell;
    
>>>>>>> Stashed changes
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
<<<<<<< HEAD:HotSpot/View Controllers/ParkingSearchViewController.m

<<<<<<< Updated upstream
=======
 
>>>>>>> a48aac273aa4b1675d8b78c8496db89752d39c98:HotSpot/ParkingSearchViewController.m
=======
>>>>>>> Stashed changes
@end
