//
//  CurrentCell.h
//  HotSpot
//
//  Created by aodemuyi on 7/17/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Listing.h"
NS_ASSUME_NONNULL_BEGIN

<<<<<<< HEAD:HotSpot/CurrentCell.h
@interface CurrentCell: UITableViewCell

=======
@interface ParkingSearchViewController : UIViewController <MKMapViewDelegate>
@property (strong,nonatomic) CLLocation *initialLocation; 
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray<Listing *> *listings;
>>>>>>> a48aac273aa4b1675d8b78c8496db89752d39c98:HotSpot/ParkingSearchViewController.h

@end

NS_ASSUME_NONNULL_END
