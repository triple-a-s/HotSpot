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
}
    // Do any additional setup after loading the view.

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
