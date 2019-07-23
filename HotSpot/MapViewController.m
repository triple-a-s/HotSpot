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
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // this is more of me testing out what the map does
    
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.484928, -122.148201), MKCoordinateSpanMake(0.1, 0.1));
    [self.searchMap setRegion:initialRegion animated:YES];
    
    //setting the pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordforpin = {.latitude = 37.484928,.longitude = -122.148201};
    [annotation setCoordinate: coordforpin];
    [annotation setTitle:@"1 Hacker Way"];
    [annotation setSubtitle:@"$10/hr"];
    
    [self.searchMap addAnnotation:annotation];
    
    
}

/*+ (void)updateLocation :(CLLocation*) clickedLocation, (MKMapView*) map{
    CLLocationCoordinate2D coordforpin = clickedLocation.coordinate;
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(coordforpin, MKCoordinateSpanMake(0.1, 0.1));
    [map setRegion:initialRegion animated:YES];
}
*/ 

@end
