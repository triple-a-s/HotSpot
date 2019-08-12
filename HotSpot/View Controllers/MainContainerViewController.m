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
#import "FilteringViewController.h"



@interface MainContainerViewController ()<UITableViewDataSource, UITableViewDelegate, MKLocalSearchCompleterDelegate>

// IB Outlets - Including the searchbar and searchresultTableView
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *mainSearchButton;
@property (weak, nonatomic) IBOutlet UIView *spotListView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
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
@property (strong, nonatomic) FilteringViewController *filterVC;


// annotation setting
@property (strong, nonatomic) NSMutableArray<MKPointAnnotation*> *spotList;

// affiliated with voice search
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;

@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *priceSliderText;

@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setting things up (views)
    self.spotListView.hidden = YES;
    
    self.filterView.hidden = YES;
    CGRect frame = self.filterView.frame;
    frame.size.height = self.view.frame.size.height; 
    frame.origin.x = -frame.size.width;
    self.filterView.frame = frame;
    
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
    
    // animations -- sets frame size to 0!
    [self resetTableViewFrame];
    
    // I'm assuming that the people using HotSpot are Americans that speak english
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    self.speechRecognizer.delegate = self;
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
    // cute little animation that is unnecessary but necessary
    // expands and then shrinks
    [UIView animateWithDuration:.2
                     animations:^{
                         self.modeSwitchButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:.35 animations:^{
                             self.modeSwitchButton.transform = CGAffineTransformIdentity;
                         }];
                     }];
}

- (IBAction)microPhoneTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.audioEngine.isRunning) {
            [self stopRecording];
            self.mainSearchBar.placeholder = @"Search for a parking area: (eg. Rosebowl Stadium)";
        } else {
            [self startListening];
        }
    });
}

- (IBAction)filterPressed:(id)sender {
    self.filterView.hidden = NO; 
    if(self.filterView.frame.origin.x <0){
        [UIView animateWithDuration:.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = self.filterView.frame;
                             frame.origin.x = 0;
                             self.filterView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
    else{
        [UIView animateWithDuration:.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = self.filterView.frame;
                             frame.origin.x = -frame.size.width;
                             self.filterView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (IBAction)lowToHigh:(id)sender {
    self.tableVC.listings = [ParkingSearchViewController sortListingArraybyAscending:self.tableVC.listings withLocation:self.tableVC.initialLocation];
    [self.tableVC.searchTableView reloadData];
}

- (IBAction)highToLow:(id)sender {
    self.tableVC.listings = [ParkingSearchViewController sortListingArraybyDescending:self.tableVC.listings withLocation:self.tableVC.initialLocation];
    [self.tableVC.searchTableView reloadData];
}

- (IBAction)priceToHigh:(id)sender {
    self.tableVC.listings = [ParkingSearchViewController sortListingArraybyPriceAscending:self.tableVC.listings];
    [self.tableVC.searchTableView reloadData];
}


- (IBAction)priceToLow:(id)sender {
    self.tableVC.listings = [ParkingSearchViewController sortListingArraybyPriceADescending:self.tableVC.listings];
    [self.tableVC.searchTableView reloadData];
}

- (IBAction)priceSlide:(id)sender {
    self.priceSliderText.text = [NSString localizedStringWithFormat:@"$%f", self.priceSlider.value];
    NSMutableArray *sliderListings = [[NSMutableArray alloc] init];
    for(int i =0; i<=self.mapVC.ourMapListings.count-1; i++){
        if (self.mapVC.ourMapListings[i] != nil && [self.mapVC.ourMapListings[i].price doubleValue] <= self.priceSlider.value){
            [sliderListings addObject:self.mapVC.ourMapListings[i]];
        }
    }
}



# pragma mark - Search Related

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.spotListView.hidden = YES;
    // this is the animation for a search results drop down
    if(self.searchResultTableView.frame.size.height ==0)
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{CGRect frame = self.searchResultTableView.frame;
            // set to size of the view controller
            frame.size.height = self.view.frame.size.height;
            self.searchResultTableView.frame =
            frame;}
                         completion:^(BOOL finished){
                         }];
    
    // the search bar will go away once you delete text
    if(searchText.length ==0){
        [self.mainSearchBar endEditing:YES];
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
    [self resetTableViewFrame];
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
    if (self.mapView.hidden){
    self.spotListView.hidden = NO;
    }
    else if (!self.mapView.hidden){
        self.spotListView.hidden = YES;
    }
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
                    self.tableVC.initialLocation = location;
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
        }
    }];
    // we don't want the search result to show after we already tapped on something
    [self resetTableViewFrame];
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
    else if ([segue.identifier isEqualToString:@"filterSegue"]){
        self.filterVC = segue.destinationViewController;
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

-(void)moveFromLeftOrRight:(NSTimer *) timer {
    BOOL isLeft = [timer.userInfo boolValue];
    CGFloat bounceDistance = 10;
    CGFloat bounceDuration = 0.2;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         CGFloat direction = (isLeft ? 1 : -1);
                         self.filterView.center = CGPointMake(self.filterView.frame.size.width/2 + direction*bounceDistance, self.filterView.center.y);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:bounceDuration animations:^{
                             self.filterView.center = CGPointMake(self.filterView.frame.size.width/2, self.filterView.center.y);
                         }];
                     }];
}

- (void) resetTableViewFrame{
    CGRect frame =  self.searchResultTableView.frame;
    frame.size.height = 0;
    self.searchResultTableView.frame  = frame;
}

- (void)startListening {
    
    // initializing our audioEngine
    /*
     AVAudio Engine (from Apple Documentation: A group of connected audio node objects used to generate and process audio signals and perform audio input and output.
     */
    self.audioEngine = [[AVAudioEngine alloc] init];
    
    // if there is an ongoing task -- cancel that lol
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    // setting up the session
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    // NECESSARY for voice search
    self.recognitionRequest.shouldReportPartialResults = YES;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            NSString *resultText = [NSString stringWithFormat: @"%@ ",result.bestTranscription.formattedString];
            [self.mainSearchBar setText:resultText];
        }
        
        if (error) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1800 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    // Starts the audio engine, i.e. it starts listening.
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    self.mainSearchBar.placeholder = @"Recording has started";
}

-(void)stopRecording{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.audioEngine.isRunning){
            [self.audioEngine.inputNode removeTapOnBus:0];
            [self.audioEngine.inputNode reset];
            [self.audioEngine stop];
            [self.recognitionRequest endAudio];
            [self.recognitionTask cancel];
            self.recognitionTask = nil;
            self.recognitionRequest = nil;
        }
    });
}


@end
