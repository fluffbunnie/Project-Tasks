//
//  MenuView.h
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MenuHeaderPreLoggedIn.h"
#import "MenuHeaderPostLoggedIn.h"

static const NSInteger MENU_ITEM_FAVORITE_INDEX = 0;
static const NSInteger MENU_ITEM_INBOX_INDEX = 1;
static const NSInteger MENU_ITEM_YOUR_PLACE_INDEX = 2;
static const NSInteger MENU_ITEM_UPCOMING_TRIPS_INDEX = 3;
static const NSInteger MENU_ITEM_HOW_IT_WORKS_INDEX = 4;
static const NSInteger MENU_ITEM_APP_FEEDBACK_INDEX = 5;
static const NSInteger MENU_ITEM_ABOUT_INDEX = 6;

@protocol MenuViewDelegate <NSObject>
@optional
-(void)menuUserProfileClick;
-(void)menuLoginItemClick;
-(void)menuSignupItemClick;

@required
-(void)menuItemClickAtIndex:(NSIndexPath *)indexPath;
@end

@interface MenuView : UIView <UITableViewDataSource, UITableViewDelegate, MenuHeaderPostLoggedInDelegate, MenuHeaderPreLoggedInDelegate>
@property (nonatomic, weak) id<MenuViewDelegate> menuViewDelegate;
-(void)updateUserObj;
-(void)showMenuView;
-(void)updateMenu;

@end
