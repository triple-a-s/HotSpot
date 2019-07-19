//
//  MapViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/19/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *searchMap;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.484928, -122.148201), MKCoordinateSpanMake(0.1, 0.1));
    [self.searchMap setRegion:initialRegion animated:YES];
    
    //setting the pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordforpin = {.latitude = 37.484928,.longitude = -122.148201};
    [annotation setCoordinate: coordforpin];
    [annotation setTitle:@"Spot at Menlo Park!"];
    [self.searchMap addAnnotation:annotation];
    
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordforpin2 = {.latitude = 37.234928,.longitude = -122.148201};
    [annotation2 setCoordinate: coordforpin2];
    [annotation2 setTitle:@"Spot!"];
    [self.searchMap addAnnotation:annotation2];
    
}


@end
