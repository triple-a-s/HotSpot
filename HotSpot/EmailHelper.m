//
//  EmailHelper.m
//  HotSpot
//
//  Created by aaronm17 on 8/6/19.
//  Copyright © 2019 aodemuyi. All rights reserved.
//

#import "EmailHelper.h"
#import <SendGrid.h>
#import <SendGridEmail.h>
#import <Parse/Parse.h>

void sendEmail(NSString * _Nonnull text, UIImageView * _Nullable image, NSString * _Nonnull reportedUser, NSString * _Nonnull reportType) {
    SendGrid *sendGrid = [SendGrid apiUser:@"aaronm17" apiKey:@"TuvaLuI7S4O8!!"];
    SendGridEmail *email = [[SendGridEmail alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    
    if (!(image.image == nil)) {
        [email attachImage:image.image];
    }
    NSString *subject = [NSString stringWithFormat:@"%@ report for: %@", reportType, reportedUser];

    /*if ([reportType isEqualToString:@"Homeowner"]) {
        subject = [NSString stringWithFormat:@"Homeowner report for: %@", reportedUser];
    } else {
        subject = [NSString stringWithFormat:@"Driver report for: %@", reportedUser];
    }*/
    email.to = @"hotspothelp@yahoo.com";
    email.from = currentUser[@"email"];
    email.subject = subject;
    email.text = text;
    
    [sendGrid sendWithWeb:email];
}

@implementation EmailHelper


@end
