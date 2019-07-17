//
//  TableSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "TableSearchViewController.h"
#import "SearchCell.h"

@interface TableSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *tableSearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tableModeButton;
@property (weak, nonatomic) IBOutlet UIButton *toMapButton;

@end

@implementation TableSearchViewController


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.dataSource= self;
    self.searchTableView.delegate=self;
    self.searchTableView.rowHeight=300;
}


# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    
    //placehodlder information
    cell.searchTableAddress.text= @"100 West Lake";
    cell.searchTableMilesAway.text = @"50 miles away";
    cell.searchTablePrice.text= @"$5/hr";
    cell.searchTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}

# pragma mark - Action Methods

- (IBAction)toMapPressed:(id)sender {
    [self performSegueWithIdentifier:@"toMapMode" sender:nil];
}

@end
