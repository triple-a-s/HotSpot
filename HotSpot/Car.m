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

+ (void)addCar:(UIImage * _Nullable)image
     withColor: ( NSString * _Nullable)color
   withLicense: (NSString * _Nullable)licensePlate
   withDefault: (BOOL)isDefault withCompletion: (PFBooleanResultBlock _Nullable)completion {
    Car *newCar = [Car new];
    PFUser *user = [PFUser currentUser];
    //newCar.carImage = [self getPFFileFromImage:image];
    newCar.licensePlate = licensePlate;
    newCar.carColor = color;
    newCar.isDefault = isDefault;
    PFRelation *relation = [user relationForKey:@"cars"];
    if (isDefault) {
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
        [user setObject:newCar forKey:@"defaultCar"];
    }
                    
    [newCar saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newCar];
            [user saveInBackgroundWithBlock:nil];
        }
    }];
}
                       
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
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
