//
//  HostPopup.m
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HostPopup.h"
#import "SquircleProfileImage.h"
#import "UnderLineButton.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PMCalendar.h"
#import "RoundButton.h"
#import "UserManager.h"
#import "ParseConstant.h"

static NSString * const LOADING_TEXT = @"Please wait";
static NSString * const TRIP_TITLE = @"%@'s stay request";
static NSString * const CANCEL_TEXT = @"Need to cancel your request? Click here";

static NSString * TRIP_LOCATION_ICON = @"TripLocationIcon";
static NSString * TRIP_PLACE_TYPE_ENTIRE_PLACE_ICON = @"TripPlaceTypeEntirePlaceIcon";
static NSString * TRIP_PLACE_TYPE_PRIVATE_SPACE_ICON = @"TripPlaceTypePrivateSpaceIcon";
static NSString * TRIP_PLACE_TYPE_SHARED_SPACE_ICON = @"TripPlaceTypeSharedSpaceIcon";
static NSString * TRIP_DATE_ICON = @"TripDateIcon";
static NSString * TRIP_GUEST_ICON = @"TripGuestIcon";

@interface HostPopup()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) PFObject *tripObj;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *tripTitle;
@property (nonatomic, strong) UIImageView *tripLocationIcon;
@property (nonatomic, strong) UILabel *tripLocationLabel;
@property (nonatomic, strong) UIImageView *tripPlaceTypeIcon;
@property (nonatomic, strong) UILabel *tripPlaceTypeLabel;
@property (nonatomic, strong) UIImageView *tripDateIcon;
@property (nonatomic, strong) UILabel *tripDateLabel;
@property (nonatomic, strong) UIImageView *tripGuestIcon;
@property (nonatomic, strong) UILabel *tripGuestLabel;
@property (nonatomic, strong) RoundButton *approveButton;

@property (nonatomic, strong) SquircleProfileImage *guestProfileBorder;
@property (nonatomic, strong) SquircleProfileImage *guestProfilePhoto;
@property (nonatomic, strong) UnderLineButton *closeButton;

@end

@implementation HostPopup
#pragma mark - initiation
/**
 * Lazily init the loading view
 * @return UIView
 */
-(UIView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewWidth)];
    }
    return _loadingView;
}

/**
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 143)/2, self.viewHeight/2 - 40, 143, 80)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"Loading" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the loading text
 * @return UILabel
 */
-(UILabel *)loadingText {
    if (_loadingText == nil) {
        _loadingText = [[UILabel alloc] init];
        _loadingText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _loadingText.text = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
        _loadingText.textColor = [UIColor whiteColor];
        CGSize size = [_loadingText sizeThatFits:CGSizeMake(self.viewWidth, self.viewHeight)];
        _loadingText.frame = CGRectMake((self.viewWidth - size.width)/2 - 1, self.viewHeight/2 + 50, size.width + 10, size.height);
    }
    return _loadingText;
}

/**
 * Lazily init the content view
 * @return UIView
 */
-(UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.viewHeight - 360) / 2, self.viewWidth - 40, 360)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.clipsToBounds = YES;
        _contentView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

/**
 * Lazily init the trip title
 * @return UILabel
 */
-(UILabel *)tripTitle {
    if (_tripTitle == nil) {
        _tripTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.viewWidth - 40, 30)];
        _tripTitle.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _tripTitle.textColor = [FontColor titleColor];
        _tripTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _tripTitle;
}

/**
 * Lazily init the trip location icon
 * @return UIImageView
 */
-(UIImageView *)tripLocationIcon {
    if (_tripLocationIcon == nil) {
        _tripLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 110, 25, 20)];
        _tripLocationIcon.contentMode = UIViewContentModeScaleAspectFit;
        _tripLocationIcon.image = [UIImage imageNamed:TRIP_LOCATION_ICON];
    }
    return _tripLocationIcon;
}

/**
 * Lazily init the trip location label
 * @return UILabel
 */
-(UILabel *)tripLocationLabel {
    if (_tripLocationLabel == nil) {
        _tripLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripLocationIcon.frame) + 20, 110, 205, 21)];
        _tripLocationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _tripLocationLabel.textColor = [FontColor descriptionColor];
    }
    return _tripLocationLabel;
}

/**
 * Lazily init the trip place type icon
 * @return UIImageView
 */
-(UIImageView *)tripPlaceTypeIcon {
    if (_tripPlaceTypeIcon == nil) {
        _tripPlaceTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 150, 25, 20)];
        _tripPlaceTypeIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tripPlaceTypeIcon;
}

/**
 * Lazily init the trip place type label
 * @return UILabel
 */
-(UILabel *)tripPlaceTypeLabel {
    if (_tripPlaceTypeLabel == nil) {
        _tripPlaceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripPlaceTypeIcon.frame) + 20, 150, 205, 20)];
        _tripPlaceTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _tripPlaceTypeLabel.textColor = [FontColor descriptionColor];
    }
    return _tripPlaceTypeLabel;
}

/**
 * Lazily init the trip date icon
 * @return UIImageView
 */
-(UIImageView *)tripDateIcon {
    if (_tripDateIcon == nil) {
        _tripDateIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 190, 25, 20)];
        _tripDateIcon.contentMode = UIViewContentModeScaleAspectFit;
        _tripDateIcon.image = [UIImage imageNamed:TRIP_DATE_ICON];
    }
    return _tripDateIcon;
}

/**
 * Lazily init the trip date label
 * @return UILabel
 */
-(UILabel *)tripDateLabel {
    if (_tripDateLabel == nil) {
        _tripDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripGuestIcon.frame) + 20, 190, 205, 20)];
        _tripDateLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _tripDateLabel.textColor = [FontColor descriptionColor];
    }
    return _tripDateLabel;
}

/**
 * Lazily init the trip date icon
 * @return UIImageView
 */
-(UIImageView *)tripGuestIcon {
    if (_tripGuestIcon == nil) {
        _tripGuestIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 230, 25, 20)];
        _tripGuestIcon.contentMode = UIViewContentModeScaleAspectFit;
        _tripGuestIcon.image = [UIImage imageNamed:TRIP_GUEST_ICON];
    }
    return _tripGuestIcon;
}

/**
 * Lazily init the trip guest label
 * @return UILabel
 */
-(UILabel *)tripGuestLabel {
    if (_tripGuestLabel == nil) {
        _tripGuestLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripGuestIcon.frame) + 20, 230, 205, 20)];
        _tripGuestLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _tripGuestLabel.textColor = [FontColor descriptionColor];
    }
    return _tripGuestLabel;
}

/**
 * Lazily init the approve button
 * @return RoundButton
 */
-(RoundButton *)approveButton {
    if (_approveButton == nil) {
        _approveButton = [[RoundButton alloc] initWithFrame:CGRectMake(35, 280, self.viewWidth - 110, 50)];
        [_approveButton setTitle:@"Approve" forState:UIControlStateNormal];
        [_approveButton addTarget:self action:@selector(approveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _approveButton;
}

/**
 * Lazily init the guest profile's picture border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)guestProfileBorder {
    if (_guestProfileBorder == nil) {
        _guestProfileBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake((self.viewWidth - 60)/2 - 2 , CGRectGetMinY(self.contentView.frame) - 32, 64, 64)];
        _guestProfileBorder.alpha = 0;
    }
    return _guestProfileBorder;
}

/**
 * Lazily init the guest profile's picture
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)guestProfilePhoto {
    if (_guestProfilePhoto == nil) {
        _guestProfilePhoto = [[SquircleProfileImage alloc] initWithFrame:CGRectMake((self.viewWidth - 60)/2, CGRectGetMinY(self.contentView.frame) - 30, 60, 60)];
        _guestProfilePhoto.alpha = 0;
    }
    return _guestProfilePhoto;
}

/**
 * Lazily init the close button
 * @return UnderLineButton
 */
-(UnderLineButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UnderLineButton alloc] initWithFrame:CGRectMake((self.viewWidth - 50)/2, CGRectGetMaxY(self.contentView.frame) + 20, 50, 20)];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateHighlighted];
        _closeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _closeButton.alpha = 0;
        
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
    self.viewHeight = [[UIScreen mainScreen] bounds].size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:[self loadingView]];
        [self.loadingView addSubview:[self loadingIcon]];
        [self.loadingView addSubview:[self loadingText]];
        
        [self addSubview:[self contentView]];
        [self.contentView addSubview:[self tripTitle]];
        [self.contentView addSubview:[self tripLocationIcon]];
        [self.contentView addSubview:[self tripLocationLabel]];
        [self.contentView addSubview:[self tripPlaceTypeIcon]];
        [self.contentView addSubview:[self tripPlaceTypeLabel]];
        [self.contentView addSubview:[self tripDateIcon]];
        [self.contentView addSubview:[self tripDateLabel]];
        [self.contentView addSubview:[self tripGuestIcon]];
        [self.contentView addSubview:[self tripGuestLabel]];
        [self.contentView addSubview:[self approveButton]];
        
        [self addSubview:[self guestProfileBorder]];
        [self addSubview:[self guestProfilePhoto]];
        [self addSubview:[self closeButton]];
        
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

/**
 * Show the popup on top of the parent view
 * @param UIView
 */
-(void)showInView:(UIView *)view {
    self.parentView = view;
    [self.parentView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

/**
 * Dismiss the popup, clean up the content in case it is call to show again
 */
-(void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        [self removeFromSuperview];
        self.parentView = nil;
    } completion:^(BOOL finished) {
        self.loadingView.alpha = 1;
        self.contentView.alpha = 0;
        self.guestProfileBorder.alpha = 0;
        self.guestProfilePhoto.alpha = 0;
        self.closeButton.alpha = 0;
    }];
}

/**
 * Set the trip object to be display
 * @param PFObject
 */
-(void)setNewTripObj:(PFObject *)tripObj {
    self.tripObj = tripObj;
    NSString *profilePic = tripObj[@"guest"][@"profilePic"] ? tripObj[@"guest"][@"profilePic"] : @"";
    [self.guestProfilePhoto setImage:[FontColor imageWithColor:[FontColor tableSeparatorColor]]];
    [self.guestProfilePhoto setProfileImageWithUrl:profilePic];
    
    self.tripTitle.text = [NSString stringWithFormat:TRIP_TITLE, [UserManager getUserNameFromUserObj:tripObj[@"guest"]]];
    
    //set the location
    NSString *location = self.tripObj[@"place"][@"location"];
    self.tripLocationLabel.text = location;
    CGSize expectSize = [self.tripLocationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
    if (expectSize.width > 205) {
        NSMutableArray *locationComponents = [[NSMutableArray alloc] initWithArray:[location componentsSeparatedByString:@","]];
        
        if (locationComponents.count <= 2) {
            self.tripLocationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
        } else {
            [locationComponents removeLastObject];
            NSString *newLocation = [locationComponents componentsJoinedByString:@","];
            self.tripLocationLabel.text = newLocation;
            
            expectSize = [self.tripLocationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
            if (expectSize.width > 205) {
                self.tripLocationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
            }
        }
    }

    //set the place type
    NSString *placeType = self.tripObj[@"place"][@"listingType"];
    if ([placeType isEqualToString:PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT]) {
        self.tripPlaceTypeIcon.image = [UIImage imageNamed:TRIP_PLACE_TYPE_ENTIRE_PLACE_ICON];
        self.tripPlaceTypeLabel.text = @"Entire place";
    } else if ([placeType isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM]) {
        self.tripPlaceTypeIcon.image = [UIImage imageNamed:TRIP_PLACE_TYPE_PRIVATE_SPACE_ICON];
        self.tripPlaceTypeLabel.text = @"Private space";
    } else if ([placeType isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM]) {
        self.tripPlaceTypeIcon.image = [UIImage imageNamed:TRIP_PLACE_TYPE_SHARED_SPACE_ICON];
        self.tripPlaceTypeLabel.text = @"Shared space";
    }
    
    //set the date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormat dateFromString:tripObj[@"startDate"]];
    NSDate *endDate = [dateFormat dateFromString:tripObj[@"endDate"]];
    self.tripDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateStringWithFormat:@"MMM dd yyyy"], [endDate dateStringWithFormat:@"MMM dd yyyy"]];
    
    //set the number of guest
    int numGuests = [tripObj[@"numGuests"] intValue];
    if (numGuests <= 1) self.tripGuestLabel.text = [NSString stringWithFormat:@"%d person", numGuests];
    else self.tripGuestLabel.text = [NSString stringWithFormat:@"%d people", numGuests];
    
    //set the state of approval button
    NSString *approvalState = tripObj[@"approval"] ? tripObj[@"approval"] : @"";
    if ([approvalState isEqualToString:@"NO"]) self.approveButton.enabled = YES;
    else if ([approvalState isEqualToString:@"YES"]) {
        [self.approveButton setTitle:@"Approved" forState:UIControlStateDisabled];
        self.approveButton.enabled = NO;
    } else if ([approvalState isEqualToString:@"CANCEL"]) {
        [self.approveButton setTitle:@"Canceled" forState:UIControlStateDisabled];
        self.approveButton.enabled = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.loadingView.alpha = 0;
        self.contentView.alpha = 1;
        self.guestProfileBorder.alpha = 1;
        self.guestProfilePhoto.alpha = 1;
        self.closeButton.alpha = 1;
    }];
}

#pragma mark - private method & delegate
/**
 * Handle the behavior when the approve button was click
 */
-(void)approveButtonClick {
    [self.hostPopupDelegate hostApprovedTripObj:self.tripObj];
    [self dismiss];
}

/**
 * touch delegate on the container view
 */
-(void)doNothing {
    //like the title, do nothing
}

/**
 * Animate the loading text
 */
-(void)animateLoadingText {
    NSString *oneDot = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
    NSString *twoDots = [NSString stringWithFormat:@"%@ ..", LOADING_TEXT];
    NSString *threeDots = [NSString stringWithFormat:@"%@ ...", LOADING_TEXT];
    if ([self.loadingText.text isEqualToString:oneDot]) self.loadingText.text = twoDots;
    else if ([self.loadingText.text isEqualToString:twoDots]) self.loadingText.text = threeDots;
    else self.loadingText.text = oneDot;
    
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}

@end
