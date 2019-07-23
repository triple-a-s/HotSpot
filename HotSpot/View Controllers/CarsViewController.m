//
//  CarsViewController.m
//  HotSpot
//
//  Created by aaronm17 on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CarsViewController.h"
#import "Parse/Parse.h"
#import "CarCell.h"

@interface CarsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *numCars;

@end

@implementation CarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    [self fetchCars];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchCars {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"cars"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cars, NSError *error) {
        if (cars != nil) {
            self.numCars = [[NSMutableArray alloc] initWithArray:cars];
            [self.tableView reloadData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CarCell *carCell = [self.tableView dequeueReusableCellWithIdentifier:@"CarCell"];
    Car *currentCar = self.numCars[indexPath.row];
    carCell.car = currentCar;
    [carCell setCell:currentCar];
    
    return carCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numCars.count;
}

@end
