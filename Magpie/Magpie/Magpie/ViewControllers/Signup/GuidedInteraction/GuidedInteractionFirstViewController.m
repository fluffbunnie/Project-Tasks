//
//  GuidedInteractionFirstViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 7/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionFirstViewController.h"
#import "GuidedInteractionHorizontalSwipeCardView.h"
#import "GuidedInteractionOverlayView.h"
#import "FontColor.h"
#import "GuidedInteractionSecondViewController.h"
#import "HomePageViewController.h"

static NSString * const BACKGROUND_IMAGE = @"DefaultBackgroundImageDark";

static NSString * const MAGPIE_ICON = @"MagpieIcon";

static NSString * const FIRST_PROPERTY_IMAGE = @"OnboardingCurrentPropertyImage";
static NSString * const FIRST_USER_IMAGE = @"OnboardingCurrentProfileImage";
static NSString * const NEXT_PROPERTY_IMAGE = @"OnboardingNextPropertyImage";
static NSString * const NEXT_USER_IMAGE = @"OnboardingNextProfileImage";
static NSString * const PREV_PROPERTY_IMAGE = @"OnboardingPrevPropertyImage";
static NSString * const PREV_PROFILE_IMAGE = @"OnboardingPrevProfileImage";

@interface GuidedInteractionFirstViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIPanGestureRecognizer *dragged;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) GuidedInteractionHorizontalSwipeCardView *prevView;
@property (nonatomic, strong) GuidedInteractionHorizontalSwipeCardView *currentView;
@property (nonatomic, strong) GuidedInteractionHorizontalSwipeCardView *nextView;

@property (nonatomic, strong) GuidedInteractionOverlayView *overlayView;

@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation GuidedInteractionFirstViewController
#pragma mark - initiation

/**
 * Lazily init the background image
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed:BACKGROUND_IMAGE];
    }
    return _backgroundImage;
}

/**
 * Lazily init the current view
 * @return GuidedInteractionHorizontalSwipeCardView
 */
-(GuidedInteractionHorizontalSwipeCardView *)currentView {
    if (_currentView == nil) {
        _currentView = [[GuidedInteractionHorizontalSwipeCardView alloc] init];
        [_currentView setViewIndex:0];
        [_currentView animateView];
    }
    return _currentView;
}

/**
 * Lazily init the next view
 * @return GuidedInteractionHorizontalSwipeCardView
 */
-(GuidedInteractionHorizontalSwipeCardView *)nextView {
    if (_nextView == nil) {
        _nextView = [[GuidedInteractionHorizontalSwipeCardView alloc] init];
        [_nextView setViewIndex:1];
        _nextView.alpha = 0;
        _nextView.transform = CGAffineTransformMakeTranslation(0, self.screenWidth);
    }
    return _nextView;
}

/**
 * Lazily init the next view
 * @return GuidedInteractionHorizontalSwipeCardView
 */
-(GuidedInteractionHorizontalSwipeCardView *)prevView {
    if (_prevView == nil) {
        _prevView = [[GuidedInteractionHorizontalSwipeCardView alloc] init];
        [_prevView setViewIndex:-1];
        _prevView.alpha = 0;
        _prevView.transform = CGAffineTransformMakeTranslation(0, -self.screenWidth);
    }
    return _prevView;
}

/**
 * Lazily init the swipe view
 * @return GuidedInteractionOverlayView
 */
-(GuidedInteractionOverlayView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[GuidedInteractionOverlayView alloc] initWithIndex:0];
    }
    return _overlayView;
}

/**
 * Lazily init the skip button
 * @return UIButton
 */
-(UIButton *)skipButton {
    if (_skipButton == nil) {
        _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 50, 0, 50, 50)];
        _skipButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        
        [_skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self currentView]];
    [self.view addSubview:[self nextView]];
    [self.view addSubview:[self prevView]];
    [self.view addSubview:[self overlayView]];
    [self.view addSubview:[self skipButton]];
    
    self.dragged = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardDragged:)];
    [self.overlayView addGestureRecognizer:self.dragged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 animations:^{
        self.overlayView.alpha = 1;
    }];
}

#pragma mark - action method
/**
 * Handle the action when the card is dragged
 * @param pan gesture
 */
-(void)cardDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat xFromCenter = [gestureRecognizer translationInView:self.overlayView].x;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            [self.overlayView setViewAlpha:1 - sqrt(fabs(xFromCenter/self.screenWidth))];
            self.currentView.alpha = 1 - 0.4 * fabs(xFromCenter/self.screenWidth);
            CGFloat scale = 1 - 0.2 * fabs(xFromCenter/self.screenWidth);
            CGAffineTransform transformScale = CGAffineTransformMakeScale(scale, scale);
            CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(xFromCenter, 0);
            self.currentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
            
            if (xFromCenter == 0) {
                self.nextView.alpha = 0;
                self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                self.prevView.alpha = 0;
                self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                self.currentView.alpha = 1;
                self.currentView.transform = CGAffineTransformIdentity;
            } else if (xFromCenter < 0){
                self.prevView.alpha = 0;
                self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                
                self.nextView.alpha = 0.6 + 0.4 * fabs(xFromCenter/self.screenWidth);
                CGFloat nextScale = 0.8 + 0.2 * fabs(xFromCenter/self.screenWidth);
                CGAffineTransform nextTransformScale = CGAffineTransformMakeScale(nextScale, nextScale);
                CGAffineTransform nextTransformTranslate = CGAffineTransformMakeTranslation(-self.screenWidth + xFromCenter, 0);
                if (xFromCenter < 0) nextTransformTranslate = CGAffineTransformMakeTranslation(self.screenWidth + xFromCenter, 0);
                self.nextView.transform = CGAffineTransformConcat(nextTransformScale, nextTransformTranslate);
            } else {
                self.nextView.alpha = 0;
                self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                
                self.prevView.alpha = 0.6 + 0.4 * fabs(xFromCenter/self.screenWidth);
                CGFloat nextScale = 0.8 + 0.2 * fabs(xFromCenter/self.screenWidth);
                CGAffineTransform nextTransformScale = CGAffineTransformMakeScale(nextScale, nextScale);
                CGAffineTransform nextTransformTranslate = CGAffineTransformMakeTranslation(-self.screenWidth + xFromCenter, 0);
                if (xFromCenter < 0) nextTransformTranslate = CGAffineTransformMakeTranslation(self.screenWidth + xFromCenter, 0);
                self.prevView.transform = CGAffineTransformConcat(nextTransformScale, nextTransformTranslate);
            }
    
            break;
        };
            
        case UIGestureRecognizerStateEnded: {
            if (xFromCenter > 75) {
                [self.overlayView removeGestureRecognizer:self.dragged];
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.alpha = 0.6;
                    CGAffineTransform transformScale = CGAffineTransformMakeScale(0.8, 0.8);
                    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    self.currentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
                    
                    self.prevView.alpha = 1;
                    self.prevView.transform = CGAffineTransformIdentity;
                    
                    self.nextView.alpha = 0;
                    self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    
                    [self.overlayView setViewAlpha:0];
                } completion:^(BOOL finished) {
                    if (finished) [self goToNextStepWithNextView:NO];
                }];
            } else if (xFromCenter < -75){
                [self.overlayView removeGestureRecognizer:self.dragged];
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.alpha = 0.6;
                    CGAffineTransform transformScale = CGAffineTransformMakeScale(0.8, 0.8);
                    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                    self.currentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
                    
                    self.nextView.alpha = 1;
                    self.nextView.transform = CGAffineTransformIdentity;
                    
                    self.prevView.alpha = 0;
                    self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                    
                    [self.overlayView setViewAlpha:0];
                } completion:^(BOOL finished) {
                    if (finished) [self goToNextStepWithNextView:YES];
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.alpha = 1;
                    self.currentView.transform = CGAffineTransformIdentity;
                    self.nextView.alpha = 0;
                    self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    self.prevView.alpha = 0;
                    self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                    
                    [self.overlayView setViewAlpha:1];
                }];
            }
            
            break;
        };
            
        default: break;
    }
}

/**
 * Go to the next tutorial view
 * @param BOOL
 */
-(void)goToNextStepWithNextView:(BOOL)usingNextView {
    GuidedInteractionSecondViewController *secondViewController = [[GuidedInteractionSecondViewController alloc] init];
    secondViewController.usingNextView = usingNextView;
    [self.navigationController pushViewController:secondViewController animated:NO];
}

/**
 * Go to the home page by click the skip button
 */
-(void)skipButtonClicked {
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageViewController animated:YES];
}


@end
