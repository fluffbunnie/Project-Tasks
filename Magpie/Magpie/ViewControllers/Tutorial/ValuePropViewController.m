//
//  ValuePropViewController
//  Magpie
//
//  Created by minh thao nguyen on 5/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ValuePropViewController.h"
#import "Device.h"
#import "FontColor.h"
#import "HomePageViewController.h"
#import "Mixpanel.h"
#import "LoginViewController.h"
#import "SignUpWithInvitationViewController.h"
#import "ValuePropFirstView.h"
#import "ValuePropSecondView.h"
#import "ValuePropThirdView.h"
#import "ValuePropFourthView.h"
#import "SignupRequestInvitationCodeViewController.h"
#import "ImportAirbnbViewController.h"
#import "AppDelegate.h"
#import "InvitationStatusRequestCodeSentViewController.h"

static NSString * const LOGIN_TEXT = @"Have an account? Log In";

@interface ValuePropViewController ()
@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) ValuePropFirstView *firstValueProp;
@property (nonatomic, strong) ValuePropSecondView *secondValueProp;
@property (nonatomic, strong) ValuePropThirdView *thirdValueProp;
@property (nonatomic, strong) ValuePropFourthView *fourthValueProp;
@property (nonatomic, strong) ValuePropInvitationOverlayView *invitationOverlayView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) TTTAttributedLabel *loginLabel;
@property (nonatomic, strong) UIButton *signupButton;

//@property (nonatomic, strong)
@end

@implementation ValuePropViewController
#pragma mark - initiation
/**
 * Lazily instantiate the content scroll view
 * @return scroll view
 */
-(UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _contentScrollView.backgroundColor = [UIColor blackColor];
        _contentScrollView.contentSize = CGSizeMake(4 * screenWidth, screenHeight);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

/**
 * Lazily init the first value prop
 * @return ValuePropFirstView
 */
-(ValuePropFirstView *)firstValueProp {
    if (_firstValueProp == nil) _firstValueProp = [[ValuePropFirstView alloc] init];
    return _firstValueProp;
}

/**
 * Lazily init the second value prop
 * @return ValuePropSecondView
 */
-(ValuePropSecondView *)secondValueProp {
    if (_secondValueProp == nil) _secondValueProp = [[ValuePropSecondView alloc] init];
    return _secondValueProp;
}

/**
 * Lazily init the third value prop
 * @return ValuePropThirdView
 */
-(ValuePropThirdView *)thirdValueProp {
    if (_thirdValueProp == nil) _thirdValueProp = [[ValuePropThirdView alloc] init];
    return _thirdValueProp;
}

/**
 * Lazily init the fourth value prop
 * @return ValuePropFourthView
 */
-(ValuePropFourthView *)fourthValueProp {
    if (_fourthValueProp == nil) _fourthValueProp = [[ValuePropFourthView alloc] init];
    return _fourthValueProp;
}

/**
 * Lazily init the overlay view
 * @return ValuePropInvitationOverLayView
 */
-(ValuePropInvitationOverlayView *)invitationOverlayView {
    if (_invitationOverlayView == nil) {
        _invitationOverlayView = [[ValuePropInvitationOverlayView alloc] init];
        _invitationOverlayView.delegate = self;
    }
    return _invitationOverlayView;
}

/**
 * Lazily init the page control
 * @return UIPageControl
 */
-(UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.screenWidth - 60)/2, self.screenHeight/2 + 130, 60, 8)];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

/**
 * Lazily init the login label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)loginLabel {
    if (_loginLabel == nil) {
        _loginLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.screenHeight - 90, self.screenWidth, 20)];
        _loginLabel.textAlignment = NSTextAlignmentCenter;
        _loginLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _loginLabel.textColor = [UIColor whiteColor];
        _loginLabel.text = LOGIN_TEXT;
        _loginLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor whiteColor],
                            (id)kCTFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13]};
        NSRange loginRange = [LOGIN_TEXT rangeOfString:@"Log In"];
        [_loginLabel addLinkToURL:[NSURL URLWithString:@"action://login"] withRange:loginRange];
        _loginLabel.delegate = self;
    }
    return _loginLabel;
}

/**
 * Lazily init the signup button
 * @return UIButton
 */
-(UIButton *)signupButton {
    if (_signupButton == nil) {
        _signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.screenHeight - 50, self.screenWidth, 50)];
        _signupButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signupButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_signupButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_signupButton addTarget:self action:@selector(signupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.currentPage = 0;
    
    [self.view addSubview:[self contentScrollView]];
    [self.contentScrollView addSubview:[self firstValueProp]];
    [self.contentScrollView addSubview:[self secondValueProp]];
    [self.contentScrollView addSubview:[self thirdValueProp]];
    [self.contentScrollView addSubview:[self fourthValueProp]];
    [self.view addSubview:[self pageControl]];
//    [self.view addSubview:[self loginLabel]];
//    [self.view addSubview:[self signupButton]];
//    [self.view addSubview:[self invitationOverlayView]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    
    NSDate *time  = [[NSDate alloc] init];
    self.startTime = [time timeIntervalSince1970];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimationAtPage:self.currentPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - button delegate
/**
 * TTTAttributesLabel delegate
 * Handle the behavior when user click on the login label
 */
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSDate *time = [[NSDate alloc] init];
    NSTimeInterval endTime = [time timeIntervalSince1970];
    NSTimeInterval timeInTutorial = endTime - self.startTime;
    [[Mixpanel sharedInstance] track:@"Tutorial Time" properties:@{@"duration":[NSString stringWithFormat:@"%.0f", timeInTutorial]}];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

/**
 * Handle the behavior when the signup button is click
 */
-(void)signupButtonClick {
    NSDate *time = [[NSDate alloc] init];
    NSTimeInterval endTime = [time timeIntervalSince1970];
    NSTimeInterval timeInTutorial = endTime - self.startTime;
    [[Mixpanel sharedInstance] track:@"Tutorial Time" properties:@{@"duration":[NSString stringWithFormat:@"%.0f", timeInTutorial]}];
    
    [self.invitationOverlayView showInParent];
}

/**
 * ValuePropInvitationOverlayView delegate
 * Go to request invitation code screen
 */
-(void)goToRequestCode {
    SignupRequestInvitationCodeViewController *signupRequestInvitationCodeViewController = [[SignupRequestInvitationCodeViewController alloc] init];
    [self.navigationController pushViewController:signupRequestInvitationCodeViewController animated:YES];
}

/**
 * ValuePropInvitationOverlayView delegate
 * Go to the sign up code screen
 */
-(void)goToSignup {
    SignUpWithInvitationViewController * signupWithInvitationViewController = [[SignUpWithInvitationViewController alloc] init];
    [self.navigationController pushViewController:signupWithInvitationViewController animated:YES];
}

/**
 * Private class to register for push notification
 */
-(void)requestRemoteNotificationPermission {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType remoteNotificationTypes = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:remoteNotificationTypes];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = [self getCurrentPage];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int newPage = [self getCurrentPage];
    if (newPage != self.currentPage) {
        self.pageControl.currentPage = newPage;
        [self stopAnimationAtPage:self.currentPage];
        [self startAnimationAtPage:newPage];
        self.currentPage = newPage;
    }
}

#pragma mark - helper method
/**
 * Get the current page in the scroll view
 * @return int
 */
-(int)getCurrentPage {
    int page = (int)floor((self.contentScrollView.contentOffset.x * 2.0f + self.screenWidth) / (self.screenWidth * 2.0f));
    page = MAX(0, MIN(3, page));
    return page;
}

/**
 * Stop animation at a given page
 * @param int
 */
-(void)stopAnimationAtPage:(int)page {
    if (page == 0) [self.firstValueProp hideView];
    if (page == 1) [self.secondValueProp hideView];
    if (page == 2) [self.thirdValueProp hideView];
    if (page == 3) [self.fourthValueProp hideView];
}

/**
 * Start animationa at a given page
 * @param int
 */
-(void)startAnimationAtPage:(int)page {
    if (page == 0) [self.firstValueProp showView];
    if (page == 1) [self.secondValueProp showView];
    if (page == 2) [self.thirdValueProp showView];
    if (page == 3) [self.fourthValueProp showView];
}

/**
 * Handle the method when app enter the foreground
 */
-(void)viewEnterForeground {
//    NSString *codeId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_REQUEST_CODE_ID];
//    if (codeId != nil) {
//        PFQuery *query = [PFQuery queryWithClassName:@"InvitationCode"];
//        [query whereKey:@"objectId" equalTo:codeId];
//        [query whereKey:@"state" equalTo:@"APPROVED"];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (objects.count > 0) {
//                PFObject *invitationCodeObj = objects[0];
//                
//                InvitationStatusRequestCodeSentViewController *requestCodeSentViewController = [[InvitationStatusRequestCodeSentViewController alloc] init];
//                requestCodeSentViewController.invitationCodeObj = invitationCodeObj;
//                [self.navigationController pushViewController:requestCodeSentViewController animated:YES];
//            }
//        }];
//    }
}


@end
