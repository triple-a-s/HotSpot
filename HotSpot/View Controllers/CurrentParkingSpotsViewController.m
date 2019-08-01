//
//  SavedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CurrentParkingSpotsViewController.h"
#import "DetailsViewController.h"
#import "SearchCell.h"
#import "Booking.h"
#import "Listing.h"
#import "DataManager.h"

@interface CurrentParkingSpotsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *savedTitleBar;
@property (strong, nonatomic) NSArray<Booking*> *bookings;


@end

@implementation CurrentParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTableView.dataSource = self;
    self.currentTableView.delegate = self;
    self.currentTableView.rowHeight = 134;
    [self.currentTableView reloadData];
    [Booking getCurrentBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        if(error){
            NSLog(@"%@", error);
        }
        else{
            self.bookings = bookings;
            [self.currentTableView reloadData];
        }
    }];
    
}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(currentCell == nil){
        currentCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    Booking *booking = self.bookings[indexPath.row];
    Listing *listing = booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [DataManager getAddressNameFromPoint:object[@"address"] withCompletion:^(NSString *name, NSError * _Nullable error) {
                currentCell.searchTableAddress.text= name;
        }];
        PFFileObject *img = object[@"picture"];
        [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
            UIImage *imageToLoad = [UIImage imageWithData:imageData];
            currentCell.searchTableImage.image = imageToLoad;
        }];
        currentCell.searchTablePrice.text = [NSString stringWithFormat: @"$%@/hr", object[@"price"]];
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    currentCell.searchTableMilesAway.text = [dateFormatter stringFromDate:booking.createdAt];
    
    currentCell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    currentCell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    
    return currentCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // I return 10 for now just to see if this method is working
    return self.bookings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // perform segue
    Booking *booking = self.bookings[indexPath.row];
    Listing *listing = booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error){
    [self performSegueWithIdentifier:@"currentToDetails"
                              sender:object];
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"currentToDetails"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.listing = sender;
       // detailsViewController.bookingButton.hidden = YES; 
    }
}


@end
