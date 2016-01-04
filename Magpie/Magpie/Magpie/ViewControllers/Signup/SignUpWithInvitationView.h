//
//  SignUpWithInvitationView.h
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol SignUpWithInvitationViewDelegate <NSObject>
-(void)signUpWithEmail:(NSString *)email password:(NSString *)password andCode:(NSString *)code;
-(void)goToRequestCodeScreen;
-(void)goToTermsOfService;
-(void)goToPrivacyPolicy;
@end

@interface SignUpWithInvitationView : UIView <TTTAttributedLabelDelegate, UITextFieldDelegate>
@property (nonatomic, weak) id<SignUpWithInvitationViewDelegate> signupViewDelegate;
-(void)enableSignupButton;
-(void)showKeyboard:(CGFloat)keyboardHeight;
-(void)hideKeyboard;
-(void)resignResponder;
-(void)setEmail:(NSString *)email;
-(void)setCode:(NSString *)code;
@end
