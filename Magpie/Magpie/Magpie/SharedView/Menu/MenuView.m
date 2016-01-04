//
//  MenuView.m
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MenuView.h"
#import "MenuItemTableViewCell.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "Mixpanel.h"

static NSString * CELL_IDENTIFIER = @"menuCell";

static NSString * MENU_NAVIGATION_CLOSE_ICON_RED = @"NavigationBarCloseIconRed";

static NSString * MENU_FAVORITE_NORMAL_ICON_NAME = @"MenuFavoriteIcon";
static NSString * MENU_FAVORITE_HIGHLIGHT_ICON_NAME = @"MenuFavoriteIconHighlight";
static NSString * MENU_INBOX_NORMAL_ICON_NAME = @"MenuInboxIcon";
static NSString * MENU_INBOX_HIGHLIGHT_ICON_NAME = @"MenuInboxIconHighlight";
static NSString * MENU_PLACE_NORMAL_ICON_NAME = @"MenuPlaceIcon";
static NSString * MENU_PLACE_HIGHLIGHT_ICON_NAME = @"MenuPlaceIconHighlight";
static NSString * MENU_UPCOMING_TRIP_NORMAL_ICON_NAME = @"MenuUpcomingTripIcon";
static NSString * MENU_UPCOMING_TRIP_HIGHLIGHT_ICON_NAME = @"MenuUpcomingTripIcon";
static NSString * MENU_HOW_IT_WORKS_NORMAL_ICON_NAME = @"MenuHowItWorkIcon";
static NSString * MENU_HOW_IT_WORKS_HIGHLIGHT_ICON_NAME = @"MenuHowItWorkIconHighlight";
static NSString * MENU_FEEDBACK_NORMAL_ICON_NAME = @"MenuFeedbackIcon";
static NSString * MENU_FEEDBACK_HIGHLIGHT_ICON_NAME = @"MenuFeedbackIconHighlight";
static NSString * MENU_ABOUT_NORMAL_ICON_NAME = @"MenuAboutIcon";
static NSString * MENU_ABOUT_HIGHLIGHT_ICON_NAME = @"MenuAboutIconHighlight";
static NSString * MENU_REQUEST_NORMAL_ICON_NAME = @"MenuRequestIcon";
static NSString * MENU_REQUEST_HIGHLIGHT_ICON_NAME = @"MenuRequestIconHighligh";

static NSString * MENU_FAVORITE_LABEL = @"Favorites";
static NSString * MENU_INBOX_LABEL = @"Messages";
static NSString * MENU_PLACE_LABEL = @"Your Place";
static NSString * MENU_UPCOMING_TRIP_LABEL = @"Upcoming Trips";
static NSString * MENU_HOW_IT_WORKS_LABEL = @"How Magpie Works";
static NSString * MENU_FEEDBACK_LABEL = @"App Feedback";
static NSString * MENU_ABOUT_LABEL = @"About";

@interface MenuView()

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat xFromCenter;

@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UIView *emptyTouchToCloseView;

@property (nonatomic, strong) UIButton *menuClosingButton;
@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) MenuHeaderPreLoggedIn *preLoggedInHeaderView;
@property (nonatomic, strong) MenuHeaderPostLoggedIn *postLoggedInHeaderView;

@end

@implementation MenuView
#pragma mark - initiation
/**
 * Lazily init the menu container
 * @return UIView
 */
-(UIView *)menuContainer {
    if (_menuContainer == nil) {
        _menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, self.contentHeight)];
        _menuContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }
    return _menuContainer;
}

/**
 * Lazily init the empty touch to close view
 * @return UIView
 */
-(UIView *)emptyTouchToCloseView {
    if (_emptyTouchToCloseView == nil) {
        _emptyTouchToCloseView = [[UIView alloc] initWithFrame:CGRectMake(250, 0, self.contentWidth - 250, self.contentHeight)];
        UITapGestureRecognizer *tapToCloseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenuView)];
        [_emptyTouchToCloseView addGestureRecognizer:tapToCloseGesture];
        
        UIPanGestureRecognizer *menuDragged = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(menuDragged:)];
        [self.emptyTouchToCloseView addGestureRecognizer:menuDragged];
    }
    return _emptyTouchToCloseView;
}

/**
 * Lazily init the menu closing button
 * @return UIButton
 */
-(UIButton *)menuClosingButton {
    if (_menuClosingButton == nil) {
        _menuClosingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        [_menuClosingButton setImage:[UIImage imageNamed:MENU_NAVIGATION_CLOSE_ICON_RED] forState:UIControlStateNormal];
        [_menuClosingButton addTarget:self action:@selector(hideMenuView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuClosingButton;
}

/**
 * Lazily init the menu table
 * @return menu table
 */
-(UITableView *)menuTable {
    if (_menuTable == nil) {
        _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, self.contentHeight)];
        _menuTable.scrollsToTop = NO;
        _menuTable.delegate = self;
        _menuTable.dataSource = self;
        _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTable.backgroundColor = [UIColor clearColor];
        [_menuTable registerClass:MenuItemTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _menuTable;
}

/**
 * Lazily init the pre-logged in view header of the menu
 * @return MenuHeaderPreLoggedIn
 */
-(MenuHeaderPreLoggedIn *)preLoggedInHeaderView {
    if (_preLoggedInHeaderView == nil) {
        _preLoggedInHeaderView = [[MenuHeaderPreLoggedIn alloc] initWithFrame:CGRectMake(0, 0, 250, 204)];
        _preLoggedInHeaderView.menuHeaderDelegate = self;
    }
    return _preLoggedInHeaderView;
}

/**
 * Lazily init the post-logged in view header of the menu
 * @return MenuHeaderPostLoggedIn
 */
-(MenuHeaderPostLoggedIn *)postLoggedInHeaderView {
    if (_postLoggedInHeaderView == nil) {
        _postLoggedInHeaderView = [[MenuHeaderPostLoggedIn alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 204)];
        _postLoggedInHeaderView.menuHeaderDelegate = self;
    }
    return _postLoggedInHeaderView;
}



#pragma mark - public methods
/**
 * Init the view given its user. If the user is not define, then
 * show the clear user logged in
 * @param PFObject
 */
-(id)init {
    self.contentWidth = [[UIScreen mainScreen] bounds].size.width;
    self.contentHeight = [[UIScreen mainScreen] bounds].size.height;
    self = [super initWithFrame:CGRectMake(-self.contentWidth, 0, self.contentWidth, self.contentHeight)];
    if (self) {
        [self addSubview:[self menuContainer]];
        [self addSubview:[self emptyTouchToCloseView]];
        
        [self.menuContainer addSubview:[self menuTable]];
        [self.menuContainer addSubview:[self menuClosingButton]];
        
        [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
            if (userObj == nil) self.menuTable.tableHeaderView = [self preLoggedInHeaderView];
            else self.menuTable.tableHeaderView = [self postLoggedInHeaderView];
        }];
    }
    return self;
}

-(void)dealloc {
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
}

/**
 * Update the user object of the menu vuew
 * @param PFObject
 */
-(void)updateUserObj {
    [self.postLoggedInHeaderView reload];
    [self.menuTable reloadData];
}

/**
 * Update menu table
 */
-(void)updateMenu {
    [self.menuTable reloadData];
}

/**
 * Show the current menu view
 */
-(void)showMenuView {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
    }];
}

/**
 * Hide the current menu view
 */
-(void)hideMenuView {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-self.contentWidth, 0, self.contentWidth, self.contentHeight);
    }];
}

/**
 * Handle the action when the menu is dragged
 * @param pan gesture
 */
-(void)menuDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    self.xFromCenter = [gestureRecognizer translationInView:self].x;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            if (self.xFromCenter < 0)
                self.frame = CGRectMake(self.xFromCenter, 0, self.contentWidth, self.contentHeight);
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            if (self.xFromCenter < -25) [self hideMenuView];
            else [self showMenuView];
            break;
        };
            
        default: break;
    }
}

#pragma mark - subview delegate
/**
 * MenuHeaderPreLoggedIn Delegate
 * Handle the action when the login button is clicked
 */
-(void)loginButtonPressed {
    [[Mixpanel sharedInstance] track:@"Login Click - Menu"];
    [self.menuViewDelegate menuLoginItemClick];
}

/**
 * MenuHeaderPreLoggedIn Delegate
 * Handle the action when the signup button is clicked
 */
-(void)signupButtonPressed {
    [[Mixpanel sharedInstance] track:@"Sign Up Click - Menu"];
    [self.menuViewDelegate menuSignupItemClick];
}

/**
 * MenuHeaderPostLoggedIn Delegate
 * Handle the action when the profile button is clicked
 */
-(void)profileClicked {
    [[Mixpanel sharedInstance] track:@"Profile Click - Menu"];
    [self.menuViewDelegate menuUserProfileClick];
}



#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[MenuItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    
    UIImage *normalIcon;
    UIImage *highlightIcon;
    NSString *itemLabel;
    
    switch (indexPath.row) {
        case MENU_ITEM_FAVORITE_INDEX:
            normalIcon = [UIImage imageNamed:MENU_FAVORITE_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_FAVORITE_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_FAVORITE_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - Favorite Click"];
            break;
            
        case MENU_ITEM_INBOX_INDEX:
            normalIcon = [UIImage imageNamed:MENU_INBOX_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_INBOX_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_INBOX_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - Messages Click"];
            break;
            
        case MENU_ITEM_YOUR_PLACE_INDEX:
            normalIcon = [UIImage imageNamed:MENU_PLACE_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_PLACE_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_PLACE_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - Your Place Click"];
            break;
            
        case MENU_ITEM_UPCOMING_TRIPS_INDEX:
            normalIcon = [UIImage imageNamed:MENU_UPCOMING_TRIP_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_UPCOMING_TRIP_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_UPCOMING_TRIP_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - Upcoming Trips Click"];
            break;
            
        case MENU_ITEM_HOW_IT_WORKS_INDEX:
            normalIcon = [UIImage imageNamed:MENU_HOW_IT_WORKS_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_HOW_IT_WORKS_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_HOW_IT_WORKS_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - How It Works Click"];
            break;
            
        case MENU_ITEM_APP_FEEDBACK_INDEX:
            normalIcon = [UIImage imageNamed:MENU_FEEDBACK_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_FEEDBACK_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_FEEDBACK_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - App Feedback Click"];
            break;
        
        case MENU_ITEM_ABOUT_INDEX:
            normalIcon = [UIImage imageNamed:MENU_ABOUT_NORMAL_ICON_NAME];
            highlightIcon = [UIImage imageNamed:MENU_ABOUT_HIGHLIGHT_ICON_NAME];
            itemLabel = MENU_ABOUT_LABEL;
            [[Mixpanel sharedInstance] track:@"Menu - App About Click"];
            break;
            
        default:
            break;
    }
    
    [cell setIcon:normalIcon highlighedStateIcon:highlightIcon andTitle:itemLabel];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSInteger numNotif = appDelegate.numNotif;
    if (numNotif > 0 && indexPath.row == MENU_ITEM_INBOX_INDEX) [cell setNotificationLabel:[NSString stringWithFormat:@"%d", (int)numNotif]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.menuViewDelegate menuItemClickAtIndex:indexPath];
}



@end
