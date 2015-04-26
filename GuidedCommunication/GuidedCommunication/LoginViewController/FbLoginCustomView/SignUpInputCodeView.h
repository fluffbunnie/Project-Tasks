//
//  SignUpInputCodeView.h
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatPlaceholderTexField.h"

@protocol SignUpInputCodeViewDelegate <NSObject>

- (void)signUpInputCodeViewVerifyButtonClicked;

@end

@interface SignUpInputCodeView : UIView

@property (nonatomic, strong) FloatPlaceholderTexField *codeFloatTF;
@property (nonatomic, assign) id<SignUpInputCodeViewDelegate> myDelegate;

@end
