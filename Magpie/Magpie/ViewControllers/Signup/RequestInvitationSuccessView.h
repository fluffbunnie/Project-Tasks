//
//  RequestInvitationSuccessView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol RequestInvitationSuccessViewDelegate <NSObject>

-(void)enablePushNotification;
-(void)changeEmailAddress;

@end

@interface RequestInvitationSuccessView : UIView
@property (nonatomic, weak) id<RequestInvitationSuccessViewDelegate> delegate;
-(void)showView;
-(void)setEmailAddress:(NSString *)emailAddress;
@end
