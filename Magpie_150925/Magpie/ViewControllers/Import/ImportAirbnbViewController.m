//
//  ImportAirbnbViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/8/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportAirbnbViewController.h"
#import "CrossCloseButton.h"
#import "ImportStatusViewController.h"
#import "ErrorMessageDisplay.h"

static NSString *DEFAULT_BACKGROUND_IMAGE_LIGHT = @"DefaultBackgroundImageLight";

@interface ImportAirbnbViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *capturedBackground;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) AirbnbLoginView *airbnbLoginView;
@property (nonatomic, strong) CrossCloseButton *closeButton;

@property (nonatomic, assign) BOOL didGetUid;
@end

@implementation ImportAirbnbViewController
#pragma mark - initiation
/**
 * Lazily init the capture background image
 * @return UIImageView
 */
-(UIImageView *)capturedBackground {
    if (_capturedBackground == nil) {
        _capturedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackground.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackground.image = self.prevScreenCapturedImage;
    }
    return _capturedBackground;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.alpha = 0;
    }
    return _containerView;
}

/**
 * Lazily init the background image view
 * @return UIImageView
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_LIGHT];
    }
    return _backgroundImageView;
}

/**
 * Lazily init airbnb login view
 * @return AirbnbLoginView
 */
-(AirbnbLoginView *)airbnbLoginView {
    if (_airbnbLoginView == nil) {
        _airbnbLoginView = [[AirbnbLoginView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _airbnbLoginView.webDelegate = self;
    }
    return _airbnbLoginView;
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
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self capturedBackground]];
    [self.view addSubview:[self containerView]];
    
    [self.containerView addSubview:[self backgroundImageView]];
    [self.containerView addSubview:[self airbnbLoginView]];
    [self.containerView addSubview:[self closeButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.airbnbLoginView showView];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.alpha = 1;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard delegate
/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif{
    [self.airbnbLoginView keyboardWillShow];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [self.airbnbLoginView keyboardWillHide];
}


#pragma mark - web delegate
-(void)fetchedUid:(NSString *)uid {
    if (self.didGetUid == NO) {
        self.didGetUid = YES;
        ImportStatusViewController *importStatusViewController = [[ImportStatusViewController alloc] init];
        importStatusViewController.airbnbUid = uid;
        [self.navigationController pushViewController:importStatusViewController animated:YES];
    }
}

-(void)showPhotoRequireMessage {
    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Upload Photo" andMessage:@"Make sure you have an Airbnb profile photo so we can import your account!"];
}

#pragma mark - click action
/**
 * Handle the behavior when user clicked on the close button
 */
-(void)closeButtonClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}



@end
