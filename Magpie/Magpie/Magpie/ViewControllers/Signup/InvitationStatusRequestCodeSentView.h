//
//  InvitationStatusRequestCodeSentView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol InvitationStatusRequestCodeSentViewDelegate <NSObject>

-(void)completeRegistration;
-(void)resendEmail;

@end

@interface InvitationStatusRequestCodeSentView : UIView
@property (nonatomic, weak) id<InvitationStatusRequestCodeSentViewDelegate> delegate;
-(void)setEmailAddress:(NSString *)emailAddress;
@end
