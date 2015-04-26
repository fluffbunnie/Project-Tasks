//
//  SignUpFbView.h
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpFbViewDelegate <NSObject>

- (void)signUpFbViewLoginButtonClicked;

@end

@interface SignUpFbView : UIView

@property (nonatomic, assign) id<SignUpFbViewDelegate> myDelegate;

@end
