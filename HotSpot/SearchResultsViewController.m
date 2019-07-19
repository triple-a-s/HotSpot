//
//  SearchResultsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "searchResult.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
