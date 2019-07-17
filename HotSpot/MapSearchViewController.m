//
//  MapSearchViewController.m
//  HotSpot
//
//  Created by aodemuyi on 7/16/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "MapSearchViewController.h"
#import "MapKit/MapKit.h"

@interface MapSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
@property (weak, nonatomic) IBOutlet MKMapView *searchMap;
@property (weak, nonatomic) IBOutlet UIButton *buttonToTable;
- (IBAction)buttonPressed:(id)sender;


- (IBAction)mapModePressed:(id)sender;


@end

@implementation MapSearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

#pragma mark - Action Items

/*- (IBAction)mapModePressed:(id)sender{
    [self performSegueWithIdentifier:<#(nonnull NSString *)#> sender:<#(nullable id)#>]
}
*/ 

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)buttonPressed:(id)sender {
      [self performSegueWithIdentifier:@"toTableMode" sender:nil];
}

@end
