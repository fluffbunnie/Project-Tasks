//
//  InvitationStatusWithPushNotificationViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 8/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationStatusWithPushNotificationView.h"
#import <Parse/Parse.h>

@interface InvitationStatusWithPushNotificationViewController : UIViewController <InvitationStatusWithPushNotificationViewDelegate>
@property (nonatomic, strong) PFObject *invitationCodeObj;
-(void)setEmail:(NSString *)email;
@end
