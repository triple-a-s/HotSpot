//
//  CallManager.h
//  HotSpot
//
//  Created by drealin on 8/1/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import TwilioVoice;

NS_ASSUME_NONNULL_BEGIN

@protocol CallManagerDelegate
- (void)toggleUIState:(BOOL)isEnabled showCallControl:(BOOL)showCallControl;
- (void)setCallButtonTitle:(nullable NSString *)title;
- (void)presentAlert:(UIAlertController *)alertController;
- (void)startSpin;
- (void)stopSpin;
- (void)dismiss;
@end

@interface CallManager : NSObject
@property (nonatomic, weak) id<CallManagerDelegate> delegate;
@property (nonatomic, strong) TVOCall *call;
@property (nonatomic, strong) NSString *outgoingIdentity;
- (void)placeCall:(id)sender;
- (void)toggleAudioRoute:(BOOL)toSpeaker;
@end


NS_ASSUME_NONNULL_END
