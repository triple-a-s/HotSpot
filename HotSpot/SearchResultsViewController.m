//
//  SearchResultsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "MainContainerViewController.h"
#import "searchResult.h"
#import "MapViewController.h"
#import "MapKit/MapKit.h"

@interface SearchResultsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResultTableView.delegate =self;
    self.searchResultTableView.dataSource =self;
    self.searchResultTableView.rowHeight = 100;
    [self.searchResultTableView reloadData];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        searchResult *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
        if(cell == nil){
            cell = [[searchResult alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResult"];
        }
        //placehodlder information
    cell.searchResultTitle.text = @"Wendys";
        // trying to resize text to work with Autolayout
        return cell;
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
