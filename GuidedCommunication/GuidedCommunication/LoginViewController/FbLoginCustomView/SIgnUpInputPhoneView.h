//
//  SIgnUpInputPhoneView.h
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatPlaceholderTexField.h"

@protocol SignUpInputPhoneViewDelegate <NSObject>

- (void)signUpInputPhoneViewSendCodeButtonClicked;

@end

@interface SIgnUpInputPhoneView : UIView

@property (nonatomic, strong) FloatPlaceholderTexField *countryFloatTF;
@property (nonatomic, strong) FloatPlaceholderTexField *phoneNumberFloatTF;

@property (nonatomic, assign) id<SignUpInputPhoneViewDelegate> myDelegate;

@end
