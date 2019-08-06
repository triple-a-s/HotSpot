//
//  BookedParkingSpotsViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/18/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "BookedParkingSpotsViewController.h"
#import "SearchCell.h"
#import "UserDataManager.h"
#import "DataManager.h"
#import "Listing.h"
#import "Booking.h"
#import "CurrentAndPastDetails.h"

@interface BookedParkingSpotsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *bookedTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *bookedTitleBar;
@property (strong, nonatomic) NSArray<Booking*> *bookings;
@property (strong, nonatomic) Listing *bookedlisting;


@end

@implementation BookedParkingSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookedTableView.dataSource = self;
    self.bookedTableView.delegate = self;
    self.bookedTableView.rowHeight = 134;
    [self.bookedTableView reloadData]; 
    [Booking getPastBookingsWithBlock:^(NSArray<Booking *> * _Nonnull bookings, NSError * _Nonnull error) {
        if(error){
            NSLog(@"%@", error);
        }
        else{
        self.bookings = bookings;
        [self.bookedTableView reloadData];
    }
    }];

}

# pragma mark - TableViewController methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *bookedCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(bookedCell == nil){
        bookedCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    Booking *booking = self.bookings[indexPath.row];
    Listing *listing = booking.listing;
    [listing fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
    [DataManager getAddressNameFromPoint:object[@"address"] withCompletion:^(NSString *name, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error);
            }
            else{
                bookedCell.searchTableAddress.text= name; 
            }
        }];
        PFFileObject *img = object[@"picture"];
        [img getDataInBackgroundWithBlock:^(NSData *imageData,NSError *error){
            UIImage *imageToLoad = [UIImage imageWithData:imageData];
            bookedCell.searchTableImage.image = imageToLoad;
        }];
        bookedCell.searchTablePrice.text = [NSString stringWithFormat: @"$%@/hr", object[@"price"]];
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    bookedCell.searchTableMilesAway.text = [dateFormatter stringFromDate:booking.createdAt];
    
    bookedCell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    bookedCell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    
    return bookedCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookings.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // perform segue
    Booking *booking = self.bookings[indexPath.row];
    [self performSegueWithIdentifier:@"pastToBooking"
                              sender:booking];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pastToBooking"]) {
        CurrentAndPastDetails *ourViewController = [segue destinationViewController];
        ourViewController.booking = sender;
        ourViewController.bookAgainButton.hidden = NO; 
    }
}
@end
