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
    
    // setting delegates and dataSources for tableView and searchbar
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.mainSearchBar.delegate = self;
    
    // things associated with searches and autocomplete
    self.completer = [[MKLocalSearchCompleter alloc] init];
    self.searchResultTableView.rowHeight = 100;
    self.completer.delegate = self;
    self.completer.filterType = MKSearchCompletionFilterTypeLocationsOnly;
}

# pragma mark - Action Items

- (IBAction)switchMode:(id)sender {
    // sets the views to hidden or not hidden depending on what is tapped
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
    // map and table updates
    MKLocalSearchCompletion *completionForMap = self.spotsArray[indexPath.row];
    NSString *mapAddressForConversion = completionForMap.subtitle;
    [MainContainerViewController getCoordinateFromAddress:mapAddressForConversion withCompletion:^(CLLocation *location, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        }
        else{
            // update the map and the table according to the requested location
            [MapViewController setLocation:location onMap:self.mapVC.searchMap];
            self.tableVC.initialLocation = location;
            self.mapVC.initialLocation = location;
            [self.tableVC.searchTableView reloadData];
            
            // setting the searched location's annotation on the map
            MKPointAnnotation *searchedLocation = [[MKPointAnnotation alloc]init];
            [MapViewController makeAnnotation:searchedLocation atLocation:location.coordinate withTitle:completionForMap.title];
            [self.mapVC.searchMap addAnnotation:searchedLocation];
            
            // setting the annotation pins for the listings nearby
            NSMutableArray<MKPointAnnotation*> *spotList = [[NSMutableArray alloc]init];
            for ( int i=0; i<=self.tableVC.listings.count-1; i++)
            {
                MKPointAnnotation *spotPins = [[MKPointAnnotation alloc]init];
                CLLocationCoordinate2D spotLocation = CLLocationCoordinate2DMake(self.tableVC.listings[i].address.latitude, self.tableVC.listings[i].address.longitude);
                [spotPins setCoordinate: spotLocation];
                [spotPins setTitle: @"bluefacebabyaightt"];
                [spotList addObject:spotPins];
                [self.mapVC mapView:self.mapVC.searchMap viewForAnnotation:spotPins];
                [self.mapVC.searchMap addAnnotation:spotList[i]];
                self.mapVC.listingAnnotationImage = self.tableVC.listings[i].picture;
            }
<<<<<<< Updated upstream
        }
    }];
=======
            
        }
    }];
    
>>>>>>> Stashed changes
    self.searchResultTableView.hidden =YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.spotsArray.count;
}

# pragma mark - PrepareforSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapViewController"]) {
        self.mapVC = segue.destinationViewController;
<<<<<<< Updated upstream
        // [self.mapVC.searchMap showAnnotations:self.mapVC.searchMap.annotations animated:YES];
=======
        [self.mapVC.searchMap showAnnotations:self.mapVC.searchMap.annotations animated:YES];
>>>>>>> Stashed changes
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
