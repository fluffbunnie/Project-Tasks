//
//  InvitationStatusWithPushNotificationView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol InvitationStatusWithPushNotificationViewDelegate <NSObject>
-(void)changeEmailAddress;
@end

@interface InvitationStatusWithPushNotificationView : UIView
@property (nonatomic, weak) id<InvitationStatusWithPushNotificationViewDelegate> delegate;
-(void)setEmailAddress:(NSString *)emailAddress;
@end
