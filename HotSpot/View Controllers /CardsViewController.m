//
//  CardsViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CardsViewController.h"
#import "Parse/Parse.h"
#import "CardCell.h"
#import "AddCardViewController.h"
#import "EditCardViewController.h"


@interface CardsViewController () <UITableViewDelegate, UITableViewDataSource, AddCardViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <Card *> *numCards;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PFUser currentUser] fetchIfNeededInBackground];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchCards];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        CardCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        tappedCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        Card *currentCard = self.numCards[indexPath.row];
        EditCardViewController *editCarViewController = [segue destinationViewController];
        editCarViewController.card = currentCard;
        tappedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark - Helper Methods

//this queries the user for the user's cards, and stores them in an array to be displayed later
- (void)fetchCards {
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"cards"];
    PFQuery *query = relation.query;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cards, NSError *error) {
        if (cards != nil) {
            self.numCards = [[NSMutableArray alloc] initWithArray:cards];
            [self.tableView reloadData];
        }
    }];
}

//refreshes the cards when the refresh control is used
- (void)beginRefreshing {
    [self fetchCards];
    [self.refreshControl endRefreshing];
}

//sets each cell to the corresponding card in the array of cards
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CardCell *cardCell = [self.tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    Card *currentCard = self.numCards[indexPath.row];
    [cardCell configureCell:currentCard];
    
    return cardCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numCards.count;
}

- (void)didAddCard:(nonnull Card *)card {
    [self.numCards insertObject:card atIndex:(self.numCards.count-1)];
    [self.tableView reloadData];
}

@end
