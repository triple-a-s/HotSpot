//
//  DataManager.h
//  HotSpot
//
//  Created by drealin on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject
+ (void)configureParse;
+ (void)getHomeownersNearLocation:(PFGeoPoint *)point
                   withCompletion:(void(^)(NSArray<PFUser *> *homeowners, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
