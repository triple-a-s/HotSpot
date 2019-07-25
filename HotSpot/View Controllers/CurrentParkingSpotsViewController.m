//
//  SavedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CurrentParkingSpotsViewController.h"
#import "SearchCell.h"

@interface CurrentParkingSpotsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *savedTitleBar;


@end

@implementation CurrentParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTableView.dataSource = self;
    self.currentTableView.delegate = self;
    self.currentTableView.rowHeight = 134;
}


# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SearchCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"SpotCell"];
    if(currentCell == nil){
        currentCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpotCell"];
    }
    
    //placehodlder information
    currentCell.searchTableAddress.text= @"100 West Lake";
    currentCell.searchTableMilesAway.text = @"Time till park: 2hrs";
    currentCell.searchTablePrice.text= @"$5/hr";
    currentCell.searchTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    // trying to resize text to work with Autolayout
    currentCell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    currentCell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    
    return currentCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}


@end
