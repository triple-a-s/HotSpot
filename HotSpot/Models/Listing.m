//
//  Listing.m
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Listing.h"

#import "Booking.h"
#import "Parse/Parse.h"
#import "TimeInterval.h"

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

# pragma mark - Public Methods

- (BOOL)canBook:(Booking *)booking {
    PFRelation *relation = [self relationForKey:@"unavailable"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"repeatsWeekly"];
    
    NSArray<TimeInterval *> *timeIntervals = [query findObjects];
    
    for (TimeInterval *timeInterval in timeIntervals) {
        if ([timeInterval intersectionWithTimeInterval:booking.timeInterval]) {
            return NO;
        }
    }
    return YES;
    
}

@end
