//
//  RequestInvitationCodeView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestInvitationCodeViewDelegate <NSObject>
-(void)authenticateWithFacebook;
-(void)requestCodeWithEmail:(NSString *)email;
@end

@interface RequestInvitationCodeView : UIView <UITextFieldDelegate>
@property (nonatomic, weak) id<RequestInvitationCodeViewDelegate> delegate;
-(void)enableInvitationCodeRequestButton;
-(void)setEmail:(NSString *)email;

-(void)showKeyboard:(CGFloat)keyboardHeight;
-(void)hideKeyboard;

@end
