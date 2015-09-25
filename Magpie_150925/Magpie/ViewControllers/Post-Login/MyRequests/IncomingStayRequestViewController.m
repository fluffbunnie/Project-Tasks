//
//  IncomingStayRequestViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "IncomingStayRequestViewController.h"
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

static NSString * const TITLE_TEXT = @"%@'s stay request";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

static NSString * NO_COVER_IMAGE = @"NoCoverImage";
static NSString * HEADER_MASK = @"PropertyImageMaskInverse";
static NSString * TRIP_LOCATION_ICON = @"TripLocationIcon";
static NSString * TRIP_DATE_ICON = @"TripDateIcon";
static NSString * TRIP_GUEST_ICON = @"TripGuestIcon";
static NSString * TRIP_INFO_ICON = @"TripInfoIcon";


@interface IncomingStayRequestViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *capturedBackgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageBorderView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *requestDateLabel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) UILabel *propertyNameLabel;
@property (nonatomic, strong) UITextField *locationTextField;
@property (nonatomic, strong) UITextField *durationTextField;
@property (nonatomic, strong) UITextField *numGuestsTextField;
@property (nonatomic, strong) UITextField *purposeTextField;
@property (nonatomic, strong) UIButton *approveButton;

@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation IncomingStayRequestViewController
#pragma mark - initation
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
 * Lazily init the profile image border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)userProfileImageBorderView {
    if (_userProfileImageBorderView == nil) {
        CGRect frame = CGRectMake((self.screenWidth - 69)/2, 30, 69, 69);
        if ([Device isIphone4]) frame = CGRectMake((self.screenWidth - 60)/2, 10, 60, 60);
        if ([Device isIphone5]) frame = CGRectMake((self.screenWidth - 69)/2, 10, 69, 69);
        _userProfileImageBorderView = [[SquircleProfileImage alloc] initWithFrame:frame];
    }
    return _userProfileImageBorderView;
}

/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)userProfileImageView {
    if (_userProfileImageView == nil) {
        _userProfileImageView = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userProfileImageBorderView.frame) + 2, CGRectGetMinY(self.userProfileImageBorderView.frame) + 2, CGRectGetWidth(self.userProfileImageBorderView.frame) - 4, CGRectGetHeight(self.userProfileImageBorderView.frame) - 4)];
        NSString *profilePic = self.tripObj[@"guest"][@"profilePic"] ? self.tripObj[@"guest"][@"profilePic"] : @"";
        [_userProfileImageView setProfileImageWithUrl:profilePic];
    }
    return _userProfileImageView;
}

/**
 * Lazily init the title of the view
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.userProfileImageView.frame) + 10, self.screenWidth, 30);
        if ([Device isIphone4]) frame = CGRectMake(0, 75, self.screenWidth, 30);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [NSString stringWithFormat:TITLE_TEXT, [UserManager getUserNameFromUserObj:self.tripObj[@"guest"]]];
    }
    return _titleLabel;
}

/**
 * Lazily init the date request is made label
 * @return UILabel
 */
-(UILabel *)requestDateLabel {
    if (_requestDateLabel == nil) {
        _requestDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.screenWidth, 20)];
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
        CGRect frame = CGRectMake(45, CGRectGetMaxY(self.titleLabel.frame) + 50, self.screenWidth - 90, 470);
        if ([Device isIphone4]) frame = CGRectMake(20, 110, self.screenWidth - 40, 360);
        if ([Device isIphone5]) frame = CGRectMake(20, CGRectGetMaxY(self.requestDateLabel.frame) + 10, self.screenWidth - 40, 380);
        if ([Device isIphone6]) frame = CGRectMake(35, CGRectGetMaxY(self.titleLabel.frame) + 50, self.screenWidth - 70, 410);
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
        if ([Device isIphone4]) frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 110);
        if ([Device isIphone5]) frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 130);
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
 * Lazily init the property name's label
 * @return UILabel
 */
-(UILabel *)propertyNameLabel {
    if (_propertyNameLabel == nil) {
        _propertyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.propertyImageView.frame) + 17, CGRectGetWidth(self.contentView.frame) - 20, 25)];
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
 * Lazily init the approve button
 * @return UIButton
 */
-(UIButton *)approveButton {
    if (_approveButton == nil) {
        _approveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 50, CGRectGetWidth(self.contentView.frame), 50)];
        _approveButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_approveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_approveButton setBackgroundImage:[FontColor imageWithColor:[FontColor defaultBackgroundColor]] forState:UIControlStateDisabled];
        
        //set the state of approval button
        NSString *approvalState = self.tripObj[@"approval"] ? self.tripObj[@"approval"] : @"";
        if ([approvalState isEqualToString:@"NO"]) {
            [_approveButton setTitle:@"Approve" forState:UIControlStateNormal];
            [_approveButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
            [_approveButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        } else if ([approvalState isEqualToString:@"YES"]) {
            [_approveButton setTitle:@"Approved" forState:UIControlStateDisabled];
            _approveButton.enabled = NO;
        } else if ([approvalState isEqualToString:@"CANCEL"]) {
            [_approveButton setTitle:@"Canceled" forState:UIControlStateDisabled];
            _approveButton.enabled = NO;
        }
        
        [_approveButton addTarget:self action:@selector(approveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _approveButton;
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

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self capturedBackgroundView]];
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self userProfileImageBorderView]];
    [self.containerView addSubview:[self userProfileImageView]];
    [self.containerView addSubview:[self titleLabel]];
    [self.containerView addSubview:[self requestDateLabel]];
    
    [self.containerView addSubview:[self contentView]];
    [self.contentView addSubview:[self propertyImageView]];
    [self.contentView addSubview:[self propertyNameLabel]];
    [self.contentView addSubview:[self locationTextField]];
    [self.contentView addSubview:[self durationTextField]];
    [self.contentView addSubview:[self numGuestsTextField]];
    [self.contentView addSubview:[self purposeTextField]];
    [self.contentView addSubview:[self approveButton]];
    
    [self.view addSubview:[self closeButton]];

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
    } completion:^(BOOL finished) {
        if (finished) [self.navigationController popViewControllerAnimated:NO];
    }];
}

/**
 * Handle the behavior when user click on the approved button
 */
-(void)approveButtonClick {
    self.tripObj[@"approval"]= @"YES";
    [self.tripObj saveInBackground];
    
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    UIViewController *prevViewController = self.navigationController.viewControllers[currentViewControllerIndex - 1];
    if ([prevViewController isKindOfClass:ChatViewController.class]) {
        [(ChatViewController *)prevViewController sendMessage:self.tripObj.objectId withType:MESSAGE_TYPE_CONFIRM];
    } else if ([prevViewController isKindOfClass:MyUpcomingTripViewController.class]) {
        [(MyUpcomingTripViewController *)prevViewController sendTripResponseForTrip:self.tripObj withType:MESSAGE_TYPE_CONFIRM];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
