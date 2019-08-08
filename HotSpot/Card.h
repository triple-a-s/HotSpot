//
//  Car.h
//  HotSpot
//
//  Created by aaronm17 on 7/22/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : PFObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *expiration;
@property (nonatomic, strong) NSString *number;


- (instancetype)initWithInfo:(NSString *)type
                 withBank:(NSString *)bank
           withExpiration:(NSString *)expiration
               withNumber:(NSString *)number;

+ (void)addCard:(Card *)newCard
    withDefault:(BOOL)isDefault
 withCompletion:(PFBooleanResultBlock _Nullable)completion;


+ (void)changeDefaultCard:(Card *)card
                 withUser: (PFUser *)user;
@end

NS_ASSUME_NONNULL_END
