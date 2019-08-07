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

//allows the user to initialize a car with all the info
- (instancetype)initWithInfo:(NSString *)carColor withLicense:(NSString *)licensePlate withImage:(UIImage *)carImage withDefault:(BOOL)isDefault {
    if ((self = [super init])) {
        self.carImage = [Car getPFFileObjectFromImage:carImage];
        self.licensePlate = licensePlate;
        self.carColor = carColor;
        self.isDefault = isDefault;
        self.driver = [PFUser currentUser];
    }
    return self;
}

//adds the passed in car to the database utilizing the changeDefaultCar method
+ (void)addCar:(Car *)newCar
withCompletion: (PFBooleanResultBlock _Nullable) completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"cars"];
    if (newCar.isDefault) {
        [self changeDefaultCar:relation withCar:newCar withUser:user];
    }
    [newCar saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [relation addObject:newCar];
            [user saveInBackgroundWithBlock:nil];
        }
    }];
}

//Goes through the database and changes any cars that were previous default
//to not the default, and sets the user's default car to the new car
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

//gets a pffileobject from an image
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
