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
#import "DataManager.h"

@interface MapViewController ()

@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchMap showsUserLocation];
    self.initialLocation = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    [DataManager getAllListings :geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        self.listings = listings;
    }];
    self.searchMap.delegate = self;
    for (int i =0; i<=self.searchMap.annotations.count; i++){
        if (self.searchMap.annotations.count>0){
            [self mapView:self.searchMap viewForAnnotation:self.searchMap.annotations[i]];
        }
    }

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

# pragma mark - Map Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    mapView.showsUserLocation = NO;
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // setting the image for the pin of the location you just searched
    if((float) annotation.coordinate.latitude == (float) self.initialLocation.coordinate.latitude && (float) annotation.coordinate.longitude == (float)self.initialLocation.coordinate.longitude){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        UIImage *pinImage = [UIImage imageNamed:@"searchPin"];
        UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(30, 30))];
        annotationView.image = pinImageResized;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    // setting up the callout view for the listings
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = annotation.title;
    
    // this will set the image on the callout view to be the one of the house you are buying
    [self.listingAnnotationImage getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
        UIImage *houseImage = [UIImage imageWithData:imageData];
        UIImage *houseImageResized =  [self imageWithImage:houseImage scaledToSize:(CGSizeMake(40, 40))];
        UIView *houseImagefinal = [[UIImageView alloc] initWithImage: houseImageResized];
        [leftCAV addSubview:houseImagefinal];
    }];
    [leftCAV addSubview:textLabel];
    annotationView.leftCalloutAccessoryView = leftCAV;
    UIImage *pinImage = [UIImage imageNamed:@"searchPin"];
    UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(30, 30))];
    annotationView.image = pinImageResized;
    annotationView.canShowCallout = YES;
 
    return annotationView;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if(control == view.leftCalloutAccessoryView){
    //[self performSegueWithIdentifier:@"maptodetails" sender:self.searchMap];
    NSLog(@"ABCDEFG");
    }
}

# pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*if([segue.identifier isEqualToString:@"detailsSegue2"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.listing = sender;
    }
     */
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
