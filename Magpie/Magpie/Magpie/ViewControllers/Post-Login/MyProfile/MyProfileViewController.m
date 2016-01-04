//
//  MyProfileViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UserManager.h"
#import "FontColor.h"
#import "SquircleProfileImage.h"
#import "UserManager.h"
#import "HomePageViewController.h"
#import "ToastView.h"
#import "MyProfileLocationViewController.h"
#import "JGActionSheet.h"
#import "PhotoPicker.h"
#import "UIImage+ImageEffects.h"
#import "LoadingView.h"
#import "ErrorMessageDisplay.h"
#import "Mixpanel.h"
#import "FloatPlaceholderTextView.h"
#import "MyPlaceReviewViewController.h"
#import "ChatViewController.h"
#import "HomePageViewController.h"

static NSString * CLOUDINARY_URL = @"cloudinary://556454867449341:Rtlqd_Lqzh_r3G1gX1DsxhLNq6k@magpie";
static NSString * LOADING_VIEW_TEXT = @"Uploading";

static NSString * VIEW_TITLE = @"Profile";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * NAVIGATION_BAR_SETTING_ICON_NAME = @"NavigationBarSettingIconRed";

static NSString * DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";
static NSString * HEADER_MASK = @"PropertyImageMask";
static NSString * NAME_PLACE_HOLDER = @"Enter your name";

@interface MyProfileViewController ()
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) JGActionSheet *photoPickerActionSheet;
@property (nonatomic, strong) PhotoPicker *photoPicker;
@property (nonatomic, strong) CLCloudinary *cloudinary;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UITextField *profileNameTextField;
@property (nonatomic, strong) UILabel *emailAddressLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) FloatPlaceholderTextView *favoritePlaceTextView;
@property (nonatomic, strong) FloatPlaceholderTextView *dreamDestinationTextView;
@property (nonatomic, strong) FloatPlaceholderTextView *associationTextView;
@property (nonatomic, strong) FloatPlaceholderTextView *aboutMyselfTextView;
@end

@implementation MyProfileViewController
#pragma mark - initiation
/**
 * Lazily init the photo picker action sheet
 * @return JGActionSheet
 */
-(JGActionSheet *)photoPickerActionSheet {
    if (_photoPickerActionSheet == nil) {
        JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Upload from your photo library"] buttonStyle:JGActionSheetButtonStyleDefault];
        JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
        
        _photoPickerActionSheet = [JGActionSheet actionSheetWithSections:@[section1, cancelSection]];
        
        __weak typeof(self) weakSelf = self;
        [_photoPickerActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if (indexPath.section == 0) [weakSelf showPhotoPicker];
            [sheet dismissAnimated:YES];
        }];
    }
    return _photoPickerActionSheet;
}

/**
 * Lazily init the photo picker obj
 * @return PhotoPicker
 */
-(PhotoPicker *)photoPicker {
    if (_photoPicker == nil) {
        _photoPicker = [[PhotoPicker alloc] initWithViewController:self];
        _photoPicker.photoPickerDelegate = self;
    }
    return _photoPicker;
}

/**
 * Lazily init the cloudinary object
 * @return CLUploader
 */
-(CLCloudinary *)cloudinary {
    if (_cloudinary == nil) _cloudinary = [[CLCloudinary alloc] initWithUrl:CLOUDINARY_URL];
    return _cloudinary;
}

/**
 * Lazily init the loading view
 * @return LoadingView
 */
-(LoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[LoadingView alloc] initWithMessage:LOADING_VIEW_TEXT];
    }
    return _loadingView;
}

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
 * Lazily init the save button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)saveButton {
    if (_saveButton == nil) {
        UIButton *saveBt = [[UIButton alloc] init];
        saveBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [saveBt setTitle:@"Save" forState:UIControlStateNormal];
        [saveBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [saveBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [saveBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [saveBt sizeToFit];
        [saveBt addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];

        _saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
        _saveButton.enabled = NO;
    }
    return _saveButton;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    }
    return _containerView;
}

/**
 * Lazily init the profile image view
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(20, 20, 70, 70)];
        [_profileImage setProfileImageWithUrl:self.userObj[@"profilePic"]];
        _profileImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUploadPhotoActionSheet)];
        [_profileImage addGestureRecognizer:tapGesture];
    }
    return _profileImage;
}

/**
 * Lazily init the first name text field
 * @return UITextField
 */
-(UITextField *)profileNameTextField {
    if (_profileNameTextField == nil) {
        _profileNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(105, 20, self.screenWidth - 120, 22)];
        _profileNameTextField.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
        _profileNameTextField.textColor = [FontColor titleColor];
        _profileNameTextField.text = self.userObj[@"firstname"] ? self.userObj[@"firstname"] : @"";
        _profileNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First name" attributes:@{NSForegroundColorAttributeName:[FontColor subTitleColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:16]}];
        _profileNameTextField.delegate = self;
        
        //we change the frame accordingly
        CGFloat desiredWidth = [_profileNameTextField sizeThatFits:CGSizeMake(FLT_MAX, 22)].width + 22;
        if (desiredWidth < self.screenWidth - 120) _profileNameTextField.frame =CGRectMake(105, 20, desiredWidth, 22);
        
        UIImageView *myView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TextEditIcon"]];
        
        [_profileNameTextField setRightView:myView];
        _profileNameTextField.rightView.frame = CGRectMake(0, 0, 22, 22);
        [_profileNameTextField setRightViewMode: UITextFieldViewModeAlways];

        
        [_profileNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _profileNameTextField;
}

/**
 * Lazily init the email label
 * @return UILabel
 */
-(UILabel *)emailAddressLabel {
    if (_emailAddressLabel == nil) {
        _emailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, CGRectGetMaxY(self.profileNameTextField.frame) + 2, self.screenWidth - 120, 22)];
        _emailAddressLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _emailAddressLabel.textColor = [FontColor defaultBackgroundColor];
        _emailAddressLabel.text = self.userObj[@"email"] ? self.userObj[@"email"] : @"";
    }
    return _emailAddressLabel;
}

/**
 * Lazily init the location label
 * @return UILabel
 */
-(UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, CGRectGetMaxY(self.emailAddressLabel.frame) + 1, self.screenWidth - 120, 22)];
        _locationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _locationLabel.textColor = [FontColor subTitleColor];
        _locationLabel.text = self.userObj[@"location"] ? self.userObj[@"location"] : @"Enter your address";
        _locationLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLocationSearch)];
        [_locationLabel addGestureRecognizer:tapGesture];
    }
    return _locationLabel;
}

/**
 * Lazily init the favorite place text field
 * @return FloatPlaceHolderTextView
 */
-(FloatPlaceholderTextView *)favoritePlaceTextView {
    if (_favoritePlaceTextView == nil) {
        _favoritePlaceTextView = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:@"Favorite places I've been" andFrame:CGRectMake(20, CGRectGetMaxY(self.locationLabel.frame) + 40, self.screenWidth - 40, 52)];
        _favoritePlaceTextView.tag = 0;
        _favoritePlaceTextView.delegate = self;
        if (self.userObj[@"favoritePlace"]) {
            _favoritePlaceTextView.text = self.userObj[@"favoritePlace"];
            CGSize newSize = [_favoritePlaceTextView sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
            _favoritePlaceTextView.frame = CGRectMake(20, CGRectGetMaxY(self.locationLabel.frame) + 40, self.screenWidth - 40, newSize.height);
        }
    }
    return _favoritePlaceTextView;
}

/**
 * Lazily init the dream destination text field
 * @return FloatPlaceHolderTextView
 */
-(FloatPlaceholderTextView *)dreamDestinationTextView {
    if (_dreamDestinationTextView == nil) {
        _dreamDestinationTextView = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:@"My dream destinations" andFrame:CGRectMake(20, CGRectGetMaxY(self.favoritePlaceTextView.frame) + 30, self.screenWidth - 40, 52)];
        _dreamDestinationTextView.tag = 1;
        _dreamDestinationTextView.delegate = self;
        if (self.userObj[@"dreamPlace"]) {
            _dreamDestinationTextView.text = self.userObj[@"dreamPlace"];
            CGSize newSize = [_dreamDestinationTextView sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
            _dreamDestinationTextView.frame = CGRectMake(20, CGRectGetMaxY(self.favoritePlaceTextView.frame) + 30, self.screenWidth - 40, newSize.height);
        }
    }
    return _dreamDestinationTextView;
}

/**
 * Lazily init the association text field
 * @return FloatPlaceHolderTextView
 */
-(FloatPlaceholderTextView *)associationTextView {
    if (_associationTextView == nil) {
        _associationTextView = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:@"School or company I associated with" andFrame:CGRectMake(20, CGRectGetMaxY(self.dreamDestinationTextView.frame) + 30, self.screenWidth - 40, 52)];
        _associationTextView.tag = 2;
        _associationTextView.delegate = self;
        if (self.userObj[@"association"]) {
            _associationTextView.text = self.userObj[@"association"];
            CGSize newSize = [_associationTextView sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
            _associationTextView.frame = CGRectMake(20, CGRectGetMaxY(self.dreamDestinationTextView.frame) + 30, self.screenWidth - 40, newSize.height);
        }
    }
    return _associationTextView;
}

/**
 * Lazily init the association text field
 * @return FloatPlaceHolderTextView
 */
-(FloatPlaceholderTextView *)aboutMyselfTextView {
    if (_aboutMyselfTextView == nil) {
        _aboutMyselfTextView = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:@"Other interesting things about me" andFrame:CGRectMake(20, CGRectGetMaxY(self.associationTextView.frame) + 30, self.screenWidth - 40, 52)];
        _aboutMyselfTextView.tag = 3;
        _aboutMyselfTextView.delegate = self;
        if (self.userObj[@"description"]) {
            _aboutMyselfTextView.text = self.userObj[@"description"];
            CGSize newSize = [_aboutMyselfTextView sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
            _aboutMyselfTextView.frame = CGRectMake(20, CGRectGetMaxY(self.associationTextView.frame) + 30, self.screenWidth - 40, newSize.height);
        }
    }
    return _aboutMyselfTextView;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.title = VIEW_TITLE;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self saveButton];
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        [self.view addSubview:[self containerView]];
        [self.containerView addSubview:[self profileImage]];
        [self.containerView addSubview:[self profileNameTextField]];
        [self.containerView addSubview:[self emailAddressLabel]];
        [self.containerView addSubview:[self locationLabel]];
        [self.containerView addSubview:[self favoritePlaceTextView]];
        [self.containerView addSubview:[self dreamDestinationTextView]];
        [self.containerView addSubview:[self associationTextView]];
        [self.containerView addSubview:[self aboutMyselfTextView]];
    
        self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.aboutMyselfTextView.frame) + 30);
    }];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark -keyboard
/**
 * On keyboard changing, show the right view
 * @param notif
 */
-(void)keyboardWillChange:(NSNotification *)notif {
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight - keyboardBounds.size.height);
    }];
}

/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif{
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight - keyboardBounds.size.height);
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }];
}

#pragma mark - text view delegate
/**
 * Handle the behavior when the text field did change
 * @param UITextField
 */
-(void)textFieldDidChange:(UITextField *)textField {
    self.saveButton.enabled = YES;
    if (textField.text.length > 0) self.userObj[@"firstname"] = textField.text;
}

/**
 * Handle the behavior when the text field is began editing
 * @param UITextField
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.containerView scrollRectToVisible:textField.frame animated:YES];
    textField.frame = CGRectMake(105, 20, self.screenWidth - 120, 22);
    [textField setRightViewMode: UITextFieldViewModeNever];
}

/**
 * Handle the behavior when the text field ended editting
 * @param UITextField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [textField becomeFirstResponder];
        [ToastView showToastAtCenterOfView:self.view withText:@"Please enter a valid name" withDuration:2];
    } else {
        CGFloat desiredWidth = [self.profileNameTextField sizeThatFits:CGSizeMake(FLT_MAX, 22)].width + 22;
        if (desiredWidth < self.screenWidth - 120) self.profileNameTextField.frame =CGRectMake(105, 20, desiredWidth, 22);
        
        _profileNameTextField.rightView.frame = CGRectMake(0, 0, 22, 22);
        [_profileNameTextField setRightViewMode: UITextFieldViewModeAlways];
        [_profileNameTextField layoutIfNeeded];
    }
}

/**
 * UITextField delegate
 * When the text field click on return button
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 * When the text view begin editing, we re-layout the subviews
 * @param textView
 */
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.containerView scrollRectToVisible:textView.frame animated:YES];
    [textView layoutSubviews];
}

/**
 * When the text view ended the editing, we also re-layout the subviews
 * @param textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView {
    [textView layoutSubviews];
}

/**
 * When the text view change, we calculate the height of the new view
 * @param textview
 */
- (void)textViewDidChange:(UITextView *)textView {
    self.saveButton.enabled = YES;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    
    if (newSize.height > textView.frame.size.height) {
        CGRect newFrame = textView.frame;
        newFrame.size.height = newSize.height;
        textView.frame = newFrame;
        
        [self realignTextViewFrames];
    }
    
    if (textView.text.length > 0) {
        if (textView.tag == 0) self.userObj[@"favoritePlace"] = textView.text;
        if (textView.tag == 1) self.userObj[@"dreamPlace"] = textView.text;
        if (textView.tag == 2) self.userObj[@"association"] = textView.text;
        if (textView.tag == 3) self.userObj[@"description"] = textView.text;
    } else {
        if (textView.tag == 0) self.userObj[@"favoritePlace"] = @"";
        if (textView.tag == 1) self.userObj[@"dreamPlace"] = @"";
        if (textView.tag == 2) self.userObj[@"association"] = @"";
        if (textView.tag == 3) self.userObj[@"description"] = @"";
    }
}

/**
 * Realign the text views
 */
-(void)realignTextViewFrames {
    self.dreamDestinationTextView.frame = CGRectMake(self.dreamDestinationTextView.frame.origin.x, CGRectGetMaxY(self.favoritePlaceTextView.frame) + 30, CGRectGetWidth(self.dreamDestinationTextView.frame), CGRectGetHeight(self.dreamDestinationTextView.frame));
    
    self.associationTextView.frame = CGRectMake(self.associationTextView.frame.origin.x, CGRectGetMaxY(self.dreamDestinationTextView.frame) + 30, CGRectGetWidth(self.associationTextView.frame), CGRectGetHeight(self.associationTextView.frame));
    
    self.aboutMyselfTextView.frame = CGRectMake(self.aboutMyselfTextView.frame.origin.x, CGRectGetMaxY(self.associationTextView.frame) + 30, CGRectGetWidth(self.aboutMyselfTextView.frame), CGRectGetHeight(self.aboutMyselfTextView.frame));
    
    self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.aboutMyselfTextView.frame) + 30);
}

#pragma mark - private method
/**
 * Handle the behavior when user tap on the profile picture
 */
-(void)showUploadPhotoActionSheet {
    [self hideKeyboard];
    [[self photoPickerActionSheet] showInView:self.windowView animated:YES];
}

/**
 * Handle the action when user click on upload new photo button in the action sheet
 */
-(void)showPhotoPicker {
    [[self photoPicker] showMediaBrowser];
}

/**
 * Handle the action when user updated the new photo
 * @param UIImage
 */
-(void)uploadImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self loadingView] showInView:self.windowView];
        
        CLUploader *photoUploader = [[CLUploader alloc] init:[self cloudinary] delegate:nil];
        
        UIImage *scaledImage = [image scaleToSizeKeepAspect:CGSizeMake(1440, 1440)];
        NSData* data = UIImageJPEGRepresentation(scaledImage, 0.8);
        [photoUploader upload:data options:nil withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
            if (successResult) {
                self.userObj[@"profilePic"] = successResult[@"url"];
                
                [self.userObj saveInBackground];
                [self.profileImage setProfileImageWithUrl:self.userObj[@"profilePic"]];
                [self.loadingView dismiss];
            } else {
                [self.loadingView dismiss];
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:PHOTO_UPLOAD_FAIL_TITLE andMessage:PHOTO_UPLOAD_FAIL_DESCRIPTION];
            }
        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {}];
    }];
}

/**
 * Handle the behavior when user click on outside the username editext
 */
-(void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UIAction
/**
 * Save when user click on the save button
 */
-(void)saveButtonClick {
    [self goBack];
}

/**
 * Handle when user click back
 */
-(void)goBack {
    [self hideKeyboard];
    
    if (self.saveButton.enabled) [ToastView showToastInParentView:self.windowView withText:@"Saved" withDuaration:1.5];
    self.saveButton.enabled = NO;
    [self.userObj saveInBackground];
    
    if (self.navigationController.viewControllers.count > 1) {
        NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
        
        if ([previousViewController isKindOfClass:MyPlaceReviewViewController.class]) {
            [(MyPlaceReviewViewController *)previousViewController reloadContent];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([previousViewController isKindOfClass:HomePageViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (self.navigationController.viewControllers.count >= 2){
            UIViewController *twoPreviousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-2];
            if ([twoPreviousViewController isKindOfClass:ChatViewController.class]) {
                ((ChatViewController *)twoPreviousViewController).userObj = self.userObj;
                [self.navigationController popToViewController:twoPreviousViewController animated:YES];
            } else [self.navigationController popViewControllerAnimated:YES];
        } else [self.navigationController popViewControllerAnimated:YES];
    } else {
        HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
        self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:homePageViewController, self, nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * Handle the case when user click on location edit
 */
-(void)goToLocationSearch {
    [self hideKeyboard];
    MyProfileLocationViewController *myProfileLocationViewController = [[MyProfileLocationViewController alloc] init];
    myProfileLocationViewController.userLocation = self.userObj[@"location"] ? self.userObj[@"location"] : @"";

    [self.navigationController pushViewController:myProfileLocationViewController animated:YES];
}

/**
* Set user's location
* @param SPGooglePlacesAutocompletePlace
*/
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)place {
    [place resolveToPlacemark:^(CLPlacemark *location, NSString *addressString, NSError *error) {
        [place getLocation:^(NSDictionary *location, NSString *addressString, NSError *error) {
            if (location[@"results"]) {
                NSArray *locations = location[@"results"];
                if (locations.count > 0) {
                    self.locationLabel.textColor = [FontColor titleColor];
                    NSDictionary *firstMatch = locations[0];
                    NSString *mLoc = firstMatch[@"formatted_address"] ? firstMatch[@"formatted_address"] : @"";
                    self.userObj[@"location"] = mLoc;
                    self.userObj[@"fullLocation"] = mLoc;
                    self.locationLabel.text = mLoc;
                    
                    NSDictionary *geometry = firstMatch[@"geometry"] ? firstMatch[@"geometry"] : nil;
                    NSDictionary *coordinate = (geometry && geometry[@"location"]) ? geometry[@"location"] : nil;
                    if (coordinate != nil && coordinate[@"lat"] && coordinate[@"lng"]) {
                        double lat = [coordinate[@"lat"] doubleValue];
                        double lng = [coordinate[@"lng"] doubleValue];
                        self.userObj[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
                    }
                    
                    [self.userObj saveInBackground];
                }
            }
        }];
    }];
}


@end
