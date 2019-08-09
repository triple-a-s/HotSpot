//
//  MainContainerViewController.h
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import <Speech/Speech.h>
NS_ASSUME_NONNULL_BEGIN

@interface MainContainerViewController : UIViewController <UISearchBarDelegate, MKLocalSearchCompleterDelegate, SFSpeechRecognizerDelegate, UISearchDisplayDelegate>

+ (void) getCoordinateFromAddress:(NSString*) address withCompletion:(void(^)(CLLocation *location, NSError *_Nullable error))completion;


@end

NS_ASSUME_NONNULL_END
