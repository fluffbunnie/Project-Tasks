//
//  SignUpAirbnbView.h
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpAirbnbViewDelegate <NSObject>

- (void)signUpAirbnbViewLoginButtonClicked;

@end

@interface SignUpAirbnbView : UIView

@property (nonatomic, assign) id<SignUpAirbnbViewDelegate> myDelegate;

@end
