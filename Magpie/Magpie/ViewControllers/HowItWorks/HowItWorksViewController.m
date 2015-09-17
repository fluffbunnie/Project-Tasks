//
//  ValuePropViewController
//  Magpie
//
//  Created by minh thao nguyen on 5/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksViewController.h"
#import "Device.h"
#import "FontColor.h"
#import "HomePageViewController.h"
#import "Mixpanel.h"
#import "LoginViewController.h"
#import "HowItWorksFirstView.h"
#import "HowItWorksSecondView.h"
#import "HowItWorksThirdView.h"
#import "AppDelegate.h"
#import "SignupRequestInvitationCodeViewController.h"
#import "SignUpWithInvitationViewController.h"

static NSString * const REPEAT_BUTTON_STRING = @"Repeat";

static int const TOTAL_NUMBER_PAGES = 3;

@interface HowItWorksViewController ()
@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) HowItWorksFirstView *firstValueProp;
@property (nonatomic, strong) HowItWorksSecondView *secondValueProp;
@property (nonatomic, strong) HowItWorksThirdView *thirdValueProp;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) TTTAttributedLabel *loginLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *repeatButton;

//@property (nonatomic, strong)
@end

@implementation HowItWorksViewController
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
        _contentScrollView.contentSize = CGSizeMake(TOTAL_NUMBER_PAGES * screenWidth, screenHeight);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollEnabled = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

/**
 * Lazily init the first value prop
 * @return ValuePropFirstView
 */
-(HowItWorksFirstView *)firstValueProp {
    if (_firstValueProp == nil) _firstValueProp = [[HowItWorksFirstView alloc] init];
    _firstValueProp.howItWorksViewDelegate = self;
    return _firstValueProp;
}

/**
 * Lazily init the second value prop
 * @return ValuePropSecondView
 */
-(HowItWorksSecondView *)secondValueProp {
    if (_secondValueProp == nil) _secondValueProp = [[HowItWorksSecondView alloc] init];
    _secondValueProp.howItWorksViewDelegate = self;
    return _secondValueProp;
}

/**
 * Lazily init the third value prop
 * @return ValuePropThirdView
 */
-(HowItWorksThirdView *)thirdValueProp {
    if (_thirdValueProp == nil) _thirdValueProp = [[HowItWorksThirdView alloc] init];
    _thirdValueProp.howItWorksViewDelegate = self;
    return _thirdValueProp;
}

/**
 * Lazily init the page control
 * @return UIPageControl
 */
-(UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.screenWidth - 60)/2, self.screenHeight*0.9, 60, 8)];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = TOTAL_NUMBER_PAGES;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

/**
 * Lazily init the signup button
 * @return UIButton
 */
-(UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth *0.92, 5, 24, 24)];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_cancel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

/**
 * Lazily init the signup button
 * @return UIButton
 */
-(UIButton *)repeatButton {
    if (_repeatButton == nil) {
        _repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth *0.02, 0, 60, 40)];
        _repeatButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
        [_repeatButton setTitle:@"Repeat" forState:UIControlStateNormal];
        _repeatButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _repeatButton.backgroundColor =[UIColor clearColor];
        [_repeatButton setTitleColor:[UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        [_repeatButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_repeatButton addTarget:self action:@selector(repeatButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _repeatButton.alpha = 0;
    }
    return _repeatButton;
}

#pragma mark - public methods
/**
 * Lazily init the ViewController
 * @return UIButton
 */

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
//    [self.view addSubview:[self pageControl]];
//    [self.view addSubview:[self repeatButton]];
    [self.view addSubview:[self cancelButton]];
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
    [self stopAnimationAtPage:self.currentPage];
    [self startAnimationAtPage:self.currentPage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
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
 * Handle the behavior when the cancel button is click
 */
-(void)cancelButtonClick {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

/**
 * Handle the behavior when the repeat animation button is click
 */
-(void)repeatButtonClick {
    [self repeatSlideshow];
}

/**
 * SignupView delegate
 * Go to the sign up code screen
 */
-(void)goToSignup {
    SignUpWithInvitationViewController * signupWithInvitationViewController = [[SignUpWithInvitationViewController alloc] init];
    [self.navigationController pushViewController:signupWithInvitationViewController animated:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.pageControl.currentPage = [self getCurrentPage];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    int newPage = [self getCurrentPage];
//    if (newPage != self.currentPage) {
//        self.pageControl.currentPage = newPage;
//        [self stopAnimationAtPage:self.currentPage];
//        [self startAnimationAtPage:newPage];
//        self.currentPage = newPage;
//    }
}

#pragma mark - helper method
/**
 * Get the current page in the scroll view
 * @return int
 */
-(int)getCurrentPage {
    int page = (int)floor((self.contentScrollView.contentOffset.x * 2.0f + self.screenWidth) / (self.screenWidth * 2.0f));
    page = MAX(0, MIN(TOTAL_NUMBER_PAGES, page));
    return page;
}

/**
 * Stop animation at a given page
 * @param int
 */
-(void)stopAnimationAtPage:(int)page {
    if (page == 0) [self.firstValueProp hideView];
    if (page == 1) [self.secondValueProp hideView];
    if (page == 2) {
        [self.thirdValueProp hideView];
        _repeatButton.alpha = 0;
    }
}

/**
 * Start animationa at a given page
 * @param int
 */
-(void)startAnimationAtPage:(int)page {
    if (page == 0) [self.firstValueProp showView];
    if (page == 1) [self.secondValueProp showView];
    if (page == 2) [self.thirdValueProp showView];
}

#pragma GotoNextPage and Repeat Slideshow Delegate

/**
 * Goto the next page
 */

-(void) gotoNextPage {
    int newPage = [self getCurrentPage] + 1 ;
    if (newPage > TOTAL_NUMBER_PAGES-1 || newPage < 0) newPage = 0;
    if (newPage != self.currentPage && newPage != 0) {
        CGRect frame = _contentScrollView.frame;
        frame.origin.x = frame.size.width * newPage;
        frame.origin.y = 0;
        [_contentScrollView scrollRectToVisible:frame animated:YES];
        self.pageControl.currentPage = newPage;
        [self stopAnimationAtPage:self.currentPage];
        [self startAnimationAtPage:newPage];
        self.currentPage = newPage;
    }
}

/**
 * Repeat Slideshow
 */

-(void) repeatSlideshow {
    int newPage = 0;
    CGRect frame = _contentScrollView.frame;
    frame.origin.x = frame.size.width * newPage;
    frame.origin.y = 0;
     [_contentScrollView scrollRectToVisible:frame animated:YES];
    self.pageControl.currentPage = newPage;
    [self stopAnimationAtPage:self.currentPage];
    [self startAnimationAtPage:newPage];
    self.currentPage = newPage;
    _repeatButton.alpha = 0;
}

-(void) showRepeatButton {
    _repeatButton.alpha = 1;
}

#pragma appwillbecomeActive or AppDidEnterBackground

-(void) applicationDidEnterBackground{
    [self stopAnimationAtPage:self.currentPage];
}
-(void) applicationWillEnterForeground {
    [self startAnimationAtPage:self.currentPage];
}

@end
