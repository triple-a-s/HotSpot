//
//  BookedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "BookedParkingSpotsViewController.h"
#import "SearchCell.h"

@interface BookedParkingSpotsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *bookedTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *bookedTitleBar;

@end

@implementation BookedParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookedTableView.dataSource = self;
    self.bookedTableView.delegate = self;
    self.bookedTableView.rowHeight = 134 ;
}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SearchCell *bookedCell = [tableView dequeueReusableCellWithIdentifier:@"SpotCell"];
    if(bookedCell == nil){
        bookedCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpotCell"];
    }
    
    //placehodlder information
    bookedCell.searchTableAddress.text= @"100 West Lake";
    bookedCell.searchTableMilesAway.text = @"Parked 4/5/18";
    bookedCell.searchTablePrice.text= @"$31.47";
    bookedCell.searchTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    // trying to resize text to work with Autolayout
    bookedCell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    bookedCell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    
    return bookedCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}


@end
