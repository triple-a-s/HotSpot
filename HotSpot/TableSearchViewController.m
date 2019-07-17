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
- (IBAction)modeButtonPressed:(id)sender;
- (IBAction)toMapPressed:(id)sender;

@end

@implementation TableSearchViewController


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.dataSource= self;
    self.searchTableView.delegate=self;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(cell == nil){
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    cell.searchTableAddress.text= @"100 West Lake Jones";
    cell.searchTableMilesAway.text = @"50 miles away";
    cell.searchTablePrice.text= @"$5/hr";
    cell.searchTableImage.image = [UIImage imageNamed:@"houseimageexample"];
    return cell;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (IBAction)toMapPressed:(id)sender {
    [self performSegueWithIdentifier:@"toMapMode" sender:nil];
}
@end
