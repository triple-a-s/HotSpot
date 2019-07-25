//
//  Car.h
//  HotSpot
//
//  Created by aaronm17 on 7/22/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Car : PFObject

@property (nonatomic, strong) NSString *licensePlate;
@property (nonatomic, strong) NSString *carColor;
@property (nonatomic, strong) PFFileObject *carImage;
@property (nonatomic) BOOL isDefault;
@property (nonatomic, strong) PFUser *driver;

+ (void)addCar:(UIImageView * _Nullable)image
     withColor: ( NSString * _Nullable)color
   withLicense: (NSString * _Nullable)licensePlate
   withDefault: (BOOL)isDefault withCompletion: (PFBooleanResultBlock _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
