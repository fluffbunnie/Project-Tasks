//
//  GuidedInteractionDetailView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionDetailView.h"
#import "SquircleProfileImage.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "UIVerticalButton.h"

static NSString *LISTING_INFO_BEDROOM_GRAY = @"ListingInfoBedroomGray";
static NSString *LISTING_INFO_BATHROOM_GRAY = @"ListingInfoBathGray";
static NSString *LISTING_INFO_BED_GRAY = @"ListingInfoBedGray";
static NSString *LISTING_INFO_GUEST_GRAY = @"ListingInfoGuestGray";

static NSString * const PROPERTY_IMAGE_MASK = @"PropertyImageMask";
static NSString * const BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

static NSString * const FIRST_PROPERTY_IMAGE = @"OnboardingCurrentPropertyImage";
static NSString * const FIRST_USER_IMAGE = @"OnboardingCurrentProfileImage";
static NSString * const NEXT_PROPERTY_IMAGE = @"OnboardingNextPropertyImage";
static NSString * const NEXT_USER_IMAGE = @"OnboardingNextProfileImage";
static NSString * const PREV_PROPERTY_IMAGE = @"OnboardingPrevPropertyImage";
static NSString * const PREV_PROFILE_IMAGE = @"OnboardingPrevProfileImage";

@interface GuidedInteractionDetailView()
@property (nonatomic, assign) int viewIndex;

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) UIImageView *backButton;
@property (nonatomic, strong) UILabel *pageNumber;
@property (nonatomic, strong) SquircleProfileImage *profileImageBorder;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) TTTAttributedLabel *userDescription;
@property (nonatomic, strong) UILabel *houseName;
@property (nonatomic, strong) UILabel *houseType;

@property (nonatomic, strong) UIButton *numBedroomButton;
@property (nonatomic, strong) UIButton *numBathButton;
@property (nonatomic, strong) UIButton *numBedButton;
@property (nonatomic, strong) UIButton *numGuestButton;

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation GuidedInteractionDetailView
#pragma mark - initiation
/**
 * Lazily init the property image view
 * @return UIImageView
 */
-(UIImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        _propertyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight)];
        _propertyImageView.clipsToBounds = YES;
        _propertyImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.viewIndex == 1) _propertyImageView.image = [UIImage imageNamed:NEXT_PROPERTY_IMAGE];
        else if (self.viewIndex == -1) _propertyImageView.image = [UIImage imageNamed:PREV_PROPERTY_IMAGE];
        else _propertyImageView.image = [UIImage imageNamed:FIRST_PROPERTY_IMAGE];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:PROPERTY_IMAGE_MASK] CGImage];
        maskLayer.frame = CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight);
        _propertyImageView.layer.mask = maskLayer;
        _propertyImageView.layer.masksToBounds = YES;

    }
    return _propertyImageView;
}

/**
 * Lazily init the back button image
 * @return UIImageView
 */
-(UIImageView *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
        _backButton.contentMode = UIViewContentModeScaleAspectFit;
        _backButton.image = [UIImage imageNamed:BACK_BUTTON_IMAGE_NORMAL];
    }
    return _backButton;
}

/**
 * Lazily init the page number
 * @return UIlabel
 */
-(UILabel *)pageNumber {
    if (_pageNumber == nil) {
        _pageNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 30, 50, 25)];
        _pageNumber.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        _pageNumber.textAlignment = NSTextAlignmentCenter;
        _pageNumber.textColor = [UIColor whiteColor];
        _pageNumber.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        if (self.viewIndex == 1) _pageNumber.text = @"1/33";
        else if (self.viewIndex == -1) _pageNumber.text = @"1/27";
        else if (self.viewIndex == 0) _pageNumber.text = @"1/22";
    }
    return _pageNumber;
}

/**
 * Lazily init the profile image's border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImageBorder {
    if (_profileImageBorder == nil) {
        _profileImageBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(0.42 * self.viewWidth - 3, 0.5 * self.viewHeight - 30, 0.16 * self.viewWidth + 6, 0.16 * self.viewWidth + 6)];
    }
    return _profileImageBorder;
}

/**
 * Lazily init the profile picture
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        CGRect borderFrame = self.profileImageBorder.frame;
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(CGRectGetMinX(borderFrame) + 3, CGRectGetMinY(borderFrame) + 3, CGRectGetWidth(borderFrame) - 6, CGRectGetHeight(borderFrame) - 6)];
        if (self.viewIndex == 1) [_profileImage setImage:[UIImage imageNamed:NEXT_USER_IMAGE]];
        else if (self.viewIndex == -1) [_profileImage setImage:[UIImage imageNamed:PREV_PROFILE_IMAGE]];
        else [_profileImage setImage:[UIImage imageNamed:FIRST_USER_IMAGE]];
    }
    return _profileImage;
}

/**
 * Lazily init the user name
 * @return UILabel
 */
-(UILabel *)userName {
    if (_userName == nil) {
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.profileImageBorder.frame) + 10, self.viewWidth - 40, 24)];
        
        _userName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _userName.textColor = [FontColor titleColor];
        _userName.numberOfLines = 1;
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if (self.viewIndex == 1) _userName.text = HUONG_NAME;
        else if (self.viewIndex == -1) _userName.text = KAT_NAME;
        else _userName.text = MINH_NAME;
    }
    return _userName;
}

/**
 * Lazily init the user description
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)userDescription {
    if (_userDescription == nil) {
        _userDescription = [[TTTAttributedLabel alloc] init];
        _userDescription.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _userDescription.textColor = [FontColor titleColor];
        _userDescription.numberOfLines = 0;
        _userDescription.lineSpacing = 5;
        if (self.viewIndex == 1) _userDescription.text = HUONG_DESCRIPTION;
        else if (self.viewIndex == -1) _userDescription.text = MINH_DESCRIPTION;
        else _userDescription.text = KATERINA_DESCRIPTION;
        
        CGFloat height = [_userDescription sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)].height;
        _userDescription.frame = CGRectMake(25, CGRectGetMaxY(self.userName.frame) + 15, self.viewWidth - 50, height);
    }
    return _userDescription;
}

/**
 * Lazily init house name
 * @return UILabel
 */
-(UILabel *)houseName {
    if (_houseName == nil) {
        _houseName = [[UILabel alloc] init];
        _houseName.textAlignment = NSTextAlignmentCenter;
        _houseName.textColor = [FontColor themeColor];
        _houseName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _houseName.numberOfLines = 0;
        if (self.viewIndex == 1) _houseName.text = HUONG_HOME_TITLE;
        else if (self.viewIndex == -1) _houseName.text = KAT_HOME_TITLE;
        else _houseName.text = MINH_HOME_TITLE;
        
        CGFloat height =  [_houseName sizeThatFits:CGSizeMake(self.viewWidth - 70, FLT_MAX)].height;
        _houseName.frame = CGRectMake(35, CGRectGetMaxY(self.userDescription.frame) + 20, self.viewWidth - 70, height);
    }
    return _houseName;
}

/**
 * Lazily init the house type
 * @return UILabel
 */
-(UILabel *)houseType {
    if (_houseType == nil) {
        _houseType = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.houseName.frame), self.viewWidth, 25)];
        _houseType.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _houseType.textColor = [FontColor descriptionColor];
        _houseType.textAlignment = NSTextAlignmentCenter;
    
        if (self.viewIndex == 1) _houseType.text = @"Entire space";
        else if (self.viewIndex == -1) _houseType.text = @"Private space";
        else _houseType.text = @"Entire space";
    }
    return _houseType;
}

/**
 * Lazily init the number of bedroom button
 * @return UIButton
 */
-(UIButton *)numBedroomButton {
    if (_numBedroomButton == nil) {
        _numBedroomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.houseType.frame) + 20, self.viewWidth/4, 50)];
        _numBedroomButton.userInteractionEnabled = NO;
        _numBedroomButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBedroomButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBedroomButton setImage:[UIImage imageNamed:LISTING_INFO_BEDROOM_GRAY] forState:UIControlStateNormal];
        
        if (self.viewIndex == 1) [_numBedroomButton setTitle:@"2" forState:UIControlStateNormal];
        else if (self.viewIndex == -1) [_numBedroomButton setTitle:@"1" forState:UIControlStateNormal];
        else [_numBedroomButton setTitle:@"2" forState:UIControlStateNormal];
        [_numBedroomButton centerVerticallyWithPadding:8];
    }
    return _numBedroomButton;
}

/**
 * Lazily init the number of baths button
 * @return UIButton
 */
-(UIButton *)numBathButton {
    if (_numBathButton == nil) {
        _numBathButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth/4, CGRectGetMaxY(self.houseType.frame) + 20, self.viewWidth/4, 50)];
        _numBathButton.userInteractionEnabled = NO;
        _numBathButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBathButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBathButton setImage:[UIImage imageNamed:LISTING_INFO_BATHROOM_GRAY] forState:UIControlStateNormal];
        
        if (self.viewIndex == 1) [_numBathButton setTitle:@"1" forState:UIControlStateNormal];
        else if (self.viewIndex == -1) [_numBathButton setTitle:@"1" forState:UIControlStateNormal];
        else [_numBathButton setTitle:@"1.5" forState:UIControlStateNormal];
        [_numBathButton centerVerticallyWithPadding:8];

    }
    return _numBathButton;
}

/**
 * Lazily init the number of beds button
 * @return UIButton
 */
-(UIButton *)numBedButton {
    if (_numBedButton == nil) {
        _numBedButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth/2, CGRectGetMaxY(self.houseType.frame) + 20, self.viewWidth/4, 50)];
        _numBedButton.userInteractionEnabled = NO;
        _numBedButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBedButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBedButton setImage:[UIImage imageNamed:LISTING_INFO_BED_GRAY] forState:UIControlStateNormal];
        
        if (self.viewIndex == 1) [_numBedButton setTitle:@"3" forState:UIControlStateNormal];
        else if (self.viewIndex == -1) [_numBedButton setTitle:@"2" forState:UIControlStateNormal];
        else [_numBedButton setTitle:@"2" forState:UIControlStateNormal];
        [_numBedButton centerVerticallyWithPadding:8];

    }
    return _numBedButton;
}

/**
 * Lazily init the number of guests button
 * @return UIButton
 */
-(UIButton *)numGuestButton {
    if (_numGuestButton == nil) {
        _numGuestButton = [[UIButton alloc] initWithFrame:CGRectMake(3 * self.viewWidth/4, CGRectGetMaxY(self.houseType.frame) + 20, self.viewWidth/4, 50)];
        _numGuestButton.userInteractionEnabled = NO;
        _numGuestButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numGuestButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numGuestButton setImage:[UIImage imageNamed:LISTING_INFO_GUEST_GRAY] forState:UIControlStateNormal];
        
        if (self.viewIndex == 1) [_numGuestButton setTitle:@"5" forState:UIControlStateNormal];
        else if (self.viewIndex == -1) [_numGuestButton setTitle:@"3" forState:UIControlStateNormal];
        else [_numGuestButton setTitle:@"4" forState:UIControlStateNormal];
        [_numGuestButton centerVerticallyWithPadding:8];

    }
    return _numGuestButton;
}

/**
 * Lazily init the button's container view
 * @return UIView
 */
-(UIView *)buttonContainerView {
    if (_buttonContainerView == nil) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 50, self.viewWidth, 50)];
        _buttonContainerView.backgroundColor = [FontColor greenThemeColor];
    }
    return _buttonContainerView;
}

/**
 * Lazily init the message button
 * @return UIButton
 */
-(UIButton *)messageButton {
    if (_messageButton == nil) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_messageButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_messageButton setImage:[UIImage imageNamed:@"MessageButtonNormal"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"MessageButtonNormal"] forState:UIControlStateHighlighted];
    }
    return _messageButton;
}

/**
 * Lazily init the book button
 * @return UIButton
 */
-(UIButton *)bookButton {
    if (_bookButton == nil) {
        _bookButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, self.viewWidth - 100, 50)];
        [_bookButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_bookButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        _bookButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_bookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookButton setTitle:@"Request free stay" forState:UIControlStateNormal];
    }
    return _bookButton;
}

/**
 * Lazily init the like button
 * @return UIButton
 */
-(UIButton *)likeButton {
    if (_likeButton == nil) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth - 50, 0, 50, 50)];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        _likeButton.hidden = YES;
    }
    return _likeButton;
}



#pragma mark - public method
-(id)initWithIndex:(int)index {
    self.viewIndex = index;
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    self = [super initWithFrame:CGRectMake(0, self.viewHeight, self.viewWidth, self.viewHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self propertyImageView]];
        [self addSubview:[self backButton]];
        [self addSubview:[self pageNumber]];
        [self addSubview:[self profileImageBorder]];
        [self addSubview:[self profileImage]];
        [self addSubview:[self userName]];
        [self addSubview:[self userDescription]];
        [self addSubview:[self houseName]];
        [self addSubview:[self houseType]];
        
        [self addSubview:[self numBedroomButton]];
        [self addSubview:[self numBathButton]];
        [self addSubview:[self numBedButton]];
        [self addSubview:[self numGuestButton]];
        
        [self addSubview:[self buttonContainerView]];
        [self.buttonContainerView addSubview:[self messageButton]];
        [self.buttonContainerView addSubview:[self bookButton]];
        [self.buttonContainerView addSubview:[self likeButton]];
        
    }
    return self;
}

-(id)initFromOriginWithIndex:(int)index {
    self.viewIndex = index;
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self propertyImageView]];
        [self addSubview:[self backButton]];
        [self addSubview:[self pageNumber]];
        [self addSubview:[self profileImageBorder]];
        [self addSubview:[self profileImage]];
        [self addSubview:[self userName]];
        [self addSubview:[self userDescription]];
        [self addSubview:[self houseName]];
        [self addSubview:[self houseType]];
        
        [self addSubview:[self numBedroomButton]];
        [self addSubview:[self numBathButton]];
        [self addSubview:[self numBedButton]];
        [self addSubview:[self numGuestButton]];
        
        [self addSubview:[self buttonContainerView]];
        [self.buttonContainerView addSubview:[self messageButton]];
        [self.buttonContainerView addSubview:[self bookButton]];
        [self.buttonContainerView addSubview:[self likeButton]];
        
    }
    return self;
}

@end
