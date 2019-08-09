//
//  DataManager.m
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "DataManager.h"

#import "Booking.h"

@implementation DataManager

# pragma mark - Class Methods

+ (void)configureParse {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"http://hotspot2017.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
}

+ (void)getListingsNearLocation:(PFGeoPoint *)point
                   withCompletion:(void(^)(NSArray<Listing*> *listings, NSError *error))completion{
    PFQuery *query = [Listing query];
    [query whereKey:@"address" nearGeoPoint:point withinMiles:20]; // number of miles empirically set, for now
    // fetch data for home timeline posts asynchronously
    [query findObjectsInBackgroundWithBlock:completion];
}

  // this method was for testing --> rewriting 
+ (void)getAllListings:(PFGeoPoint *)point
                 withCompletion:(void(^)(NSArray<Listing *> *listings, NSError *error))completion{
    PFQuery *query = [Listing query];
    [query whereKey:@"address" nearGeoPoint:point withinMiles:1000000000];
    [query findObjectsInBackgroundWithBlock:completion];
    
}

+ (void)test {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:37.773972 longitude:-122.431297]; // san francisco
    
    [DataManager getListingsNearLocation:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"%@ oops", error);
        }
        else{
            NSLog(@"%@ our listings", listings);
        }
    }];
    
    [Booking getBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        if(error){
            NSLog(@"%@ oops", error);
        }
    }];
    
    [Booking getPastBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        if(error){
            NSLog(@"%@ oops", error);
        }
        else{
            
        }
    }];
    
    [Booking getCurrentBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
    }];
    
    
}

+ (void)sampleListingForTestingWithCompletion:(void(^)(Listing *listing, NSError *error))completion{
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:37.773972 longitude:-122.431297]; // san francisco
    [DataManager getListingsNearLocation:point withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        completion(listings[0], error);
    }];
}

+ (void)getAddressNameFromListing:(Listing *)listing withCompletion:(void(^)(NSString *name, NSError * _Nullable error))completion{
    if (listing[@"addressName"]) {
        completion(listing.addressName, nil);
    }
    else {
        PFGeoPoint *address = listing.address;
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:address.latitude longitude:address.longitude];
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
            listing.addressName = placemark.name;
            [listing saveInBackground];
            completion(placemark.name, error);
        }];
    }
    
}

+ (void)getNextBookingWithBlock:(PFObjectResultBlock)block {
    // get the next booking for this user
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"bookings"];
    PFQuery *query = relation.query;
    [query orderByAscending:@"startTime"];
    [query whereKey:@"startTime" greaterThan:[[NSDate alloc] init]];
    // fetch data asynchronously
    [query getFirstObjectInBackgroundWithBlock:block];
}

+ (CGFloat) getDistancebetweenAddressOne:(CLLocationCoordinate2D)addressOne andAddressTwo:(CLLocationCoordinate2D)addressTwo {
    CLLocation *locationOne = [[CLLocation alloc] initWithLatitude: addressOne.latitude longitude:addressTwo.longitude];
    CLLocation *locationTwo = [[CLLocation alloc] initWithLatitude:addressTwo.latitude longitude:addressTwo.longitude];
    CLLocationDistance distance = [locationOne distanceFromLocation:locationTwo];
    CGFloat distanceValue = (CGFloat)distance * 0.000621371;
    // this is in miles
    return distanceValue;
}


@end
