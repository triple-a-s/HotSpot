//
//  SavedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CurrentParkingSpotsViewController.h"

@interface CurrentParkingSpotsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *currentTableView;


@end

@implementation CurrentParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // trying to resize text to work with Autolayout
    
    cell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return 10;
}


@end
