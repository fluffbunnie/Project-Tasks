//
//  MenuHeaderPostLoggedIn.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol MenuHeaderPostLoggedInDelegate <NSObject>
-(void)profileClicked;
@end

@interface MenuHeaderPostLoggedIn : UIView

@property (nonatomic, weak) id<MenuHeaderPostLoggedInDelegate> menuHeaderDelegate;
-(void)reload;
@end
