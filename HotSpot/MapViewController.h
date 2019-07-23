//
//  MapViewController.h
//  HotSpot
//
//  Created by aodemuyi on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "MapKit/MapKit.h"

NS_ASSUME_NONNULL_BEGIN


@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@end

NS_ASSUME_NONNULL_END
