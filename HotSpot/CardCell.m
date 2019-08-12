//
//  CardCell.m
//  
//
//  Created by aaronm17 on 8/7/19.
//

#import "CardCell.h"
#import "Card.h"

@interface CardCell ()

@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *expirationDate;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UIImageView *isDefault;


@end

@implementation CardCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Card *)card {
    PFUser *currentUser = [PFUser currentUser];
    Card *defaultCard = [currentUser objectForKey:@"defaultCard"];
    NSString *defaultId = defaultCard.objectId;
    NSString *currentId = card.objectId;
    BOOL isCardDefault = [defaultId isEqualToString: currentId];
    if (isCardDefault) {
        self.isDefault.hidden = NO;
    } else {
        self.isDefault.hidden = YES;
    }
    self.cardType.text = card.type;
    self.bank.text = card.bank;
    self.expirationDate.text = card.expiration;
    self.cardNumber.text = card.number;
}

@end
