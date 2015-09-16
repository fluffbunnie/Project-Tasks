//
//  GuestPopup.m
//  Magpie
//
//  Created by minh thao nguyen on 5/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuestPopup.h"
#import "SquircleProfileImage.h"
#import "UnderLineButton.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PMCalendar.h"
#import "JGActionSheet.h"

static NSString * const LOADING_TEXT = @"Please wait";
static NSString * const TRIP_TITLE = @"Your stay request";
static NSString * const CANCEL_TEXT = @"Need to cancel your request? Click here";

static NSString * NO_COVER_IMAGE = @"NoCoverImage";
static NSString * HEADER_MASK = @"PropertyImageMask";
static NSString * TRIP_DATE_ICON = @"TripDateIcon";
static NSString * TRIP_GUEST_ICON = @"TripGuestIcon";

@interface GuestPopup()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) PFObject *tripObj;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *hostPropertyPhoto;
@property (nonatomic, strong) TTTAttributedLabel *requestStatusLabel;
@property (nonatomic, strong) SquircleProfileImage *hostProfileBorder;
@property (nonatomic, strong) SquircleProfileImage *hostProfilePhoto;
@property (nonatomic, strong) UILabel *tripTitle;
@property (nonatomic, strong) UIImageView *tripDateIcon;
@property (nonatomic, strong) UILabel *tripDateLabel;
@property (nonatomic, strong) UIImageView *tripGuestIcon;
@property (nonatomic, strong) UILabel *tripGuestLabel;

@property (nonatomic, strong) UnderLineButton *closeButton;
@property (nonatomic, strong) TTTAttributedLabel *cancelLabel;

@property (nonatomic, strong) JGActionSheet *cancelActionSheet;
@end

@implementation GuestPopup
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.viewHeight - 390) / 2, self.viewWidth - 40, 350)];
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
 * Lazily init the host property photo view
 * @return UIImageView
 */
-(UIImageView *)hostPropertyPhoto {
    if (_hostPropertyPhoto == nil) {
        _hostPropertyPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth - 40, 135)];
        _hostPropertyPhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:HEADER_MASK] CGImage];
        maskLayer.frame = CGRectMake(0, 0, self.viewWidth - 40, 135);
        _hostPropertyPhoto.layer.mask = maskLayer;
        _hostPropertyPhoto.layer.masksToBounds = YES;
    }
    return _hostPropertyPhoto;
}

/**
 * Lazily init the request status label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)requestStatusLabel {
    if (_requestStatusLabel == nil) {
        _requestStatusLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(self.viewWidth - 140, 25, 100, 30)];
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
    }
    return _requestStatusLabel;
}

/**
 * Lazily init the host profile's picture border
 * @return SquircleProfileImage 
 */
-(SquircleProfileImage *)hostProfileBorder {
    if (_hostProfileBorder == nil) {
        _hostProfileBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 60)/2 - 2, 115, 64, 64)];
    }
    return _hostProfileBorder;
}

/**
 * Lazily init the host profile's picture
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)hostProfilePhoto {
    if (_hostProfilePhoto == nil) {
        _hostProfilePhoto = [[SquircleProfileImage alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 60)/2, 117, 60, 60)];
    }
    return _hostProfilePhoto;
}

/**
 * Lazily init the trip title
 * @return UILabel
 */
-(UILabel *)tripTitle {
    if (_tripTitle == nil) {
        _tripTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 192, self.viewWidth - 40, 30)];
        _tripTitle.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _tripTitle.textColor = [FontColor titleColor];
        _tripTitle.textAlignment = NSTextAlignmentCenter;
        _tripTitle.text = TRIP_TITLE;
    }
    return _tripTitle;
}

/**
 * Lazily init the trip date icon
 * @return UIImageView
 */
-(UIImageView *)tripDateIcon {
    if (_tripDateIcon == nil) {
        _tripDateIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 242, 25, 21)];
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
        _tripDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripGuestIcon.frame) + 20, 242, 205, 21)];
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
        _tripGuestIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 40 - 250)/2, 283, 25, 21)];
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
        _tripGuestLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tripGuestIcon.frame) + 20, 283, 205, 21)];
        _tripGuestLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _tripGuestLabel.textColor = [FontColor descriptionColor];
    }
    return _tripGuestLabel;
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

/**
 * Lazily init the cancel label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)cancelLabel {
    if (_cancelLabel == nil) {
        _cancelLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.viewHeight - 40, self.viewWidth, 20)];
        _cancelLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _cancelLabel.textColor = [FontColor defaultBackgroundColor];
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.text = CANCEL_TEXT;
        _cancelLabel.delegate = self;
        _cancelLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: [FontColor defaultBackgroundColor],
                                        (id)kCTFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12]};
        NSRange range = [CANCEL_TEXT rangeOfString:@"Click here"];
        [_cancelLabel addLinkToURL:[NSURL URLWithString:@"action://cancel"] withRange:range];
        _cancelLabel.alpha = 0;
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
                weakSelf.requestStatusLabel.textColor = [FontColor descriptionColor];
                weakSelf.requestStatusLabel.backgroundColor = [FontColor defaultBackgroundColor];
                weakSelf.requestStatusLabel.text = @"cancelled";
                weakSelf.cancelLabel.alpha = 0;
                [weakSelf.guestPopupDelegate cancelTripObj:weakSelf.tripObj];
            } [sheet dismissAnimated:YES];
        }];
    }
    return _cancelActionSheet;
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
        [self.contentView addSubview:[self hostPropertyPhoto]];
        [self.contentView addSubview:[self requestStatusLabel]];
        [self.contentView addSubview:[self hostProfileBorder]];
        [self.contentView addSubview:[self hostProfilePhoto]];
        [self.contentView addSubview:[self tripTitle]];
        [self.contentView addSubview:[self tripDateIcon]];
        [self.contentView addSubview:[self tripDateLabel]];
        [self.contentView addSubview:[self tripGuestIcon]];
        [self.contentView addSubview:[self tripGuestLabel]];
        
        [self addSubview:[self closeButton]];
        [self addSubview:[self cancelLabel]];
        
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
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
        self.closeButton.alpha = 0;
        self.cancelLabel.alpha = 0;
    }];
}

/**
 * Set the trip object to be display
 * @param PFObject
 */
-(void)setNewTripObj:(PFObject *)tripObj {
    self.tripObj = tripObj;
    [self.hostPropertyPhoto setImage:[FontColor imageWithColor:[FontColor defaultBackgroundColor]]];
    [self.hostProfilePhoto setImage:[FontColor imageWithColor:[FontColor tableSeparatorColor]]];
    
    NSString * coverPic = tripObj[@"place"][@"coverPic"] ? tripObj[@"place"][@"coverPic"] : @"";
    if (coverPic.length > 0) {
        NSString *url = [ImageUrl listingImageUrlFromUrl:coverPic];
        [self.hostPropertyPhoto setImageWithURL:[NSURL URLWithString:url]];
    } else self.hostPropertyPhoto.image = [UIImage imageNamed:NO_COVER_IMAGE];
    
    NSString *approvalState = tripObj[@"approval"] ? tripObj[@"approval"] : @"";
    self.requestStatusLabel.hidden = NO;
    if ([approvalState isEqualToString:@"NO"]) {
        self.requestStatusLabel.textColor = [UIColor whiteColor];
        self.requestStatusLabel.backgroundColor = [FontColor descriptionColor];
        self.requestStatusLabel.text = @"pending";
    } else if ([approvalState isEqualToString:@"YES"]) {
        self.requestStatusLabel.textColor = [UIColor whiteColor];
        self.requestStatusLabel.backgroundColor = [FontColor approveColor];
        self.requestStatusLabel.text = @"approved";
    } else if ([approvalState isEqualToString:@"CANCEL"]) {
        self.requestStatusLabel.textColor = [FontColor descriptionColor];
        self.requestStatusLabel.backgroundColor = [FontColor defaultBackgroundColor];
        self.requestStatusLabel.text = @"cancelled";
    } else self.requestStatusLabel.hidden = YES;
    
    NSString *profilePic = tripObj[@"host"][@"profilePic"] ? tripObj[@"host"][@"profilePic"] : @"";
    [self.hostProfilePhoto setProfileImageWithUrl:profilePic];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormat dateFromString:tripObj[@"startDate"]];
    NSDate *endDate = [dateFormat dateFromString:tripObj[@"endDate"]];
    self.tripDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateStringWithFormat:@"MMM dd yyyy"], [endDate dateStringWithFormat:@"MMM dd yyyy"]];
    
    int numGuests = [tripObj[@"numGuests"] intValue];
    if (numGuests <= 1) self.tripGuestLabel.text = [NSString stringWithFormat:@"%d person", numGuests];
    else self.tripGuestLabel.text = [NSString stringWithFormat:@"%d people", numGuests];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.loadingView.alpha = 0;
        self.contentView.alpha = 1;
        self.closeButton.alpha = 1;
        if (![approvalState isEqualToString:@"CANCEL"]) self.cancelLabel.alpha = 1;
    }];
}

#pragma mark - private method & delegate
/**
 * touch delegate on the container view
 */
-(void)doNothing {
    //like the title, do nothing
}

/**
 * TTTAttributesLabel delegate
 * Handle the behavior when user click on the login label
 */
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[self cancelActionSheet] showInView:self animated:YES];
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

#pragma mark - touch to allow cancel to click
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[TTTAttributedLabel class]]) return NO;
    else return YES;
}


@end
