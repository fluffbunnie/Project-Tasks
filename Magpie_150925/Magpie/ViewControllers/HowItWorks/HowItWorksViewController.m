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
#import "HowItWorksFourthView.h"
#import "HowItWorksFifthView.h"
#import "HowItWorksSixthView.h"
#import "HowItWorksSeventhView.h"
#import "HowItWorksEighthView.h"
#import "HowItWorksNinethView.h"
#import "HowItWorksTenthView.h"

#import "AppDelegate.h"
#import "SignupRequestInvitationCodeViewController.h"
#import "SignUpWithInvitationViewController.h"

static int const TOTAL_NUMBER_PAGES = 10;

static NSString * VALUE_BACKGROUND_SCREEN_1 = @"Background_Screen_1";
static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";
static NSString * VALUE_BACKGROUND_SCREEN_3 = @"Background_Screen_3";
static NSString * VALUE_BACKGROUND_SCREEN_4 = @"Background_Screen_4";


@interface HowItWorksViewController ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) AnimationStausType animationStatus;

@property (nonatomic, strong) UIImageView *capturedBackgroundImageView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) HowItWorksFirstView *firstValueHowItWorks;
@property (nonatomic, strong) HowItWorksSecondView *secondValueHowItWorks;
@property (nonatomic, strong) HowItWorksThirdView *thirdValueHowItWorks;
@property (nonatomic, strong) HowItWorksFourthView *fourthValueHowItWorks;
@property (nonatomic, strong) HowItWorksFifthView *fifthValueHowItWorks;
@property (nonatomic, strong) HowItWorksSixthView *sixthValueHowItWorks;
@property (nonatomic, strong) HowItWorksSeventhView *seventhValueHowItWorks;
@property (nonatomic, strong) HowItWorksEighthView *eighthValueHowValueItWorks;
@property (nonatomic, strong) HowItWorksNinethView *ninethValueHowItWorks;
@property (nonatomic, strong) HowItWorksTenthView *tenthValueHowItWorks;

@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation HowItWorksViewController
#pragma mark - initiation
/**
 * Lazily init the captured background imageview
 * @return UIImageView
 */
-(UIImageView *)capturedBackgroundImageView {
    if (_capturedBackgroundImageView == nil) {
        _capturedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackgroundImageView.image = self.capturedBackground;
    }
    return _capturedBackgroundImageView;
}

-(void)initBackgroundImageView {
    if (_valueBackgroundScreen == nil) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat height = screenWidth * (1334.0/750.0);
//        CGFloat width =  667;
        CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
        if (height > screenHeight) frame = CGRectMake(0, screenHeight - height, screenWidth, height);
        NSLog(@"frame size image: %@", NSStringFromCGRect(frame));
        _valueBackgroundScreen = [[UIImageView alloc] initWithFrame:frame];
        _valueBackgroundScreen.contentMode = UIViewContentModeScaleAspectFit;// UIViewContentModeScaleAspectFill;
        _valueBackgroundScreen.backgroundColor = [UIColor whiteColor];
        _valueBackgroundScreen.clipsToBounds = YES;
//        _valueBackgroundScreen.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN_2];
    }
}

/**
 * Set BackgroundImage for scroll view
 */

-(void) setbackgroundImage:(NSString *)imageName {
//    UIImage* imageBackground = [UIImage imageNamed:imageName];
//    CGFloat scaleNumber = _screenWidth/imageBackground.size.width;
    //    imageBackground.scale =  scaleNumber;
    
    _valueBackgroundScreen.image = [UIImage imageNamed:imageName];
    [_valueBackgroundScreen sizeToFit];
    NSLog(@"size : %@ frame :%@", NSStringFromCGSize(_valueBackgroundScreen.image.size), NSStringFromCGRect(_valueBackgroundScreen.frame));
    //_screenWidth/imageBackground.size.width;
    _contentScrollView.backgroundColor = [UIColor colorWithPatternImage:_valueBackgroundScreen.image];//[UIImage imageNamed:imageName]];
    _contentScrollView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFill;UIViewContentModeScaleToFill;UIViewContentModeScaleAspectFit
    //    _valueBackgroundScreen.image = [UIImage imageNamed:imageName];
    
}

/**
 * Lazily instantiate the content scroll view
 * @return scroll view
 */
-(UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
//        CGFloat height = screenWidth * (1334.0/750.0);
//        CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
//        if (height > screenHeight) frame = CGRectMake(0, screenHeight - height, screenHeight, height);
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.contentSize = CGSizeMake(TOTAL_NUMBER_PAGES * screenWidth, screenHeight);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.userInteractionEnabled = YES;
        _contentScrollView.delegate = self;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [_contentScrollView addGestureRecognizer:singleTap];
        [self initBackgroundImageView];
    }
    return _contentScrollView;
}

/**
 * Lazily init the first value prop
 * @return ValuePropFirstView
 */
-(HowItWorksFirstView *)firstHowItWorks {
    if (_firstValueHowItWorks == nil) _firstValueHowItWorks = [[HowItWorksFirstView alloc] init];
    _firstValueHowItWorks.howItWorksViewDelegate = self;
    return _firstValueHowItWorks;
}

/**
 * Lazily init the second value prop
 * @return ValuePropSecondView
 */
-(HowItWorksSecondView *)secondHowItWorks {
    if (_secondValueHowItWorks == nil) _secondValueHowItWorks = [[HowItWorksSecondView alloc] init];
    _secondValueHowItWorks.howItWorksViewDelegate = self;
    return _secondValueHowItWorks;
}

/**
 * Lazily init the second value prop
 * @return ValuePropSecondView
 */
-(HowItWorksThirdView *)thirdHowItWorks {
    if (_thirdValueHowItWorks == nil) _thirdValueHowItWorks = [[HowItWorksThirdView alloc] init];
    _thirdValueHowItWorks.howItWorksViewDelegate = self;
    return _thirdValueHowItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksFourthView *)fourthHowItWorks {
    if (_fourthValueHowItWorks == nil) _fourthValueHowItWorks = [[HowItWorksFourthView alloc] init];
    _fourthValueHowItWorks.howItWorksViewDelegate = self;
    return _fourthValueHowItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksFifthView *)fifthHowItWorks {
    if (_fifthValueHowItWorks == nil) _fifthValueHowItWorks = [[HowItWorksFifthView alloc] init];
    _fifthValueHowItWorks.howItWorksViewDelegate = self;
    return _fifthValueHowItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksSixthView *)sixthHowItWorks {
    if (_sixthValueHowItWorks == nil) _sixthValueHowItWorks = [[HowItWorksSixthView alloc] init];
    _sixthValueHowItWorks.howItWorksViewDelegate = self;
    return _sixthValueHowItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksSeventhView *)seventhHowItWorks {
    if (_seventhValueHowItWorks == nil) _seventhValueHowItWorks = [[HowItWorksSeventhView alloc] init];
    _seventhValueHowItWorks.howItWorksViewDelegate = self;
    return _seventhValueHowItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksEighthView *)eighthHowItWorks {
    if (_eighthValueHowValueItWorks == nil) _eighthValueHowValueItWorks = [[HowItWorksEighthView alloc] init];
    _eighthValueHowValueItWorks.howItWorksViewDelegate = self;
    return _eighthValueHowValueItWorks;
}

/**
 * Lazily init the third value prop
 * @return ValuePropFourthView
 */
-(HowItWorksNinethView *)ninethHowItWorks {
    if (_ninethValueHowItWorks == nil) _ninethValueHowItWorks = [[HowItWorksNinethView alloc] init];
    _ninethValueHowItWorks.howItWorksViewDelegate = self;
    return _ninethValueHowItWorks;
}

/**
 * Lazily init the Tenth value prop
 * @return HowItWorksElevenView
 */
-(HowItWorksTenthView *)tenthHowItWorks{
    if (_tenthValueHowItWorks == nil) _tenthValueHowItWorks = [[HowItWorksTenthView alloc] init];
    _tenthValueHowItWorks.howItWorksViewDelegate = self;
    return _tenthValueHowItWorks;
}

/**
 * Lazily init the page control
 * @return UIPageControl
 */
-(UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.screenWidth - 60)/2, self.screenHeight - 30, 60, 8)];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = 10;
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
    _animationStatus = None;
    
    [self.view addSubview:[self contentScrollView]];
    [self.contentScrollView addSubview:[self firstHowItWorks]];
    [self.contentScrollView addSubview:[self secondHowItWorks]];
    [self.contentScrollView addSubview:[self thirdHowItWorks]];
    [self.contentScrollView addSubview:[self fourthHowItWorks]];
    [self.contentScrollView addSubview:[self fifthHowItWorks]];
    [self.contentScrollView addSubview:[self sixthHowItWorks]];
    [self.contentScrollView addSubview:[self seventhHowItWorks]];
    [self.contentScrollView addSubview:[self eighthHowItWorks]];
    [self.contentScrollView addSubview:[self ninethHowItWorks]];
    [self.contentScrollView addSubview:[self tenthHowItWorks]];
    
    [self.view addSubview:[self capturedBackgroundImageView]];
    [self.view addSubview:[self cancelButton]];
    [self.view addSubview:[self pageControl]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (self.capturedBackgroundImageView.alpha != 0) {
        [UIView animateWithDuration:0.8 animations:^{
            self.capturedBackgroundImageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self stopAnimationAtPage:self.currentPage];
                [self startAnimationAtPage:self.currentPage];
            }
        }];
    } else {
        [self stopAnimationAtPage:self.currentPage];
        [self startAnimationAtPage:self.currentPage];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - UIAction
/**
 * Handle the behavior when the cancel button is click
 */
-(void)cancelButtonClick {
    [self stopAnimationAtPage:self.currentPage];
    [UIView animateWithDuration:0.3 animations:^{
        self.capturedBackgroundImageView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - delegates & notifications
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

/**
 * close viewcontroller delegate
 * pop viewcontroller from stack
 */
-(void)closeHowItWorks {
    [UIView animateWithDuration:0.3 animations:^{
        self.capturedBackgroundImageView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) [self.navigationController popViewControllerAnimated:NO];
    }];
}

/**
 * Handle the behavior where the app enter the background
 */
-(void)applicationDidEnterBackground{
    [self stopAnimationAtPage:self.currentPage];
}

/**
 * Handle the behavior where the app enter the foreground
 */
-(void)applicationWillEnterForeground {
    [self startAnimationAtPage:self.currentPage];
}

/**
 * Handle the behavior when user tap screen
 */
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (_animationStatus == Done) {
        [self stopAnimationAtPage:self.currentPage];
//        [self startAnimationAtPage:self.currentPage];
        [self runAnimationAtPage:self.currentPage];
    }
    else if (_animationStatus == Running){
//        show view without animation
        [self showDetaillView:self.currentPage];
    }
}

/**
 * Subview delegate to go to the next page automatically
 */
-(void) gotoNextPage {
    int newPage = [self getCurrentPage] + 1 ;
    if (newPage > TOTAL_NUMBER_PAGES-1 || newPage < 0) newPage = 0;
    if (newPage != self.currentPage && newPage != 0) {
        CGRect frame = _contentScrollView.frame;
        frame.origin.x = frame.size.width * newPage;
        frame.origin.y = 0;
        [UIView animateWithDuration:0.7 animations:^{
            [_contentScrollView scrollRectToVisible:frame animated:NO];
        } completion:^(BOOL finished) {
            if (finished) {
                [self stopAnimationAtPage:self.currentPage];
                [self startAnimationAtPage:newPage];
                self.currentPage = newPage;
                self.pageControl.currentPage = newPage;
            }
        }];
    }
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
    if (page == 0) [_firstValueHowItWorks hideView];
    if (page == 1) [_secondValueHowItWorks hideView];
    if (page == 2) [_thirdValueHowItWorks hideView];
    if (page == 3) [_fourthValueHowItWorks hideView];
    if (page == 4) [_fifthValueHowItWorks hideView];
    if (page == 5) [_sixthValueHowItWorks hideView];
    if (page == 6) [_seventhValueHowItWorks hideView];
    if (page == 7) [_eighthValueHowValueItWorks hideView];
    if (page == 8) [_ninethValueHowItWorks hideView];
    if (page == 9) [_tenthValueHowItWorks hideView];
    
    _animationStatus = Done;
}

/**
 * Start animationa at a given page
 * @param int
 */
-(void)startAnimationAtPage:(int)page {
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (page == 0) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_1];
            if (_firstValueHowItWorks.animationStatus == Done) {
                [_firstValueHowItWorks stopAnmationAndShowView];
            }
            else if (_firstValueHowItWorks.animationStatus == None)
                [_firstValueHowItWorks showView];
        }
        if (page == 1) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_1];
            if (_secondValueHowItWorks.animationStatus == Done) {
                [_secondValueHowItWorks stopAnmationAndShowView];
            }
            else if (_secondValueHowItWorks.animationStatus == None) {
                [_secondValueHowItWorks showView];
            }
        }
        if (page == 2) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_2];
            if (_thirdValueHowItWorks.animationStatus == Done) {
                [_thirdValueHowItWorks stopAnmationAndShowView];
            }
            else if (_thirdValueHowItWorks.animationStatus == None) {
                [_thirdValueHowItWorks showView];
            }
        }
        if (page == 3) {
            if (_fourthValueHowItWorks.animationStatus == Done) {
                [_fourthValueHowItWorks stopAnmationAndShowView];
            }
            else if (_fourthValueHowItWorks.animationStatus == None) {
                [_fourthValueHowItWorks showView];
            }
        }
        if (page == 4) {
            if (_fifthValueHowItWorks.animationStatus == Done) {
                [_fifthValueHowItWorks stopAnmationAndShowView];
            }
            else if (_fifthValueHowItWorks.animationStatus == None) {
                [_fifthValueHowItWorks showView];
            }
        }
        if (page == 5) {
            if (_sixthValueHowItWorks.animationStatus == Done) {
                [_sixthValueHowItWorks stopAnmationAndShowView];
            }
            else if (_sixthValueHowItWorks.animationStatus == None) {
                [_sixthValueHowItWorks showView];
            }
        }
        if (page == 6) {
            if (_seventhValueHowItWorks.animationStatus == Done) {
                [_seventhValueHowItWorks stopAnmationAndShowView];
            }
            else if (_seventhValueHowItWorks.animationStatus == None) {
                [_seventhValueHowItWorks showView];
            }
        }
        if (page == 7) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_2];
            if (_eighthValueHowValueItWorks.animationStatus == Done) {
                [_eighthValueHowValueItWorks stopAnmationAndShowView];
            }
            else if (_eighthValueHowValueItWorks.animationStatus == None) {
                [_eighthValueHowValueItWorks showView];
            }
        }
        if (page == 8) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_3];
            if (_ninethValueHowItWorks.animationStatus == Done) {
                [_ninethValueHowItWorks stopAnmationAndShowView];
            }
            else if (_ninethValueHowItWorks.animationStatus == None) {
                [_ninethValueHowItWorks showView];
            }
        }
        if (page == 9) {
//            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_4];
            if (_tenthValueHowItWorks.animationStatus == Done) {
                [_tenthValueHowItWorks stopAnmationAndShowView];
            }
            else if (_tenthValueHowItWorks.animationStatus == None) {
                [_tenthValueHowItWorks showView];
            }
        }
    } completion:^(BOOL finished) {
        if (finished)
            _animationStatus = Done;
    }];
}

- (void) runAnimationAtPage:(int)page {
    if (page == 0) [_firstValueHowItWorks showView];
    if (page == 1) [_secondValueHowItWorks showView];
    if (page == 2) [_thirdValueHowItWorks showView];
    if (page == 3) [_fourthValueHowItWorks showView];
    if (page == 4) [_fifthValueHowItWorks showView];
    if (page == 5) [_sixthValueHowItWorks showView];
    if (page == 6) [_seventhValueHowItWorks showView];
    if (page == 7) [_eighthValueHowValueItWorks showView];
    if (page == 8) [_ninethValueHowItWorks showView];
    if (page == 9) [_tenthValueHowItWorks showView];
    _animationStatus = Done;
}

/**
 * Stop animation at a given page
 * @param int
 */
-(void)showDetaillView:(int)page {
    [UIView animateWithDuration:1 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (page == 0) {
            [_firstValueHowItWorks stopAnmationAndShowView];
        }
        if (page == 1)  {
            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_1];
            [_secondValueHowItWorks stopAnmationAndShowView];
        }
        if (page == 2) {
            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_2];
            [_thirdValueHowItWorks stopAnmationAndShowView];
        }
        if (page == 3) [_fourthValueHowItWorks stopAnmationAndShowView];
        if (page == 4) [_fifthValueHowItWorks stopAnmationAndShowView];
        if (page == 5) [_sixthValueHowItWorks stopAnmationAndShowView];
        if (page == 6) [_seventhValueHowItWorks stopAnmationAndShowView];
        if (page == 7) {
            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_2];
            [_eighthValueHowValueItWorks stopAnmationAndShowView];
        }
        if (page == 8) {
            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_3];
            [_ninethValueHowItWorks stopAnmationAndShowView];
        }
        if (page == 9) {
            [self setbackgroundImage:VALUE_BACKGROUND_SCREEN_4];
            [_tenthValueHowItWorks stopAnmationAndShowView];
        }
    } completion:^(BOOL finished) {
        if (finished)
            _animationStatus = Done;
    }];

    
}
@end
