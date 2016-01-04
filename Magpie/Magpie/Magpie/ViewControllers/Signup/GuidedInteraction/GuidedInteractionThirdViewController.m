//
//  GuidedInteractionThirdViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionThirdViewController.h"
#import "GuidedInteractionOverlayView.h"
#import "GuidedInteractionFourthViewController.h"
#import "GuidedInteractionDetailView.h"
#import "FontColor.h"
#import "HomePageViewController.h"

@interface GuidedInteractionThirdViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIPanGestureRecognizer *dragged;

@property (nonatomic, strong) GuidedInteractionDetailView *prevView;
@property (nonatomic, strong) GuidedInteractionDetailView *currentView;
@property (nonatomic, strong) GuidedInteractionDetailView *nextView;
@property (nonatomic, strong) GuidedInteractionOverlayView *overlayView;
@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation GuidedInteractionThirdViewController
#pragma mark - initiation
/**
 * Lazily init the prev view
 * @return GuidedInteractionDetailView
 */
-(GuidedInteractionDetailView *)prevView {
    if (_prevView == nil) {
        if (self.viewIndex == 1) _prevView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:0];
        else if (self.viewIndex == 0) _prevView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:-1];
        else _prevView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:1];
        
        _prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
    }
    return _prevView;
}

/**
 * Lazily init the current view
 * @return GuidedInteractionDetailView
 */
-(GuidedInteractionDetailView *)currentView {
    if (_currentView == nil) {
        _currentView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:self.viewIndex];
    }
    return _currentView;
}

/**
 * Lazily init the next view
 * @return GuidedInteractionDetailView
 */
-(GuidedInteractionDetailView *)nextView {
    if (_nextView == nil) {
        if (self.viewIndex == 1) _nextView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:-1];
        else if (self.viewIndex == 0) _nextView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:1];
        else _nextView = [[GuidedInteractionDetailView alloc] initFromOriginWithIndex:0];
        
        _nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
    }
    return _nextView;
}

/**
 * Lazily init the overlay view
 * @return GuidedInteractionOverlayView
 */
-(GuidedInteractionOverlayView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[GuidedInteractionOverlayView alloc] initWithIndex:2];
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

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self.view addSubview:[self prevView]];
    [self.view addSubview:[self nextView]];
    [self.view addSubview:[self currentView]];
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
    CGFloat xFromCenter = [gestureRecognizer translationInView:self.overlayView].x;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            [self.overlayView setViewAlpha:1 - sqrt(fabs(xFromCenter/self.screenWidth))];
            self.currentView.transform = CGAffineTransformMakeTranslation(xFromCenter, 0);
            
            if (xFromCenter == 0) {
                self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                self.currentView.transform = CGAffineTransformIdentity;
            } else if (xFromCenter < 0){
                self.prevView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                
                CGAffineTransform nextTransformTranslate = CGAffineTransformMakeTranslation(-self.screenWidth + xFromCenter, 0);
                if (xFromCenter < 0) nextTransformTranslate = CGAffineTransformMakeTranslation(self.screenWidth + xFromCenter, 0);
                self.nextView.transform = nextTransformTranslate;
            } else {
                self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                
                CGAffineTransform nextTransformTranslate = CGAffineTransformMakeTranslation(-self.screenWidth + xFromCenter, 0);
                if (xFromCenter < 0) nextTransformTranslate = CGAffineTransformMakeTranslation(self.screenWidth + xFromCenter, 0);
                self.prevView.transform = nextTransformTranslate;
            }
            
            break;
        };
            
        case UIGestureRecognizerStateEnded: {
            if (xFromCenter > 75) {
                [self.overlayView removeGestureRecognizer:self.dragged];
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    
                    self.prevView.transform = CGAffineTransformIdentity;
                    self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    
                    [self.overlayView setViewAlpha:0];
                } completion:^(BOOL finished) {
                    if (finished) [self goToNextStepWithNextView:NO];
                }];
            } else if (xFromCenter < -75){
                [self.overlayView removeGestureRecognizer:self.dragged];
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                    self.nextView.transform = CGAffineTransformIdentity;
                    self.prevView.transform = CGAffineTransformMakeTranslation(0, -self.screenWidth);
                    
                    [self.overlayView setViewAlpha:0];
                } completion:^(BOOL finished) {
                    if (finished) [self goToNextStepWithNextView:YES];
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentView.transform = CGAffineTransformIdentity;
                    self.nextView.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
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
    GuidedInteractionFourthViewController *fourthViewController = [[GuidedInteractionFourthViewController alloc] init];
    if (usingNextView) {
        int nextIndex = self.viewIndex + 1;
        if (nextIndex == 2) nextIndex = -1;
        fourthViewController.viewIndex = nextIndex;
    } else {
        int prevIndex = self.viewIndex - 1;
        if (prevIndex == -2) prevIndex = 1;
        fourthViewController.viewIndex = prevIndex;
    }
    
    [self.navigationController pushViewController:fourthViewController animated:NO];
}

/**
 * Go to the home page by click the skip button
 */
-(void)skipButtonClicked {
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageViewController animated:YES];
}


@end
