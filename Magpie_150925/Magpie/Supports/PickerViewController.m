//
//  PickerViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PickerViewController.h"
#import "FontColor.h"

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * DEFAULT_BACKGROUND_IMAGE_LIGHT = @"DefaultBackgroundImageLight";
static NSString * IMAGE_DESCRIPTION_PLACE_HOLDER = @"Please enter photo's description";

@interface PickerViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UITextField *descriptionTextField;
@end

@implementation PickerViewController
#pragma mark - initiation
/**
 * Lazily init the back button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goBack)];
    }
    return _backButton;
}

/**
 * Lazily init the done button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        UIButton * doneBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        doneBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [doneBt setTitle:@"Done" forState:UIControlStateNormal];
        [doneBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [doneBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [doneBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [doneBt sizeToFit];
        [doneBt addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        _doneButton = [[UIBarButtonItem alloc] initWithCustomView:doneBt];
    }
    return _doneButton;
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
 * Lazily init the scroll view
 * @return UIScrollView
 */
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.screenWidth, self.screenHeight - 64);
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.delegate = self;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        [doubleTap setNumberOfTapsRequired:2];
        
        [_scrollView addGestureRecognizer:doubleTap];
    }
    return _scrollView;
}

/**
 * Lazily init the current image view
 * @return UIImageView
 */
-(UIImageView *)currentImageView {
    if (_currentImageView == nil) {
        _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 64)];
        _currentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _currentImageView.image = self.pickedImage;
    }
    return _currentImageView;
}

/**
 * Lazily init the description text view
 * @return UITextField
 */
-(UITextField *)descriptionTextField {
    if (_descriptionTextField == nil) {
        _descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.screenHeight - 44, self.screenWidth, 44)];
        _descriptionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        _descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
        _descriptionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:IMAGE_DESCRIPTION_PLACE_HOLDER attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor],
                                                                                                                          NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]}];
        _descriptionTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _descriptionTextField.textColor = [FontColor titleColor];
    }
    return _descriptionTextField;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Upload Photo";
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self doneButton];
    
    [self.view addSubview:[self backgroundImageView]];
    [self.view addSubview:[self scrollView]];
    [self.scrollView addSubview:[self currentImageView]];
    if (self.editable) {
        [self.view addSubview:[self descriptionTextField]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Listen for keyboard appearances and disappearances
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

#pragma mark - keyboard functions
/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif{
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardBounds.size.height);
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

/**
 * Dismiss the keyboard, to do this, basically resign the first responder
 */
-(void)dismissKeyboard {
    [self.descriptionTextField resignFirstResponder];
}

#pragma mark - ui action
/**
 * Pop the current navigation controller to go back to the prev one
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user tap on the done button
 */
-(void)doneAction {
    if (!self.editable) [self.pickerRef.photoPickerDelegate uploadImage:self.pickedImage];
    else [self.pickerRef.photoPickerDelegate uploadImage:self.pickedImage withDescription:self.descriptionTextField.text];
}

/**
 * Handle the delegate when the scroll view is being zoom in
 * @param UIScrollView
 * @return UIView
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.currentImageView;
}

/**
 * Handle double tab to zoom
 */
-(void)handleDoubleTap {
    if(self.scrollView.zoomScale > 1) [self.scrollView setZoomScale:1 animated:YES];
    else [self.scrollView setZoomScale:3 animated:YES];
}

@end
