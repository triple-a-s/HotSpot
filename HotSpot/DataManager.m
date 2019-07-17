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

+ (void)getHomeownersWithCompletion:(void(^)(NSArray<PFUser *> *homeowners, NSError *error))completion {
    
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"address"]; // only homeowners have addresses
    
    // fetch data for home timeline posts asynchronously
    [query findObjectsInBackgroundWithBlock:completion];
}
@end
