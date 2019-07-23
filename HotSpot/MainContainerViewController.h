//
//  MainContainerViewController.h
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
NS_ASSUME_NONNULL_BEGIN
@protocol MapViewControllerDelegate
@end

@interface MainContainerViewController : UIViewController <UISearchBarDelegate, MKLocalSearchCompleterDelegate>

+(void) getCoordinateFromAddress:(NSString*) address withCompletion:(void(^)(CLLocation *location, NSError *_Nullable error))completion;
@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;
@property (strong, nonatomic) CLLocation *storedlocation;

@end

NS_ASSUME_NONNULL_END
