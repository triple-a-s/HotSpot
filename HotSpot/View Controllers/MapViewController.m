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
#import "LocationManagerSingleton.h"

@interface MapViewController ()
@property (strong, nonatomic) NSArray<Listing *> *ourMapListings;
@property (strong, nonatomic) CLLocation *startLocation;
@property (strong, nonatomic) NSMutableArray <PFFileObject*> *listingImageArray;
@property (strong, nonatomic) LocationManagerSingleton *mapLocationManager;
@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the delegate to itself
    self.searchMap.delegate = self;
    self.mapLocationManager = [LocationManagerSingleton sharedSingleton];
    // getting the initial listings to load on the map
    self.initialLocation = [[CLLocation alloc]initWithLatitude:self.mapLocationManager.locationManager.location.coordinate.latitude longitude:self.mapLocationManager.locationManager.location.coordinate.longitude];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    
    [DataManager getAllListings:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        self.ourMapListings = listings;
        
        NSMutableArray<MKPointAnnotation*> *spotList = [[NSMutableArray alloc]init];
        
        for ( int i=0; i<=self.ourMapListings.count-1; i++)
        {
            MKPointAnnotation *spotPins = [[MKPointAnnotation alloc]init];
            Listing *mapListing = self.ourMapListings[i];
            CLLocationCoordinate2D spotLocation = CLLocationCoordinate2DMake(mapListing.address.latitude, mapListing.address.longitude);
            [spotPins setCoordinate: spotLocation];
            // using the datamanager to set the address of the annotaion pin callout views
            [DataManager getAddressNameFromPoint:mapListing.address withCompletion:^(NSString *name, NSError * _Nullable error){
                if(error) {
                    NSLog(@"%@", error);
                }
                else {
                    [spotPins setTitle: name];
                }
            }];
            // updating the image of the annotation callout view
            [spotList addObject:spotPins];
            //adding the actual pins to thedmap
            [self.searchMap addAnnotation:spotList[i]];
        }
        // setting the searched location's annotation on the map
        MKPointAnnotation *searchedLocation = [[MKPointAnnotation alloc]init];
        [self makeAnnotation:searchedLocation atLocation:self.initialLocation.coordinate withTitle:self.annotationTitle];
        [self.searchMap addAnnotation:searchedLocation];
    }];
    // setting the location on the map 
    [self setLocation:self.initialLocation onMap:self.searchMap];
}

# pragma mark - Map Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
    mapView.showsUserLocation = NO;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *annotationView;
    for (annotationView in views) {
        if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.searchMap.visibleMapRect, point)) {
            continue;
        }
        CGRect endFrame = annotationView.frame;
        // Move annotation out of view
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - self.view.frame.size.height, annotationView.frame.size.width, annotationView.frame.size.height);
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:annotationView] options: UIViewAnimationOptionCurveLinear animations:^{
            annotationView.frame = endFrame;
            
            // Animate bounce
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 delay:0.05*[views indexOfObject:annotationView] options:UIViewAnimationOptionCurveLinear animations:^{
                    annotationView.transform = CGAffineTransformMakeScale(1.0, 0.7);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y + 10, annotationView.frame.size.width, annotationView.frame.size.height);
                        [UIView animateWithDuration:0.3 delay:0.5*[views indexOfObject:annotationView] options: UIViewAnimationOptionCurveLinear animations:^{
                            annotationView.frame = endFrame;
                        } completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            annotationView.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
        }];
    }
}
         

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
    // setting the image for the pin of the location you just searched
    
    if((float) annotation.coordinate.latitude == (float) self.initialLocation.coordinate.latitude && (float) annotation.coordinate.longitude == (float)self.initialLocation.coordinate.longitude){
        UIImage *pinImage = [UIImage imageNamed:@"greenpin"];
        UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(30, 30))];
        annotationView.image = pinImageResized;
        annotationView.canShowCallout = YES;
            }
    
    else{
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    [DataManager getAllListings:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        self.ourMapListings = listings;
        for(int i =0; i<= self.ourMapListings.count-1; i++){
            Listing *listing = self.ourMapListings[i];
            CLLocationCoordinate2D listingLocation = CLLocationCoordinate2DMake(listing.address.latitude, listing.address.longitude);
            if ( listingLocation.latitude == annotation.coordinate.latitude && listingLocation.longitude == annotation.coordinate.longitude){
                self.listingAnnotationImage = listing.picture;
            }
        }
        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        [self.listingAnnotationImage getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = annotation.title;
            UIImage *houseImage = [UIImage imageWithData:imageData];
            UIImage *houseImageResized =  [self imageWithImage:houseImage scaledToSize:(CGSizeMake(20, 20))];
            UIView *houseImagefinal = [[UIImageView alloc] initWithImage:houseImageResized];
            [leftCAV addSubview:houseImagefinal];
            [leftCAV addSubview:textLabel];
            annotationView.leftCalloutAccessoryView = leftCAV;
            // this will set the image on the callout view to be the one of the house you are buying
        }];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = rightButton;
        UIImage *pinImage = [UIImage imageNamed:@"searchPin"];
        UIImage *pinImageResized = [self imageWithImage:pinImage scaledToSize:(CGSizeMake(40, 40))];
        annotationView.image = pinImageResized;
        annotationView.canShowCallout = YES;
        
    }];
    }
   return annotationView;
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.initialLocation];
    [DataManager getAllListings:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
        CLLocationCoordinate2D address = view.annotation.coordinate;
        self.ourMapListings = listings;
        for ( int i=0; i<=self.ourMapListings.count-1; i++)
        {
            Listing *mapListing = self.ourMapListings[i];
            CLLocationCoordinate2D listingLocation = CLLocationCoordinate2DMake(mapListing.address.latitude, mapListing.address.longitude);
            if ( listingLocation.latitude == address.latitude && listingLocation.longitude == address.longitude){
            [self performSegueWithIdentifier:@"maptodetails" sender:mapListing];
            }
        }
        
    }];
}

- (void) mapView:(MKMapView*)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view{
    [view canShowCallout];
}

# pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"maptodetails"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.listing = sender;
    }
}

# pragma mark - Helper Methods

- (void) setLocation:(CLLocation*)ourLocation onMap:(MKMapView*)map{
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(ourLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [map setRegion:initialRegion animated:YES];
}

- (void) makeAnnotation:(MKPointAnnotation*)ourAnnotation atLocation:(CLLocationCoordinate2D)ourLocation withTitle:(NSString*)title{
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
