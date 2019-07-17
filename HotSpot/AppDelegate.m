//
//  AppDelegate.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "Booking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

PFUser *homeowner;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(  NSDictionary *)launchOptions {
    
    [DataManager configureParse];
    
    [DataManager getHomeownersWithCompletion:^(NSArray<PFUser *> * _Nonnull homeowners, NSError * _Nonnull error) {
        NSLog(@"%@ homeowners", homeowners);
        homeowner = homeowners[0];
    }];
    
    // Fake a login
    
    NSString *username = @"user1";
    NSString *password = @"password";
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            // success
        }
    }];
    
    [Booking getBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        NSLog(@"%@ getBookingsWithBlock", bookings);
    }];
    
    
    [Booking getPastBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        NSLog(@"%@ getPastBookingsWithBlock", bookings);
    }];
    
    [Booking getCurrentBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        NSLog(@"%@ getCurrentBookingsWithBlock", bookings);
    }];
    
//    [Booking bookDriveway:homeowner
//           withCompletion:nil];
    
    
    // Fake some data for the homeowners
    
//    // initialize a user object
//    PFUser *newHomeowner = [PFUser user];
//
//    // set user properties
//    newHomeowner.username = @"homeowner1";
//    newHomeowner.password = @"password";
//    newHomeowner[@"address"] = @"1 hacker way";
//
//    // call sign up function on the object
//    [newHomeowner signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        } else {
//            // all good
//        }
//    }];
    
    // Fake some data for the users
    
//    // initialize a user object
//    PFUser *newUser = [PFUser user];
//
//    // set user properties
//    newUser.username = @"user1";
//    newUser.password = @"password";
//
//    // call sign up function on the object
//    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        } else {
//            // all good
//        }
//    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
