//
//  AddCardViewController.m
//  HotSpot
//
//  Created by aaronm17 on 8/8/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "AddCardViewController.h"
#import "Parse/Parse.h"
#import "Card.h"
#import "RegexHelper.h"

@interface AddCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cardType;
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UITextField *expirationDate;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *isDefaultCard;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addCard {
    BOOL selected = [self.isDefaultCard isSelected];
    Card *newCard = [Card new];
    newCard = [newCard initWithInfo:self.cardType.text withBank:self.bank.text withExpiration:self.expirationDate.text withNumber:self.cardNumber.text];
    [Card addCard:newCard withDefault:selected withCompletion:^(BOOL succeeded, NSError * _Nullable error)   {
        if (succeeded) {
            [self.delegate didAddCard:newCard];
        }
    }];
}

#pragma mark - Private methods

- (IBAction)didTapCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapDefaultButton:(UIButton *)sender {
    [self.isDefaultCard setSelected:(![self.isDefaultCard isSelected])];
}

- (IBAction)didTapConfirm:(UIBarButtonItem *)sender {
    UIAlertController *alert = [RegexHelper createAlertController];
    
    if (isValidCard(self.cardType.text, self.bank.text, self.expirationDate.text, self.cardNumber.text, alert, NO)) {
        [self addCard];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

@end
