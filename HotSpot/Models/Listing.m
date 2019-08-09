//
//  Listing.m
//  HotSpot
//
//  Created by drealin on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Listing.h"

#import "Booking.h"
#import "TimeInterval.h"

@interface Listing()<PFSubclassing>
@end
@implementation Listing

@dynamic address;
@dynamic price;
@dynamic homeowner;
@dynamic picture;
@dynamic addressName;

# pragma mark - Class Methods

+ (nonnull NSString *)parseClassName {
    return @"Listing";
}

# pragma mark - Public Methods

- (void)canBook:(Booking *)booking withCompletion:(void(^)(BOOL can, NSError * _Nullable error))completion {
    PFRelation *relation = [self relationForKey:@"unavailable"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"repeatsWeekly"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<TimeInterval *> *timeIntervals, NSError * _Nullable error) {
        if (timeIntervals) {
            BOOL conflictFree = YES;
            for (TimeInterval *timeInterval in timeIntervals) {
                if ([timeInterval intersectionWithTimeInterval:booking.timeInterval]) {
                    conflictFree = NO;
                }
            }
            completion(conflictFree, error);
        }
        else {
            completion(NO, error);
        }
    }];
}

@end
