//
//  DataManager.m
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "DataManager.h"

#import "Parse/Parse.h"

@implementation DataManager

# pragma mark - Class Methods

+ (void)configureParse {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"http://hotspot2017.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
}

+ (void)getHomeownersNearLocation:(PFGeoPoint *)point
                   withCompletion:(void(^)(NSArray<PFUser *> *homeowners, NSError *error))completion{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"homeowner" equalTo:[NSNumber numberWithBool:YES]];
    [query whereKey:@"address" nearGeoPoint:point withinKilometers:2]; // number of kilometers empirically set, for now
    
    // fetch data for home timeline posts asynchronously
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
