//
//  GuidedCommunicationTripDetailViewController.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedCommunicationTripDetailViewController.h"

const NSInteger GUEST_TYPE_UNDEFINE = -1;
const NSInteger GUEST_TYPE_GUEST = 0;
const NSInteger GUEST_TYPE_ONLY_HOST = 1;

static NSString * VIEW_TITLE = @"Trip Detail";

@interface GuidedCommunicationTripDetailViewController()

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *submitButton;
@property (nonatomic, strong) GuidedCommunicationTabBar *tabBar;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) GuidedCommunicationGuestTypeView *guestTypeView;

@end

@implementation GuidedCommunicationTripDetailViewController

#pragma mark - instantiation
/**
 * Lazily init the navigation bar
 * @return navigation bar
 */
-(UINavigationBar *)navigationBar {
    if (_navigationBar == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self.navigationItem.title = VIEW_TITLE;
        self.navigationItem.leftBarButtonItem = [self backButton];
        self.navigationItem.rightBarButtonItem = [self submitButton];
        
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    }
    return _navigationBar;
}

/**
 * Lazily init the left bar button item
 * @return back button
 */
-(UIBarButtonItem *)backButton {
    if (_backButton ==  nil) _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BarBackIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(barBackClicked)];
    return _backButton;
}

/**
 * Lazily init the submit bar button item
 * @return submit button
 */
-(UIBarButtonItem *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClick)];
    }
    return _submitButton;
}

/**
 * Lazily init the guided communication tabbar
 * @return tab bar
 */
-(GuidedCommunicationTabBar *)tabBar {
    if (_tabBar == nil) {
        _tabBar = [[GuidedCommunicationTabBar alloc] init];
        _tabBar.tabBarDelegate = self;
    }
    return _tabBar;
}

/**
 * Lazily init the content scroll view
 * @return UIScrollView
 */
-(UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float screenHeight = [[UIScreen mainScreen] bounds].size.height;
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
        _contentScrollView.contentSize = CGSizeMake(3 * screenWidth, screenHeight - 64);
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

/**
 * Lazily init the guest type view
 * @return Guest type
 */
-(GuidedCommunicationGuestTypeView *)guestTypeView {
    if (_guestTypeView == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float screenHeight = [[UIScreen mainScreen] bounds].size.height;

        _guestTypeView = [[GuidedCommunicationGuestTypeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
        _guestTypeView.guestTypeDelegate = self;
    }
    return _guestTypeView;
}

#pragma mark - view delegate
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self navigationBar]];
    [self.view addSubview:[self contentScrollView]];
    [self.contentScrollView addSubview:[self guestTypeView]];
    
    [self.view addSubview:[self tabBar]];
    
    //if (self.guestType == GUEST_TYPE_UNDEFINE) [self.tabBar hideViewAnimated:NO];
}

/**
 * Delegate for the content scroll view
 * When the view end scrolling, we set the tabbar button to correctly 
 * reflect the result
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger currentPage = scrollView.contentOffset.x/screenWidth;
    if (currentPage == 0) [self.tabBar highlightGuestTypeButton];
    else if (currentPage == 1) [self.tabBar highlightNumGuestsButton];
    else if (currentPage == 2) [self.tabBar highlightDatePickerButton];
    
}

#pragma mark - tabbar & Bar button click action
/**
 * Handle the back button clicked
 */
- (void)barBackClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        //TODO, update the previous view controller the updated detail
    }];
}

/**
 * Handle the submit button clicked
 */
-(void)submitButtonClick {
    [self barBackClicked];
    //TODO, to send the request to the host
}

/**
 * TabbarButton delegate
 * Show the guest type view
 */
-(void)showGuestTypeView {
    [self.contentScrollView setContentOffset:CGPointZero animated:YES];
}

/**
 * TabbarButton delegate
 * Show the num guests view
 */
-(void)showNumGuestsView {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [self.contentScrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
}

/**
 * TabbarButton delegate
 * Show the date picker view
 */
-(void)showDatePickerView {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [self.contentScrollView setContentOffset:CGPointMake(2 * screenWidth, 0) animated:YES];
}

#pragma mark - other subview delegate
/**
 * GuestType delegate
 * when user click on one of the radio button
 * @param guest type
 */
-(void)onGuestTypeSelection:(NSInteger)guestType {
    self.guestType = guestType;
    if (guestType == GUEST_TYPE_GUEST) {
        [self.tabBar showViewAnimated:YES];
        if (self.numGuests.length > 0 && self.startDate != nil && self.endDate != nil)
            self.submitButton.enabled = YES;
    } else {
        [self.tabBar hideViewAnimated:YES];
        self.submitButton.enabled = YES;
    }
}

@end
