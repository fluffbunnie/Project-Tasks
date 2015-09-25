//
//  GuidedInteractionCompleteViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionCompleteViewController.h"
#import "GuidedInteractionHomePage.h"
#import "HomePageViewController.h"
#import "FontColor.h"

@interface GuidedInteractionCompleteViewController()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) GuidedInteractionHomePage *homePage;
@property (nonatomic, strong) GuidedInteractionCompletedOverlayView *overlayView;

@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation GuidedInteractionCompleteViewController

#pragma mark - initiation
/**
 * Lazily init the home page
 * @return GuidedInterationHomePage
 */
-(GuidedInteractionHomePage *)homePage {
    if (_homePage == nil) {
        _homePage = [[GuidedInteractionHomePage alloc] init];
        _homePage.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
    }
    return _homePage;
}

/**
 * Lazily init the overlay view
 * @return GuidedInteractionCompletedOverlayView
 */
-(GuidedInteractionCompletedOverlayView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[GuidedInteractionCompletedOverlayView alloc] init];
        _overlayView.alpha = 1;
        [_overlayView setViewAlpha:0];
        _overlayView.delegate = self;
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
    }
    return _skipButton;
}


#pragma mark - initiation
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;

    [self.view addSubview:[self homePage]];
    [self.view addSubview:[self overlayView]];
    [self.view addSubview:[self skipButton]];
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
        self.skipButton.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) [self.skipButton removeFromSuperview];
    }];
}

/**
 * GuidedInteractionCompletedOverlayView
 * Handle the behavior when user click
 */
-(void)completeGuidedInteractionButtonClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            HomePageViewController *homeController = [[HomePageViewController alloc] init];
            [self.navigationController pushViewController:homeController animated:NO];
        }
    }];
}


@end
