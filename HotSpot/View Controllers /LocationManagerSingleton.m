//
//  LocationManager.m
//  HotSpot
//
//  Created by aodemuyi on 8/7/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "LocationManagerSingleton.h"

@implementation LocationManagerSingleton

@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager startUpdatingLocation];
        //do any more customization to your location manager
    }
    
    return self;
}

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
    if(!sharedSingleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [LocationManagerSingleton new];
        });
                      }
                      return sharedSingleton;
                      }
                      
                      - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
                          //handle your location updates here
                      }

@end
