//
//  SavedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CurrentParkingSpotsViewController.h"
#import "SpotCell.h"

@interface CurrentParkingSpotsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *savedTitleBar;


@end

@implementation CurrentParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTableView.dataSource = self;
    self.currentTableView.delegate = self;
    self.currentTableView.rowHeight = 134 ;
    // Do any additional setup after loading the view.
}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SpotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotCell"];
    if(cell == nil){
        cell = [[SpotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpotCell"];
    }
    
    //placehodlder information
    cell.spotTableAddress.text= @"100 West Lake";
    cell.spotTableMilesAway.text = @"Time till park: 2hrs";
    cell.spotTablePrice.text= @"$5/hr";
    cell.spotTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    
    // trying to resize text to work with Autolayout
    cell.spotTablePrice.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}


@end
