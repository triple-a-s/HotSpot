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

/*+ (id)sharedLocationManager {
    static LocationManagerSingleton *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}*/

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager requestWhenInUseAuthorization];
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
    [self.locationManager stopUpdatingLocation];
}

@end
