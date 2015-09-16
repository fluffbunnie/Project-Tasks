//
//  HowItWorkViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 6/1/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorkViewController.h"
#import "CrossCloseButton.h"
#import "Device.h"
#import "Mixpanel.h"

static NSString * IPHONE4_HOW_IT_WORK_FIRST_SCREEN = @"HowItWorkIphone4FirstScreen";
static NSString * IPHONE4_HOW_IT_WORK_SECOND_SCREEN = @"HowItWorkIphone4SecondScreen";
static NSString * IPHONE4_HOW_IT_WORK_THIRD_SCREEN = @"HowItWorkIphone4ThirdScreen";
static NSString * IPHONE4_HOW_IT_WORK_FOURTH_SCREEN = @"HowItWorkIphone4FourthScreen";
static NSString * IPHONE4_HOW_IT_WORK_FIFTH_SCREEN = @"HowItWorkIphone4FifthScreen";

static NSString * IPHONE5_HOW_IT_WORK_FIRST_SCREEN = @"HowItWorkIphone5FirstScreen";
static NSString * IPHONE5_HOW_IT_WORK_SECOND_SCREEN = @"HowItWorkIphone5SecondScreen";
static NSString * IPHONE5_HOW_IT_WORK_THIRD_SCREEN = @"HowItWorkIphone5ThirdScreen";
static NSString * IPHONE5_HOW_IT_WORK_FOURTH_SCREEN = @"HowItWorkIphone5FourthScreen";
static NSString * IPHONE5_HOW_IT_WORK_FIFTH_SCREEN = @"HowItWorkIphone5FifthScreen";

static NSString * IPHONE6_HOW_IT_WORK_FIRST_SCREEN = @"HowItWorkIphone6FirstScreen";
static NSString * IPHONE6_HOW_IT_WORK_SECOND_SCREEN = @"HowItWorkIphone6SecondScreen";
static NSString * IPHONE6_HOW_IT_WORK_THIRD_SCREEN = @"HowItWorkIphone6ThirdScreen";
static NSString * IPHONE6_HOW_IT_WORK_FOURTH_SCREEN = @"HowItWorkIphone6FourthScreen";
static NSString * IPHONE6_HOW_IT_WORK_FIFTH_SCREEN = @"HowItWorkIphone6FifthScreen";

static NSString * IPHONE6_PLUS_HOW_IT_WORK_FIRST_SCREEN = @"HowItWorkIphone6PlusFirstScreen";
static NSString * IPHONE6_PLUS_HOW_IT_WORK_SECOND_SCREEN = @"HowItWorkIphone6PlusSecondScreen";
static NSString * IPHONE6_PLUS_HOW_IT_WORK_THIRD_SCREEN = @"HowItWorkIphone6PlusThirdScreen";
static NSString * IPHONE6_PLUS_HOW_IT_WORK_FOURTH_SCREEN = @"HowItWorkIphone6PlusFourthScreen";
static NSString * IPHONE6_PLUS_HOW_IT_WORK_FIFTH_SCREEN = @"HowItWorkIphone6PlusFifthScreen";


static NSString * PAGE_INDICATOR_HOW_IT_WORK_FIRST_PAGE = @"PageIndicatorHowItWorkFirstPage";
static NSString * PAGE_INDICATOR_HOW_IT_WORK_SECOND_PAGE = @"PageIndicatorHowItWorkSecondPage";
static NSString * PAGE_INDICATOR_HOW_IT_WORK_THIRD_PAGE = @"PageIndicatorHowItWorkThirdPage";
static NSString * PAGE_INDICATOR_HOW_IT_WORK_FOURTH_PAGE = @"PageIndicatorHowItWorkFourthPage";
static NSString * PAGE_INDICATOR_HOW_IT_WORK_FIFTH_PAGE = @"PageIndicatorHowItWorkFifthPage";

@interface HowItWorkViewController ()
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *capturedBackgroundImage;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *firstHowItWorkPage;
@property (nonatomic, strong) UIImageView *secondHowItWorkPage;
@property (nonatomic, strong) UIImageView *thirdHowItWorkPage;
@property (nonatomic, strong) UIImageView *fourthHowItWorkPage;
@property (nonatomic, strong) UIImageView *fifthHowItWorkPage;

@property (nonatomic, strong) UIImageView *pageIndicator;
@property (nonatomic, strong) CrossCloseButton *closeButton;
@end

@implementation HowItWorkViewController
#pragma mark - initiation
/**
 * Lazily init the capture background image
 * @return UIImageView
 */
-(UIImageView *)capturedBackgroundImage {
    if (_capturedBackgroundImage == nil) {
        _capturedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackgroundImage.image = self.capturedBackground;
    }
    return _capturedBackgroundImage;
}

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
        _contentScrollView.contentSize = CGSizeMake(5 * screenWidth, screenHeight);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

/**
 * Lazily init the first tutorial page
 * @return UIImageView
 */
-(UIImageView *)firstHowItWorkPage {
    if (_firstHowItWorkPage == nil) {
        _firstHowItWorkPage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _firstHowItWorkPage.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([Device isIphone4]) _firstHowItWorkPage.image = [UIImage imageNamed:IPHONE4_HOW_IT_WORK_FIRST_SCREEN];
        else if ([Device isIphone5]) _firstHowItWorkPage.image = [UIImage imageNamed:IPHONE5_HOW_IT_WORK_FIRST_SCREEN];
        else if ([Device isIphone6]) _firstHowItWorkPage.image = [UIImage imageNamed:IPHONE6_HOW_IT_WORK_FIRST_SCREEN];
        else _firstHowItWorkPage.image = [UIImage imageNamed:IPHONE6_PLUS_HOW_IT_WORK_FIRST_SCREEN];
    }
    return _firstHowItWorkPage;
}

/**
 * Lazily init the second tutorial page
 * @return UIImageView
 */
-(UIImageView *)secondHowItWorkPage {
    if (_secondHowItWorkPage == nil) {
        _secondHowItWorkPage = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenWidth, 0, self.screenWidth, self.screenHeight)];
        _secondHowItWorkPage.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([Device isIphone4]) _secondHowItWorkPage.image = [UIImage imageNamed:IPHONE4_HOW_IT_WORK_SECOND_SCREEN];
        else if ([Device isIphone5]) _secondHowItWorkPage.image = [UIImage imageNamed:IPHONE5_HOW_IT_WORK_SECOND_SCREEN];
        else if ([Device isIphone6]) _secondHowItWorkPage.image = [UIImage imageNamed:IPHONE6_HOW_IT_WORK_SECOND_SCREEN];
        else _secondHowItWorkPage.image = [UIImage imageNamed:IPHONE6_PLUS_HOW_IT_WORK_SECOND_SCREEN];
    }
    return _secondHowItWorkPage;
}

/**
 * Lazily init the third tutorial page
 * @return UIImageView
 */
-(UIImageView *)thirdHowItWorkPage {
    if (_thirdHowItWorkPage == nil) {
        _thirdHowItWorkPage = [[UIImageView alloc] initWithFrame:CGRectMake(2 * self.screenWidth, 0, self.screenWidth, self.screenHeight)];
        _thirdHowItWorkPage.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([Device isIphone4]) _thirdHowItWorkPage.image = [UIImage imageNamed:IPHONE4_HOW_IT_WORK_THIRD_SCREEN];
        else if ([Device isIphone5]) _thirdHowItWorkPage.image = [UIImage imageNamed:IPHONE5_HOW_IT_WORK_THIRD_SCREEN];
        else if ([Device isIphone6]) _thirdHowItWorkPage.image = [UIImage imageNamed:IPHONE6_HOW_IT_WORK_THIRD_SCREEN];
        else _thirdHowItWorkPage.image = [UIImage imageNamed:IPHONE6_PLUS_HOW_IT_WORK_THIRD_SCREEN];
    }
    return _thirdHowItWorkPage;
}

/**
 * Lazily init the fourth tutorial page
 * @return UIImageView
 */
-(UIImageView *)fourthHowItWorkPage {
    if (_fourthHowItWorkPage == nil) {
        _fourthHowItWorkPage = [[UIImageView alloc] initWithFrame:CGRectMake(3 * self.screenWidth, 0, self.screenWidth, self.screenHeight)];
        _fourthHowItWorkPage.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([Device isIphone4]) _fourthHowItWorkPage.image = [UIImage imageNamed:IPHONE4_HOW_IT_WORK_FOURTH_SCREEN];
        else if ([Device isIphone5]) _fourthHowItWorkPage.image = [UIImage imageNamed:IPHONE5_HOW_IT_WORK_FOURTH_SCREEN];
        else if ([Device isIphone6]) _fourthHowItWorkPage.image = [UIImage imageNamed:IPHONE6_HOW_IT_WORK_FOURTH_SCREEN];
        else _fourthHowItWorkPage.image = [UIImage imageNamed:IPHONE6_PLUS_HOW_IT_WORK_FOURTH_SCREEN];
    }
    return _fourthHowItWorkPage;
}

/**
 * Lazily init the fifth tutorial page
 * @return UIImageView
 */
-(UIImageView *)fifHowItWorkPage {
    if (_fifthHowItWorkPage == nil) {
        _fifthHowItWorkPage = [[UIImageView alloc] initWithFrame:CGRectMake(4 * self.screenWidth, 0, self.screenWidth, self.screenHeight)];
        _fifthHowItWorkPage.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([Device isIphone4]) _fifthHowItWorkPage.image = [UIImage imageNamed:IPHONE4_HOW_IT_WORK_FIFTH_SCREEN];
        else if ([Device isIphone5]) _fifthHowItWorkPage.image = [UIImage imageNamed:IPHONE5_HOW_IT_WORK_FIFTH_SCREEN];
        else if ([Device isIphone6]) _fifthHowItWorkPage.image = [UIImage imageNamed:IPHONE6_HOW_IT_WORK_FIFTH_SCREEN];
        else _fifthHowItWorkPage.image = [UIImage imageNamed:IPHONE6_PLUS_HOW_IT_WORK_FIFTH_SCREEN];
    }
    return _fifthHowItWorkPage;
}

/**
 * Lazily init the page indicator
 * @return page indicator
 */
-(UIImageView *)pageIndicator {
    if (_pageIndicator == nil) {
        _pageIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 176, self.screenWidth, 6)];
        _pageIndicator.contentMode = UIViewContentModeScaleAspectFit;
        _pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_FIRST_PAGE];
    }
    return _pageIndicator;
}

/**
 * Lazily init the cross closing button
 * @return CrossCloseButton
 */
-(CrossCloseButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[CrossCloseButton alloc] initWithFrame:CGRectMake(self.screenWidth - 40, 0, 40, 64)];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self capturedBackgroundImage]];
    [self.view addSubview:[self contentScrollView]];
    [self.contentScrollView addSubview:[self firstHowItWorkPage]];
    [self.contentScrollView addSubview:[self secondHowItWorkPage]];
    [self.contentScrollView addSubview:[self thirdHowItWorkPage]];
    [self.contentScrollView addSubview:[self fourthHowItWorkPage]];
    [self.contentScrollView addSubview:[self fifHowItWorkPage]];
    [self.view addSubview:[self pageIndicator]];
    [self.view addSubview:[self closeButton]];
    
    self.contentScrollView.alpha = 0;
    self.pageIndicator.alpha = 0;
    self.closeButton.alpha = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    
    NSDate *time = [[NSDate alloc] init];
    self.startTime = [time timeIntervalSince1970];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.alpha = 1;
        self.pageIndicator.alpha = 1;
        self.closeButton.alpha = 1;
    }];
}

#pragma mark - scroll view delegate
/**
 * Handle the behavior when user clicked on the close button
 */
-(void)closeButtonClick {
    NSDate *time = [[NSDate alloc] init];
    NSTimeInterval endTime = [time timeIntervalSince1970];
    NSTimeInterval timeInTutorial = endTime - self.startTime;
    [[Mixpanel sharedInstance] track:@"How It Works Time" properties:@{@"duration":[NSString stringWithFormat:@"%.0f", timeInTutorial]}];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.alpha = 0;
        self.pageIndicator.alpha = 0;
        self.closeButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = MAX(0, MIN(5, (int)scrollView.contentOffset.x/self.screenWidth));
    switch (page) {
        case 0:
            self.pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_FIRST_PAGE];
            break;
            
        case 1:
            self.pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_SECOND_PAGE];
            break;
            
        case 2:
            self.pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_THIRD_PAGE];
            break;
            
        case 3:
            self.pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_FOURTH_PAGE];
            break;
            
        case 4:
            self.pageIndicator.image = [UIImage imageNamed:PAGE_INDICATOR_HOW_IT_WORK_FIFTH_PAGE];
            break;
            
        default:
            break;
    }
}
@end
