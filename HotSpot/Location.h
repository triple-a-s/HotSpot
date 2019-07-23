//
//  Location.h
//  HotSpot
//
//  Created by aodemuyi on 7/23/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject


// name of the location in nice terms (our completion.subtitle)
@property (strong, nonatomic) NSString *address;
// the latitude of location
@property (nonatomic) CLLocationDegrees *latitude;
// the longitude of location
@property (nonatomic) CLLocationDegrees *longitude;
// CLLLocationCoordinate2D value
@property (nonatomic) CLLocationCoordinate2D *coordinate;

//initializer
- (instancetype)initWithDictionary:(NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
