//
//  MapViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"
#import "MainContainerViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) MainContainerViewController *ntViewController;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchMap.showsUserLocation = YES;
}

@end
