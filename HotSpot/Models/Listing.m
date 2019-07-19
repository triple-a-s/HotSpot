//
//  Listing.m
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Listing.h"

@interface Listing()<PFSubclassing>
@end
@implementation Listing

@dynamic address;
@dynamic price;
@dynamic homeowner;

# pragma mark - Class Methods

+ (nonnull NSString *)parseClassName {
    return @"Listing";
}
@end
