//
//  MyStayRequestViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyStayRequestViewController.h"
#import "SquircleProfileImage.h"
#import "UnderLineButton.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PMCalendar.h"
#import "JGActionSheet.h"
#import "Device.h"
#import "UserManager.h"
#import "ChatViewController.h"
#import "MyUpcomingTripViewController.h"

static NSString * const TITLE_TEXT = @"Your stay request";
static NSString * const CANCEL_TEXT = @"Need to cancel your request? Click here";


static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

static NSString * NO_COVER_IMAGE = @"NoCoverImage";
static NSString * HEADER_MASK = @"PropertyImageMaskInverse";
static NSString * TRIP_LOCATION_ICON = @"TripLocationIcon";
static NSString * TRIP_DATE_ICON = @"TripDateIcon";
static NSString * TRIP_GUEST_ICON = @"TripGuestIcon";
static NSString * TRIP_INFO_ICON = @"TripInfoIcon";


@interface MyStayRequestViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *capturedBackgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *requestDateLabel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) TTTAttributedLabel *requestStatusLabel;
@property (nonatomic, strong) UIImageView *lowerMaskView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageBorderView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *propertyNameLabel;
@property (nonatomic, strong) UITextField *locationTextField;
@property (nonatomic, strong) UITextField *durationTextField;
@property (nonatomic, strong) UITextField *numGuestsTextField;
@property (nonatomic, strong) UITextField *purposeTextField;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) TTTAttributedLabel *cancelLabel;
@property (nonatomic, strong) JGActionSheet *cancelActionSheet;
@end

@implementation MyStayRequestViewController
#pragma mark - initiation
/**
 * Lazily init the captured background image view
 * @return UIImageView
 */
-(UIImageView *)capturedBackgroundView {
    if (_capturedBackgroundView == nil) {
        _capturedBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackgroundView.image = self.capturedBackground;
    }
    return _capturedBackgroundView;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.alpha = 0;
        _containerView.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.95];
    }
    return _containerView;
}

/**
 * Lazily init the title of the view
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        CGRect frame = CGRectMake(50, 40, self.screenWidth - 100, 30);
        if ([Device isIphone4]) frame = CGRectMake(50, 0, self.screenWidth - 100, 50);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = TITLE_TEXT;
    }
    return _titleLabel;
}

/**
 * Lazily init the date request is made label
 * @return UILabel
 */
-(UILabel *)requestDateLabel {
    if (_requestDateLabel == nil) {
        _requestDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, self.screenWidth - 100, 20)];
        _requestDateLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
        _requestDateLabel.textColor = [UIColor whiteColor];
        _requestDateLabel.textAlignment = NSTextAlignmentCenter;
        _requestDateLabel.text = [self.tripObj.createdAt dateStringWithFormat:@"MMM dd yyyy"];
        
        if ([Device isIphone4]) _requestDateLabel.hidden = YES;
    }
    return _requestDateLabel;
}

/**
 * Lazily init the content view
 * @return UIView
 */
-(UIView *)contentView {
    if (_contentView == nil) {
        CGRect frame = CGRectMake(45, 130, self.screenWidth - 90, 470);
        if ([Device isIphone4]) frame = CGRectMake(20, 50, self.screenWidth - 40, 380);
        if ([Device isIphone5]) frame = CGRectMake(20, 105, self.screenWidth - 40, 380);
        if ([Device isIphone6]) frame = CGRectMake(35, 130, self.screenWidth - 70, 410);
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [_contentView addGestureRecognizer:tapGesture];
    }
    return _contentView;
}

/**
 * Lazily init the property image
 * @return UIImageView
 */
-(UIImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 220);
        if ([Device isIphone4] || [Device isIphone5]) frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 130);
        if ([Device isIphone6]) frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 160);
        _propertyImageView = [[UIImageView alloc] initWithFrame:frame];
        _propertyImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString * coverPic = self.tripObj[@"place"][@"coverPic"] ? self.tripObj[@"place"][@"coverPic"] : @"";
        if (coverPic.length > 0) {
            NSString *url = [ImageUrl listingImageUrlFromUrl:coverPic];
            [_propertyImageView setImageWithURL:[NSURL URLWithString:url]];
        } else _propertyImageView.image = [UIImage imageNamed:NO_COVER_IMAGE];
    }
    return _propertyImageView;
}

/**
 * Lazily init the request status label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)requestStatusLabel {
    if (_requestStatusLabel == nil) {
        _requestStatusLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 100, 25, 100, 30)];
        _requestStatusLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _requestStatusLabel.textAlignment = NSTextAlignmentCenter;
        _requestStatusLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_requestStatusLabel.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                               cornerRadii:CGSizeMake(15, 15)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _requestStatusLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _requestStatusLabel.layer.mask = maskLayer;
        
        NSString *approvalState = self.tripObj[@"approval"] ? self.tripObj[@"approval"] : @"";
        _requestStatusLabel.hidden = NO;
        if ([approvalState isEqualToString:@"NO"]) {
            _requestStatusLabel.textColor = [UIColor whiteColor];
            _requestStatusLabel.backgroundColor = [FontColor descriptionColor];
            _requestStatusLabel.text = @"pending";
        } else if ([approvalState isEqualToString:@"YES"]) {
            _requestStatusLabel.textColor = [UIColor whiteColor];
            _requestStatusLabel.backgroundColor = [FontColor approveColor];
            _requestStatusLabel.text = @"approved";
        } else if ([approvalState isEqualToString:@"CANCEL"]) {
            _requestStatusLabel.textColor = [FontColor descriptionColor];
            _requestStatusLabel.backgroundColor = [FontColor defaultBackgroundColor];
            _requestStatusLabel.text = @"cancelled";
        } else _requestStatusLabel.hidden = YES;

    }
    return _requestStatusLabel;
}

/**
 * Lazily init the bottom mask
 * @return UIImageView
 */
-(UIImageView *)lowerMaskView {
    if (_lowerMaskView == nil) {
        CGFloat maskHeight = CGRectGetWidth(self.contentView.frame)/3.0;
        _lowerMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.propertyImageView.frame) - maskHeight/10.0, CGRectGetWidth(self.contentView.frame), maskHeight)];
        _lowerMaskView.contentMode = UIViewContentModeScaleAspectFill;
        _lowerMaskView.image = [UIImage imageNamed:HEADER_MASK];
    }
    return _lowerMaskView;
}

/**
 * Lazily init the profile image's border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)userProfileImageBorderView {
    if (_userProfileImageBorderView == nil) {
        _userProfileImageBorderView = [[SquircleProfileImage alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame) - 64)/2, CGRectGetMinY(self.lowerMaskView.frame) - 27, 64, 64)];
    }
    return _userProfileImageBorderView;
}

/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)userProfileImageView {
    if (_userProfileImageView == nil) {
        _userProfileImageView = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userProfileImageBorderView.frame) + 2, CGRectGetMinY(self.userProfileImageBorderView.frame) + 2, 60, 60)];
        NSString *profilePic = self.tripObj[@"host"][@"profilePic"] ? self.tripObj[@"host"][@"profilePic"] : @"";
        [_userProfileImageView setProfileImageWithUrl:profilePic];
    }
    return _userProfileImageView;
}

/**
 * Lazily init the user name's label
 * @return UILabel
 */
-(UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userProfileImageView.frame) + 10, CGRectGetWidth(self.contentView.frame) - 20, 25)];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.textColor = [FontColor titleColor];
        _userNameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
        _userNameLabel.text = [UserManager getUserNameFromUserObj:self.tripObj[@"host"]];
    }
    return _userNameLabel;
}

/**
 * Lazily init the property name's label
 * @return UILabel
 */
-(UILabel *)propertyNameLabel {
    if (_propertyNameLabel == nil) {
        _propertyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userNameLabel.frame), CGRectGetWidth(self.contentView.frame) - 20, 25)];
        _propertyNameLabel.textAlignment = NSTextAlignmentCenter;
        _propertyNameLabel.textColor = [FontColor themeColor];
        _propertyNameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _propertyNameLabel.text = self.tripObj[@"place"][@"name"];
    }
    return _propertyNameLabel;
}

/**
 * Lazily init the location text field
 * @return UITextField
 */
-(UITextField *)locationTextField {
    if (_locationTextField == nil) {
        CGFloat width = 250;
        if ([Device isIphone4] || [Device isIphone5]) width = 230;
        _locationTextField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame) - width)/2, CGRectGetMaxY(self.propertyNameLabel.frame) + 25, width, 20)];
        _locationTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _locationTextField.userInteractionEnabled = NO;
        _locationTextField.textColor = [FontColor descriptionColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TRIP_LOCATION_ICON]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_locationTextField setLeftView:iconImageView];
        _locationTextField.leftView.frame = CGRectMake(0, 0, 20, 20);
        _locationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        //set the location
        NSString *location = [[NSString alloc] initWithFormat:@"   %@", self.tripObj[@"place"][@"location"]];
        _locationTextField.text = location;
        CGSize expectSize = [_locationTextField sizeThatFits:CGSizeMake(FLT_MAX, 20)];
        if (expectSize.width > width) {
            NSMutableArray *locationComponents = [[NSMutableArray alloc] initWithArray:[location componentsSeparatedByString:@","]];
            
            if (locationComponents.count <= 2) _locationTextField.text = [[location componentsSeparatedByString:@","] firstObject];
            else {
                [locationComponents removeLastObject];
                NSString *newLocation = [locationComponents componentsJoinedByString:@","];
                _locationTextField.text = newLocation;
                
                expectSize = [_locationTextField sizeThatFits:CGSizeMake(FLT_MAX, 20)];
                if (expectSize.width > width) _locationTextField.text = [[location componentsSeparatedByString:@","] firstObject];
            }
        }

    }
    return _locationTextField;
}

/**
 * Lazily init duration text field
 * @return UITextField
 */
-(UITextField *)durationTextField {
    if (_durationTextField == nil) {
        CGFloat width = 250;
        if ([Device isIphone4] || [Device isIphone5]) width = 230;

        _durationTextField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame) - width)/2, CGRectGetMaxY(self.locationTextField.frame) + 10, width, 20)];
        _durationTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _durationTextField.userInteractionEnabled = NO;
        _durationTextField.textColor = [FontColor descriptionColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TRIP_DATE_ICON]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_durationTextField setLeftView:iconImageView];
        _durationTextField.leftView.frame = CGRectMake(0, 0, 20, 20);
        _durationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        //set the date
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormat dateFromString:self.tripObj[@"startDate"]];
        NSDate *endDate = [dateFormat dateFromString:self.tripObj[@"endDate"]];
        _durationTextField.text = [NSString stringWithFormat:@"   %@ - %@", [startDate dateStringWithFormat:@"MMM dd yyyy"], [endDate dateStringWithFormat:@"MMM dd yyyy"]];
    }
    return _durationTextField;
}

/**
 * Lazily init the number of guest text field
 * @return UITextField
 */
-(UITextField *)numGuestsTextField {
    if (_numGuestsTextField == nil) {
        CGFloat width = 250;
        if ([Device isIphone4] || [Device isIphone5]) width = 230;

        _numGuestsTextField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame) - width)/2, CGRectGetMaxY(self.durationTextField.frame) + 10, width, 20)];
        _numGuestsTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _numGuestsTextField.userInteractionEnabled = NO;
        _numGuestsTextField.textColor = [FontColor descriptionColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TRIP_GUEST_ICON]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_numGuestsTextField setLeftView:iconImageView];
        _numGuestsTextField.leftView.frame = CGRectMake(0, 0, 20, 20);
        _numGuestsTextField.leftViewMode = UITextFieldViewModeAlways;
        
        //set the number of guest
        int numGuests = [self.tripObj[@"numGuests"] intValue];
        if (numGuests <= 1) _numGuestsTextField.text = [NSString stringWithFormat:@"   %d person", numGuests];
        else _numGuestsTextField.text = [NSString stringWithFormat:@"   %d people", numGuests];
    }
    return _numGuestsTextField;
}

/**
 * Lazily init the purpose of the travel text field
 * @return UITextField
 */
-(UITextField *)purposeTextField {
    if (_purposeTextField == nil) {
        CGFloat width = 250;
        if ([Device isIphone4] || [Device isIphone5]) width = 230;

        _purposeTextField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame) - width)/2, CGRectGetMaxY(self.numGuestsTextField.frame) + 10, width, 20)];
        _purposeTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _purposeTextField.userInteractionEnabled = NO;
        _purposeTextField.textColor = [FontColor descriptionColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TRIP_INFO_ICON]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_purposeTextField setLeftView:iconImageView];
        _purposeTextField.leftView.frame = CGRectMake(0, 0, 20, 20);
        _purposeTextField.leftViewMode = UITextFieldViewModeAlways;
        
        NSString *reason = self.tripObj[@"reason"] ? self.tripObj[@"reason"] : @"Recreational travel";
        _purposeTextField.text = [[NSString alloc] initWithFormat:@"   %@", reason];
    }
    return _purposeTextField;
}

/**
 * Lazily init the cross closing button
 * @return UIButton
 */
-(UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 50, 0, 50, 50)];
        [_closeButton setImage:[UIImage imageNamed:CLOSE_BUTTON_NORMAL_IMAGE] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:CLOSE_BUTTON_HIGHLIGHT_IMAGE] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/**
 * Lazily init the cancelLabel
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)cancelLabel {
    if (_cancelLabel == nil) {
        _cancelLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.screenHeight - 40, self.screenWidth, 20)];
        _cancelLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        _cancelLabel.textColor = [UIColor whiteColor];
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.text = CANCEL_TEXT;
        _cancelLabel.delegate = self;
        _cancelLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName:[UIColor whiteColor],
                                        (id)kCTFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12]};
        NSRange range = [CANCEL_TEXT rangeOfString:@"Click here"];
        [_cancelLabel addLinkToURL:[NSURL URLWithString:@"action://cancel"] withRange:range];
        
        if ([self.tripObj[@"approval"] isEqualToString:@"CANCEL"]) _cancelLabel.hidden = YES;
    }
    return _cancelLabel;
}

/**
 * Lazily init the cancel action sheet
 * @return JGActionSheet
 */
-(JGActionSheet *)cancelActionSheet {
    if (_cancelActionSheet == nil) {
        JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel stay request"] buttonStyle:JGActionSheetButtonStyleDefault];
        
        JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Back"] buttonStyle:JGActionSheetButtonStyleCancel];
        
        _cancelActionSheet = [JGActionSheet actionSheetWithSections:@[section1, cancelSection]];
        
        __weak typeof(self) weakSelf = self;
        [_cancelActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if (indexPath.section == 0) {
                [sheet dismissAnimated:YES];
                weakSelf.tripObj[@"approval"]= @"CANCEL";
                [weakSelf.tripObj saveInBackground];
                
                NSInteger currentViewControllerIndex = [weakSelf.navigationController.viewControllers indexOfObject:weakSelf];
                UIViewController *prevViewController = weakSelf.navigationController.viewControllers[currentViewControllerIndex - 1];
                if ([prevViewController isKindOfClass:ChatViewController.class]) {
                    [(ChatViewController *)prevViewController sendMessage:weakSelf.tripObj.objectId withType:MESSAGE_TYPE_CANCEL];
                } else if ([prevViewController isKindOfClass:MyUpcomingTripViewController.class]) {
                    [(MyUpcomingTripViewController *)prevViewController sendTripResponseForTrip:weakSelf.tripObj withType:MESSAGE_TYPE_CANCEL];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } [sheet dismissAnimated:YES];
        }];
    }
    return _cancelActionSheet;
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self capturedBackgroundView]];
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self titleLabel]];
    [self.containerView addSubview:[self requestDateLabel]];
    
    [self.containerView addSubview:[self contentView]];
    [self.contentView addSubview:[self propertyImageView]];
    [self.contentView addSubview:[self requestStatusLabel]];
    [self.contentView addSubview:[self lowerMaskView]];
    [self.contentView addSubview:[self userProfileImageBorderView]];
    [self.contentView addSubview:[self userProfileImageView]];
    [self.contentView addSubview:[self userNameLabel]];
    [self.contentView addSubview:[self propertyNameLabel]];
    [self.contentView addSubview:[self locationTextField]];
    [self.contentView addSubview:[self durationTextField]];
    [self.contentView addSubview:[self numGuestsTextField]];
    [self.contentView addSubview:[self purposeTextField]];
    
    [self.view addSubview:[self closeButton]];
    [self.view addSubview:[self cancelLabel]];
    
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    tapOutside.cancelsTouchesInView = NO;
    [self.containerView addGestureRecognizer:tapOutside];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.alpha = 1;
    }];
}

#pragma mark - gesture recognizer
/**
 * Handle the behavior when user wish to go back to previous screen
 */
-(void)goBack {
    [UIView animateWithDuration:0.3 animations:^{
        self.closeButton.alpha = 0;
        self.containerView.alpha = 0;
        self.cancelLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) [self.navigationController popViewControllerAnimated:NO];
    }];
}

/**
 * TTTAttributesLabel delegate
 * Handle the behavior when user click on the login label
 */
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[self cancelActionSheet] showInView:self.view animated:YES];
}

@end
