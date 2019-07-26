//
//  Car.m
//  HotSpot
//
//  Created by aaronm17 on 7/22/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "Car.h"
#import "Parse/Parse.h"

@interface Car()<PFSubclassing>

@end

@implementation Car

@dynamic carImage;
@dynamic licensePlate;
@dynamic carColor;
@dynamic isDefault;
@dynamic driver;

+ (nonnull NSString *)parseClassName {
    return @"Car";
}

//adds a car given an image, color, license, and default boolean,
//properly updating the user's current cars to not be set to default
//if the user has chosen to make their new car their default car
+ (void)addCar:(UIImage * _Nullable)image
     withColor: ( NSString * _Nullable)color
   withLicense: (NSString * _Nullable)licensePlate
   withDefault: (BOOL)isDefault withCompletion: (PFBooleanResultBlock _Nullable)completion {
    Car *newCar = [Car new];
    newCar.carImage = [self getPFFileObjectFromImage:image];
    newCar.licensePlate = licensePlate;
    newCar.carColor = color;
    newCar.isDefault = isDefault;
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"cars"];
    if (isDefault) {
        [self changeDefaultCar:relation withCar:newCar withUser:user];
    }
    [newCar saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newCar];
            [user saveInBackgroundWithBlock:nil];
        }
    }];
}

+ (void)changeDefaultCar: (PFRelation *)relation
                 withCar: (Car *)car
                withUser: (PFUser *)user {
    PFQuery *query = relation.query;
    [query findObjectsInBackgroundWithBlock:^(NSArray *cars, NSError *error) {
        if (cars != nil) {
            for (Car *currentCar in cars) {
                [currentCar fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    BOOL currentCarDefault = [object[@"isDefault"] boolValue];
                    if (currentCarDefault) {
                        [object setObject:[NSNumber numberWithBool:NO] forKey:@"isDefault"];
                        [currentCar saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        }];
                    }
                }];
            }
        }
    }];
    [user setObject:car forKey:@"defaultCar"];
}

                       
+ (PFFileObject *)getPFFileObjectFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
