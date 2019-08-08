//
//  EditCardViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "EditCardViewController.h"
#import "Card.h"
#import "RegexHelper.h"
#import "CardsViewController.h"

@interface EditCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cardType;
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UITextField *expirationDate;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic) BOOL isSameCard;

@end

@implementation EditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardType.text = self.card.type;
    self.bank.text = self.card.bank;
    self.expirationDate.text = self.card.expiration;
    self.cardNumber.text = self.card.number;
    Card *defaultCard = [[PFUser currentUser] objectForKey:@"defaultCard"];
    NSString *defaultId = defaultCard.objectId;
    NSString *currentId = self.card.objectId;
    BOOL isCardDefault = [defaultId isEqualToString:currentId];
    [self.defaultButton setSelected:isCardDefault];
}

#pragma mark - Private methods

- (void)configureCard {
    self.card[@"type"] = self.cardType.text;
    self.card[@"bank"] = self.bank.text;
    self.card[@"expiration"] = self.expirationDate.text;
    self.card[@"number"] = self.cardNumber.text;
    PFUser *currentUser = [PFUser currentUser];
    if (self.defaultButton.selected) {
        [Card changeDefaultCard:self.card withUser:currentUser];
    }
    [self.card saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            }];
        }
    }];
}

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapDefaultButton:(UIButton *)sender {
    [self.defaultButton setSelected:(![self.defaultButton isSelected])];
}

- (IBAction)didTapDone:(UIBarButtonItem *)sender {
    UIAlertController *alert = [RegexHelper createAlertController];
    if ([self.card[@"number"] isEqualToString:self.cardNumber.text]) {
        self.isSameCard = YES;
    }
    if (isValidCard(self.cardType.text, self.bank.text, self.expirationDate.text, self.cardNumber.text, alert, self.isSameCard)) {
        [self configureCard];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

@end
