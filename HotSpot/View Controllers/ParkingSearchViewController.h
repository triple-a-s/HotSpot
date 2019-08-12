
//
//  ParkingMapSearchViewController.h
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Listing.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParkingSearchViewController : UIViewController <MKMapViewDelegate>
@property (strong,nonatomic) CLLocation *initialLocation;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray<Listing *> *listings;
+ (NSArray*)sortListingArraybyAscending:(NSArray<Listing*>*)unsortedArray withLocation:(CLLocation*)location;
+ (NSArray*)sortListingArraybyDescending:(NSArray<Listing*>*)unsortedArray withLocation:(CLLocation*)location;
+ (NSArray*)sortListingArraybyPriceADescending:(NSArray<Listing*>*)unsortedArray;
+ (NSArray*)sortListingArraybyPriceAscending:(NSArray<Listing*>*)unsortedArray;

@end

NS_ASSUME_NONNULL_END
