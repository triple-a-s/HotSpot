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
#import "AddCarViewController.h"
#import "EditCarViewController.h"

@interface CarsViewController () <UITableViewDelegate, UITableViewDataSource, AddCarViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Car *> *numCars;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PFUser currentUser] fetchIfNeededInBackground];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchCars];

    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        CarCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        tappedCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        Car *currentCar = self.numCars[indexPath.row];
        EditCarViewController *editCarViewController = [segue destinationViewController];
        editCarViewController.car = currentCar;
        tappedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark - Helper Methods

//this queries the user for the user's cars, and stores them in an array to be displayed later
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

//refreshes the cars when the refresh control is used
- (void)beginRefreshing {
    [self fetchCars];
    [self.refreshControl endRefreshing];
}

//sets each cell to the corresponding car in the array of cars
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CarCell *carCell = [self.tableView dequeueReusableCellWithIdentifier:@"CarCell"];
    Car *currentCar = self.numCars[indexPath.row];
    [carCell configureCell:currentCar];
    
    return carCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numCars.count;
}

- (void)didAddCar:(nonnull Car *)car {
    [self.numCars insertObject:car atIndex:(self.numCars.count-1)];
    [self.tableView reloadData];
}

@end
