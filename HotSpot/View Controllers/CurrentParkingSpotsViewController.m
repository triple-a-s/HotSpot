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
    self.currentTableView.rowHeight = 134;
}

<<<<<<< HEAD:HotSpot/CurrentParkingSpotsViewController.m
# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     This is where we are passing information into the cells.
     For now, I have placeholder information so that when we merge
     I can have data to load actual information into the tables.
     */
    
    SpotCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"SpotCell"];
    if(currentCell == nil){
        currentCell = [[SpotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpotCell"];
    }
    
    //placehodlder information
    currentCell.spotTableAddress.text= @"100 West Lake";
    currentCell.spotTableDetails.text = @"Time till park: 2hrs";
    currentCell.spotTablePrice.text= @"$5/hr";
    currentCell.spotTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    // trying to resize text to work with Autolayout
    currentCell.spotTablePrice.adjustsFontSizeToFitWidth = YES;
    currentCell.spotTableDetails.adjustsFontSizeToFitWidth = YES;
    
    return currentCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}


=======
>>>>>>> 21a65e1c7aae4143cc7069f1f42f2a5bf50da038:HotSpot/View Controllers/CurrentParkingSpotsViewController.m
@end
