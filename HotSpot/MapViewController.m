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
 /*   MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordforpin = {.latitude = 37.484928,.longitude = -122.148201};
    [annotation setCoordinate: coordforpin];
    [annotation setTitle:@"1 Hacker Way"];
    [annotation setSubtitle:@"$10/hr"];
    
    [self.searchMap addAnnotation:annotation];
  */ 
}

@end
