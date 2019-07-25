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
#import "DetailsViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchMap.delegate = self;
    for (int i =0; i<=self.searchMap.annotations.count; i++){
        if (self.searchMap.annotations.count>0){
        [self mapView:self.searchMap viewForAnnotation:self.searchMap.annotations[i]];
        }
    }
}

# pragma mark - Helper Methods

+ (void)setLocation:(CLLocation*)ourLocation onMap:(MKMapView*)map{
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(ourLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [map setRegion:initialRegion animated:YES];
}

+ (void)makeAnnotation:(MKPointAnnotation*)ourAnnotation atLocation:(CLLocationCoordinate2D)ourLocation withTitle:(NSString*)title{
    [ourAnnotation setCoordinate: ourLocation];
    [ourAnnotation setTitle: title];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if((float) annotation.coordinate.latitude == (float) self.initialLocation.coordinate.latitude && (float) annotation.coordinate.longitude == (float)self.initialLocation.coordinate.longitude){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        UIImage *pinImage = [UIImage imageNamed:@"car"];
        UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(30, 30))];
        annotationView.image = pinImageResized;
        return annotationView;
    }
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
    UIImage *pinImage = [UIImage imageNamed:@"ourlogo"];
    UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(30, 30))];
    annotationView.image = pinImageResized;
    return annotationView;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    view.canShowCallout = YES;
    //[self performSegueWithIdentifier:@"detailsSegue2" sender:self];
}

- (void) customizeDetailView:(MKAnnotationView*) view {
    UIView* snapshotView = [[UIView alloc] init];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //DetailsViewController *detailsViewController = [segue destinationViewController];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
