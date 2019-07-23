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
    
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordforpin2 = {.latitude = 37.234928,.longitude = -122.148201};
    [annotation2 setCoordinate: coordforpin2];
    [annotation2 setTitle:@"Spot!"];
    [self.searchMap addAnnotation:annotation2];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"mapViewController"]) {
        self.ntViewController = [segue destinationViewController];
    }
}



@end
