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
    // initializing and reloading tableView
    self.bookedTableView.dataSource = self;
    self.bookedTableView.delegate = self;
    self.bookedTableView.rowHeight = 134;
    [self.bookedTableView reloadData];
    
    //initializing bookings array
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
    
    //setting up the tableView given the bookings array
    SearchCell *bookedCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if(bookedCell == nil){
        bookedCell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    // retreiving and fetching the listing and then using that information
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
    }];
    
    // used to display time that the person parked
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy' at 'hh:mm"];
    bookedCell.searchTableMilesAway.text = [formatter stringFromDate: booking.startTime];

    // autolayout stuff that is most likely not working and will be looked into
    bookedCell.searchTablePrice.adjustsFontSizeToFitWidth = YES;
    bookedCell.searchTableMilesAway.adjustsFontSizeToFitWidth = YES;
    
    return bookedCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return the size of the bookings array
    return self.bookings.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // perform segue
    Booking *booking = self.bookings[indexPath.row];
    [self performSegueWithIdentifier:@"pastToBooking"
                              sender:booking];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // sending the booking so that we can get some more information in the details page 
    if([segue.identifier isEqualToString:@"pastToBooking"]) {
        CurrentAndPastDetails *ourViewController = [segue destinationViewController];
        ourViewController.booking = sender;
    }
}
@end
