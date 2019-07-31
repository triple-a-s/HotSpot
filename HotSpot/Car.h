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


- (instancetype)initWithInfo:(NSString *)carColor
                 withLicense:(NSString *)licensePlate
                   withImage:(UIImage *)carImage
                 withDefault:(BOOL)isDefault;

+ (void)addCar:(Car *)newCar
withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (PFFileObject *)getPFFileObjectFromImage: (UIImage * _Nullable)image;

+ (void)changeDefaultCar: (PFRelation *)relation
                 withCar: (Car *)car
                withUser: (PFUser *)user;
@end

NS_ASSUME_NONNULL_END
