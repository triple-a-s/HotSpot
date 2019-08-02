//
//  MainContainerViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MainContainerViewController.h"
#import "ParkingSearchViewController.h"
#import "MapViewController.h"
#import "SearchResult.h"
#import "SearchCell.h"
#import "Listing.h"
#import "DataManager.h"



@interface MainContainerViewController ()<UITableViewDataSource, UITableViewDelegate, MKLocalSearchCompleterDelegate>

// IB Outlets - Including the searchbar and searchresultTableView
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *mainSearchButton;
@property (weak, nonatomic) IBOutlet UIView *spotListView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;

// Properties associated with search (autocomplete and actual search)
@property (strong,nonatomic) MKLocalSearchRequest *request;
@property (strong, nonatomic) MKLocalSearch *search;
@property (strong, nonatomic) MKLocalSearchCompleter *completer;
@property (nonatomic, strong) NSArray <MKLocalSearchCompletion*> *spotsArray;
@property (strong,nonatomic) MKLocalSearchCompletion *completion;
@property (strong,nonatomic) CLGeocoder *coder;
@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

//dealing with child view controllers -- to pass information to them
@property (strong, nonatomic) MapViewController *mapVC;
@property (strong, nonatomic) ParkingSearchViewController *tableVC;

// annotation setting
@property (strong, nonatomic) NSMutableArray<MKPointAnnotation*> *spotList;




@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setting things up (views)
    self.spotListView.hidden = YES;
    self.searchResultTableView.hidden = YES;
    [self.mapView setUserInteractionEnabled:YES];
    [self.spotListView setUserInteractionEnabled:YES];
    
    // setting delegates and dataSources for tableView and searchbar
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.mainSearchBar.delegate = self;
    
    // things associated with searches and autocomplete
    self.completer = [[MKLocalSearchCompleter alloc] init];
    self.searchResultTableView.rowHeight = 100;
    self.completer.delegate = self;
    self.completer.filterType = MKSearchCompletionFilterTypeLocationsOnly;
    [self.searchResultTableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableVC.initialLocation = self.mapVC.locationManager.location;
}

# pragma mark - Action Items

- (IBAction)switchMode:(id)sender {
    // sets the views to hidden or not hidden depending on what is tapped using conditionals
    if(self.spotListView.hidden){
        self.mapView.hidden = YES;
        self.spotListView.hidden = NO;
        
    }
    else{
        self.mapView.hidden = NO;
        self.spotListView.hidden = YES;
    }
}

# pragma mark - Search Related

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    // setting the views to hidden or not
    self.searchResultTableView.hidden = NO;
    
    // starting to try out a simple animation 
    if(self.searchResultTableView.frame.size.height == 0){
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.searchResultTableView.frame;
                         frame.size.height = 300;
                         self.searchResultTableView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    }
    
    else if (self.searchResultTableView.frame.size.height == 300){
        [UIView animateWithDuration:1
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = self.searchResultTableView.frame;
                             frame.size.height = 0;
                             self.searchResultTableView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
        
    }
    // the search bar will go away once you delete text
    if(searchText.length ==0){
        [self.mainSearchBar endEditing:YES];
        self.searchResultTableView.hidden = YES;
    }
    
    // the actual implementation of the autocompleter!
    self.completion = [[MKLocalSearchCompletion alloc] init];
    self.completer.queryFragment = searchText;
    self.spotsArray = self.completer.results;
    [self.searchResultTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // when you click search, you want the keyboard to go away
    [self.mainSearchBar endEditing:YES];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    // tells the keyboard what to do when we decide it ended editing --> actually dismisses keyboard
    [self.mainSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // this is necessary in certain cases, although it seems redundant
    [self.mainSearchBar endEditing:YES];
}

# pragma mark - TableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // setting up the cell for when I start typing
    MKLocalSearchCompletion *completion = self.spotsArray[indexPath.row];
    SearchResult *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
    if(cell == nil){
        cell = [[SearchResult alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResult"];
    }
    cell.searchResultTitle.text = completion.title;
    cell.searchResultSubtitle.text = completion.subtitle;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // finding the completion to set the address
    MKLocalSearchCompletion *completionForMap = self.spotsArray[indexPath.row];
    NSString *mapAddressForConversion = completionForMap.subtitle;
    self.mapVC.annotationTitle = completionForMap.subtitle;
    
    // translate the address to coordinates we can work with to set on the map using prewritten method
    [MainContainerViewController getCoordinateFromAddress:mapAddressForConversion withCompletion:^(CLLocation *location, NSError *error) {
        if(error) {
            // shows us the error
            NSLog(@"%@", error);
        }
        else{
            // update the map and the table according to the requested location
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude]; // san francisco
            [DataManager getListingsNearLocation:geoPoint withCompletion:^(NSArray<Listing *> * _Nonnull listings, NSError * _Nonnull error) {
                if(error) {
                    NSLog(@"%@ oops", error);
                }
                else{
                    self.tableVC.listings = listings;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableVC.searchTableView reloadData];
                    });
                }
            }];
            self.mapVC.initialLocation = location; 
            MKCoordinateRegion setRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
            [self.mapVC.searchMap setRegion:setRegion animated:YES];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate: location.coordinate];
            [annotation setTitle: completionForMap.title];
            [self.mapVC.searchMap addAnnotation:annotation]; 
            [self.tableVC.searchTableView reloadData];
        }
    }];
    // we don't want the search result to show after we already tapped on something
    self.searchResultTableView.hidden =YES;
    // we want the keyboard to go away after we tapped on something
    [self.mainSearchBar endEditing:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // the number of spots on the table should correspong to the number of spots available 
    return self.spotsArray.count;
}

# pragma mark - PrepareforSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapViewController"]) {
        self.mapVC = segue.destinationViewController;
        // [self.mapVC.searchMap showAnnotations:self.mapVC.searchMap.annotations animated:YES];
        [self.mapVC.searchMap showAnnotations:self.mapVC.searchMap.annotations animated:YES];
    }else if ([segue.identifier isEqualToString:@"toSpotTable"]){
        self.tableVC = segue.destinationViewController;
        [self.tableVC.searchTableView reloadData];
        [self.tableVC viewWillAppear:YES];
    }
}

# pragma mark - Helper Methods

+ (void) getCoordinateFromAddress:(NSString*) address withCompletion:(void(^)(CLLocation *location, NSError * error))completion{
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        completion(placemark.location, error);
    }];
}

@end
