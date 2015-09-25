//
//  MenuHeaderPreLoggedIn.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol MenuHeaderPreLoggedInDelegate <NSObject>

-(void)loginButtonPressed;
-(void)signupButtonPressed;

@end

@interface MenuHeaderPreLoggedIn : UIView <TTTAttributedLabelDelegate>

@property (nonatomic, weak) id<MenuHeaderPreLoggedInDelegate> menuHeaderDelegate;

@end
