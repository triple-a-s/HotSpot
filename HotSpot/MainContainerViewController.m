//
//  MainContainerViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MainContainerViewController.h"
#import "ParkingSearchViewController.h"
#import "searchResult.h"
#import "SearchResultsViewController.h"


@interface MainContainerViewController ()<UITableViewDataSource, UITableViewDelegate, MKLocalSearchCompleterDelegate>


@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchBar;

@property (weak, nonatomic) IBOutlet UIButton *mainSearchButton;
@property (weak, nonatomic) IBOutlet UIView *spotListView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitchButton;
//@property (strong,nonatomic) MKLocalSearchRequest *request;
@property (strong, nonatomic) MKLocalSearchCompleter *completer;
@property (nonatomic, strong) NSArray <MKLocalSearchCompletion*> *spotsArray;
@property (strong,nonatomic) MKLocalSearchCompletion *completion;

@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spotListView.hidden = YES;
    self.searchResultTableView.hidden = YES;
    self.searchResultTableView.delegate =self;
    self.searchResultTableView.dataSource =self;
    self.searchResultTableView.rowHeight = 100;
    self.completer = [[MKLocalSearchCompleter alloc] init];
    self.mainSearchBar.delegate = self;
    self.completer.delegate = self;
    self.completer.filterType = MKSearchCompletionFilterTypeLocationsOnly;
}

- (IBAction)switchMode:(id)sender {
    if(self.spotListView.hidden){
        self.mapView.hidden = YES;
        self.spotListView.hidden = NO;
        
    }
    else{
        self.mapView.hidden = NO;
        self.spotListView.hidden = YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    self.searchResultTableView.hidden = NO;
    self.mapView.hidden = NO;
    self.spotListView.hidden = YES;
    
    if(searchText.length ==0){
        [self.mainSearchBar endEditing:YES];
        self.searchResultTableView.hidden = YES;
    }
    
  //  MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:self.request];
    self.completion = [[MKLocalSearchCompletion alloc] init];
    self.completer.queryFragment = searchText;
    NSLog(@"Error unfavoriting tweet: %@", self.completer.results);
    [self.searchResultTableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchResultTableView.hidden = YES;
    self.mapView.hidden = NO;
    self.spotListView.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKLocalSearchCompletion *completion = self.completer.results[indexPath.row];
    NSLog(@"Error unfavoriting tweet: %@", self.completer.results[indexPath.row]);
    searchResult *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
    if(cell == nil){
        cell = [[searchResult alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResult"];
    }
    cell.searchResultTitle.text = completion.title;
    // trying to resize text to work with Autolayout
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completer.results.count;
}
@end
