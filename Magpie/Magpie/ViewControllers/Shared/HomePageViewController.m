//
//  HomePageViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageViewController.h"
#import "MyProfileTableViewController.h"
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"
#import "MyPlaceListViewController.h"
#import "MyUpcomingTripViewController.h"
#import "AppFeedbackViewController.h"
#import "BrowsePropertyViewController.h"
#import "Device.h"
#import "UserManager.h"
#import "HowItWorkViewController.h"
#import "AppDelegate.h"
#import "Mixpanel.h"
#import "FAQViewController.h"
#import "PythonParsingRequest.h"
#import "HomePageRequestForUpdatePopupView.h"
#import "PlaceSearchResultsViewController.h"
#import "MyPlaceDetailViewController.h"
#import "Amenity.h"
#import "ParseConstant.h"

@interface HomePageViewController ()

@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) HomePageView *homePageView;
@property (nonatomic, strong) SearchTableView *searchTableView;
@property (nonatomic, strong) MenuView *menuView;

@end

@implementation HomePageViewController

#pragma mark - view initiation
/**
 * Lazily init the home page view
 * @return HomePageView
 */
-(HomePageView *)homePageView {
    if (_homePageView == nil) {
        _homePageView = [[HomePageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _homePageView.homePageDelegate = self;
    }
    return _homePageView;
}

/**
 * Lazily init the search table view
 * @return SearchTableView
 */
-(SearchTableView *)searchTableView {
    if (_searchTableView == nil) {
        _searchTableView = [[SearchTableView alloc] initWithOrigin:CGPointMake(52, 25) andWidth:self.screenWidth - 70];
        _searchTableView.searchDelegate = self;
    }
    return _searchTableView;
}

/**
 * Lazily init the menu view
 * @return menu view
 */
-(MenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[MenuView alloc] init];
        _menuView.menuViewDelegate = self;
    }
    return _menuView;
}

#pragma mark - view cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self homePageView]];
    [self.view addSubview:[self searchTableView]];
    [self.view addSubview:[self menuView]];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
    }];
    [self performSelector:@selector(checkForUpdate) withObject:nil afterDelay:1];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.menuView updateUserObj];
}

/**
 * Check for app update
 */
-(void)checkForUpdate {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType remoteNotificationTypes = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:remoteNotificationTypes];
    }
}

#pragma mark - subviews delegate
/**
 * HomePageView delegate
 * Handle the action when the hamburger icon got click
 */
-(void)homePageHamburgerIconClick {
    [[Mixpanel sharedInstance] track:@"Menu Click"];
    [self.menuView showMenuView];
    [self.searchTableView resignTextFieldFirstResponder];
}

/**
 * SearchTableView delegate
 * Handle the action when user tapped on the search result.
 * @param PFGeoPoint
 */
-(void)searchLocation:(PFGeoPoint *)location andAddress:(NSString *)address {
    PlaceSearchResultsViewController *searchResultsViewController = [[PlaceSearchResultsViewController alloc] init];
    searchResultsViewController.searchedAddress = address;
    searchResultsViewController.searchedLocation = location;
    [self.navigationController pushViewController:searchResultsViewController animated:YES];
}

/**
 * HomePageView delegate
 * Handle the action when the homepage's header view got tapped
 */
-(void)homePageHeaderViewClick {
    [[Mixpanel sharedInstance] track:@"Home - Hero Click"];
    BrowsePropertyViewController *browsePropertyViewController = [[BrowsePropertyViewController alloc] init];
    browsePropertyViewController.capturedBackground = [Device captureDeviceImage:self.view];
    [self.navigationController pushViewController:browsePropertyViewController animated:NO];
}

/**
 * HomePageView delegate
 * Handle the action when the user tap on any of the homepage's table view cell
 */
-(void)homePageItemClickAtIndex:(NSIndexPath *)indexPath {
    BrowsePropertyViewController *browsePropertyViewController = [[BrowsePropertyViewController alloc] init];
    browsePropertyViewController.capturedBackground = [Device captureDeviceImage:self.view];
    if (indexPath.row == 0) browsePropertyViewController.deckName = @"San Francisco";
    if (indexPath.row == 1) browsePropertyViewController.deckName = @"New York";
    if (indexPath.row == 2) browsePropertyViewController.deckName = @"Miami";
    
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"Home - %@ Click", browsePropertyViewController.deckName]];
    
    [self.navigationController pushViewController:browsePropertyViewController animated:NO];
}

/**
 * MenuView delegate
 * Handle the action when user click on the profile
 */
-(void)menuUserProfileClick {
    MyProfileTableViewController *myProfileTableViewController = [[MyProfileTableViewController alloc] init];
    [self.navigationController pushViewController:myProfileTableViewController animated:YES];
}

/**
 * MenuView delegate
 * Handle the action when user click on any of the view items in menu
 */
-(void)menuItemClickAtIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == MENU_ITEM_FAVORITE_INDEX) {
        MyFavoriteViewController *myFavoriteViewController = [[MyFavoriteViewController alloc] init];
        [self.navigationController pushViewController:myFavoriteViewController animated:YES];
    } else if (indexPath.row == MENU_ITEM_INBOX_INDEX) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.numNotif > 0) appDelegate.numNotif = 0;
            
        MyMessageViewController *myMessageViewController = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:myMessageViewController animated:YES];
        
        [self.homePageView reloadHamburger];
        [self.menuView updateMenu];
    } else if (indexPath.row == MENU_ITEM_YOUR_PLACE_INDEX) {
        [[UserManager sharedUserManager] getPropertiesWithCompletionHandler:^(NSArray *properties) {
            if (properties.count > 0) {
                MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
                myPlaceListViewController.userObj = self.userObj;
                [self.navigationController pushViewController:myPlaceListViewController animated:YES];
            } else {
                PFObject *amenity = [Amenity newAmenityObj];
                [amenity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    PFObject *newProperty = [PFObject objectWithClassName:@"Property"];
                    newProperty[@"owner"] = self.userObj;
                    newProperty[@"state"] = PROPERTY_APPROVAL_STATE_PRIVATE;
                    newProperty[@"amenity"] = amenity;
                    
                    MyPlaceDetailViewController *detailViewController = [[MyPlaceDetailViewController alloc] init];
                    detailViewController.propertyObj = newProperty;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                    Mixpanel *mixpanel = [Mixpanel sharedInstance];
                    [mixpanel track:@"Create New Place Click"];
                }];

            }
        }];
    } else if (indexPath.row == MENU_ITEM_UPCOMING_TRIPS_INDEX) {
        MyUpcomingTripViewController *myUpcomingTripViewController = [[MyUpcomingTripViewController alloc] init];
        [self.navigationController pushViewController:myUpcomingTripViewController animated:YES];
    } else if (indexPath.row == MENU_ITEM_HOW_IT_WORKS_INDEX) {
        FAQViewController *faqViewController = [[FAQViewController alloc] init];
        [self.navigationController pushViewController:faqViewController animated:YES];
    } else if (indexPath.row == MENU_ITEM_APP_FEEDBACK_INDEX) {
        AppFeedbackViewController *appFeedbackViewController = [[AppFeedbackViewController alloc] init];
        appFeedbackViewController.userObj = self.userObj;
        [self.navigationController pushViewController:appFeedbackViewController animated:YES];
    }
}


@end
