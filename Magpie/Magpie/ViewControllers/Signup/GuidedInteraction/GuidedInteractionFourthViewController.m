//
//  GuidedInteractionFourthViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionFourthViewController.h"
#import "GuidedInteractionHorizontalSwipeCardView.h"
#import "GuidedInteractionOverlayView.h"
#import "FontColor.h"
#import "GuidedInteractionDetailView.h"
#import "GuidedInteractionFifthViewController.h"
#import "HomePageViewController.h"

static NSString * const BACKGROUND_IMAGE = @"DefaultBackgroundImageDark";

static NSString * const FIRST_PROPERTY_IMAGE = @"OnboardingCurrentPropertyImage";
static NSString * const FIRST_USER_IMAGE = @"OnboardingCurrentProfileImage";
static NSString * const NEXT_PROPERTY_IMAGE = @"OnboardingNextPropertyImage";
static NSString * const NEXT_USER_IMAGE = @"OnboardingNextProfileImage";
static NSString * const PREV_PROPERTY_IMAGE = @"OnboardingPrevPropertyImage";
static NSString * const PREV_PROFILE_IMAGE = @"OnboardingPrevProfileImage";

@interface GuidedInteractionFourthViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIPanGestureRecognizer *dragged;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) GuidedInteractionHorizontalSwipeCardView *cardView;
@property (nonatomic, strong) GuidedInteractionDetailView *detailView;
@property (nonatomic, strong) GuidedInteractionOverlayView *overlayView;

@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation GuidedInteractionFourthViewController

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
 * Lazily init the card view
 * @return GuidedInteractionHorizontalSwipeCardView
 */
-(GuidedInteractionHorizontalSwipeCardView *)cardView {
    if (_cardView == nil) {
        _cardView = [[GuidedInteractionHorizontalSwipeCardView alloc] init];
        [_cardView setViewIndex:self.viewIndex];
        _cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _cardView.alpha = 0.5;
    }
    return _cardView;
}

/**
 * Lazily init the detail view
 * @return GuidedInteractionDetailview
 */
-(GuidedInteractionDetailView *)detailView {
    if (_detailView == nil) {
        _detailView = [[GuidedInteractionDetailView alloc] initWithIndex:self.viewIndex];
        _detailView.transform = CGAffineTransformMakeTranslation(0, -self.screenHeight);
    }
    return _detailView;
}

/**
 * Lazily init the swipe view
 * @return GuidedInteractionOverlayView
 */
-(GuidedInteractionOverlayView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[GuidedInteractionOverlayView alloc] initWithIndex:3];
        _overlayView.alpha = 1;
        [_overlayView setViewAlpha:0];
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

#pragma mark - initiation
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self cardView]];
    [self.view addSubview:[self detailView]];
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
    [UIView animateWithDuration:1 animations:^{
        [self.overlayView setViewAlpha:1];
    }];
}

#pragma mark - action method
/**
 * Handle the action when the card is dragged
 * @param pan gesture
 */
-(void)cardDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat yFromCenter = [gestureRecognizer translationInView:self.overlayView].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            if (yFromCenter >= 0) {
                [self.overlayView setViewAlpha:1 - sqrt(fabs(yFromCenter/self.screenHeight))];
                CGFloat cardScale = 0.8 + 0.2 * fabs(yFromCenter/self.screenHeight);
                self.cardView.transform = CGAffineTransformMakeScale(cardScale, cardScale);
                CGFloat cardAlpha = 0.5 + 0.5 * fabs(yFromCenter/self.screenHeight);
                self.cardView.alpha = cardAlpha;
                
                self.detailView.transform = CGAffineTransformMakeTranslation(0, yFromCenter - self.screenHeight);
            } else {
                [self.overlayView setViewAlpha:1];
                
                self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                self.cardView.alpha = 0.5;
                
                self.detailView.transform = CGAffineTransformMakeTranslation(0, -self.screenHeight);
            }
            
            break;
        };
            
        case UIGestureRecognizerStateEnded: {
            if (yFromCenter > 75) {
                [self.overlayView removeGestureRecognizer:self.dragged];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [self.overlayView setViewAlpha:0];
                    self.cardView.transform = CGAffineTransformIdentity;
                    self.cardView.alpha = 1;
                    
                    self.detailView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    if (finished) [self goToNextStepWithViewIndex:self.viewIndex];
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    [self.overlayView setViewAlpha:1];
                    self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    self.cardView.alpha = 0.5;
                    
                    self.detailView.transform = CGAffineTransformMakeTranslation(0, -self.screenHeight);
                }];
            }
            
            break;
        };
            
        default: break;
    }
}

-(void)goToNextStepWithViewIndex:(int)viewIndex {
    GuidedInteractionFifthViewController *nextViewController = [[GuidedInteractionFifthViewController alloc] init];
    nextViewController.viewIndex = viewIndex;
    [self.navigationController pushViewController:nextViewController animated:NO];
}

/**
 * Go to the home page by click the skip button
 */
-(void)skipButtonClicked {
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageViewController animated:YES];
}

@end