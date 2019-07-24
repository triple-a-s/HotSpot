//
//  Listing.h
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Listing : PFObject
@property (nonatomic, strong) PFGeoPoint *address;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) PFUser *homeowner;
@property (nonatomic,strong) PFFileObject *picture;

@end

NS_ASSUME_NONNULL_END
