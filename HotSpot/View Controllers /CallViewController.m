//
//  CallViewController.m
//  HotSpot
//
//  Created by drealin on 7/31/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "CallViewController.h"

#import "Parse/Parse.h"
#import "CallManager.h"

@interface CallViewController ()<UITextFieldDelegate, CallManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, assign, getter=isSpinning) BOOL spinning;

@property (nonatomic, weak) IBOutlet UIButton *placeCallButton;
@property (nonatomic, weak) IBOutlet UITextField *outgoingValue;
@property (nonatomic, strong) UIAlertController* incomingAlertController;
@property (weak, nonatomic) IBOutlet UIView *callControlView;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *speakerSwitch;

@property (strong, nonatomic) CallManager *callManager;
@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.callManager = [[CallManager alloc] init];
    self.callManager.delegate = self;
    
    [self toggleUIState:YES showCallControl:NO];
    self.outgoingValue.delegate = self;
    
    self.outgoingValue.text = self.listing.homeowner.objectId;
    
    self.callManager.outgoingIdentity = self.outgoingValue.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


# pragma mark - CallManagerDelegate

- (void)toggleUIState:(BOOL)isEnabled showCallControl:(BOOL)showCallControl {
    self.placeCallButton.enabled = isEnabled;
    if (showCallControl) {
        self.callControlView.hidden = NO;
        self.muteSwitch.on = NO;
        self.speakerSwitch.on = YES;
    } else {
        self.callControlView.hidden = YES;
    }
}

- (void)setCallButtonTitle:(nullable NSString *)title {
    [self.placeCallButton setTitle:title forState:UIControlStateNormal];
}

- (void)presentAlert:(UIAlertController *)alertController {
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startSpin {
    if (!self.isSpinning) {
        self.spinning = YES;
        [self spinWithOptions:UIViewAnimationOptionCurveEaseIn];
    }
}

- (void)stopSpin {
    self.spinning = NO;
}

- (void)spinWithOptions:(UIViewAnimationOptions)options {
    typeof(self) __weak weakSelf = self;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:options
                     animations:^{
                         typeof(self) __strong strongSelf = weakSelf;
                         strongSelf.iconView.transform = CGAffineTransformRotate(strongSelf.iconView.transform, M_PI / 2);
                     }
                     completion:^(BOOL finished) {
                         typeof(self) __strong strongSelf = weakSelf;
                         if (finished) {
                             if (strongSelf.isSpinning) {
                                 [strongSelf spinWithOptions:UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 [strongSelf spinWithOptions:UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

# pragma mark - IBActions

- (IBAction)placeCall:(id)sender {
    [self.callManager placeCall:sender];
}

- (IBAction)muteSwitchToggled:(UISwitch *)sender {
    self.callManager.call.muted = sender.on;
}

- (IBAction)speakerSwitchToggled:(UISwitch *)sender {
    [self.callManager toggleAudioRoute:sender.on];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.outgoingValue resignFirstResponder];
    return YES;
}

@end
