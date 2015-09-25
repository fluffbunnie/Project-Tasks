//
//  LoginView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol LoginViewDelegate <NSObject>

-(void)loginFbButtonClicked;
-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
-(void)forgotPasswordClick;
@end

@interface LoginView : UIView <UITextFieldDelegate, TTTAttributedLabelDelegate>
@property (nonatomic, weak) id<LoginViewDelegate> loginViewDelegate;
-(void)showView;
-(void)enableLoginButtons;
-(void)showKeyboard:(CGFloat)keyboardHeight;
-(void)hideKeyboard;
@end
