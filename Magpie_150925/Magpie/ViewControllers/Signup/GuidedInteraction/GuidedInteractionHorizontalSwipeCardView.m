//
//  GuidedInteractionHorizontalSwipeCardView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionHorizontalSwipeCardView.h"
#import "SquircleProfileImage.h"
#import "UIStaticScrollingImageView.h"

static NSString *LISTING_INFO_BEDROOM_WHITE = @"ListingInfoBedroomWhite";
static NSString *LISTING_INFO_BATHROOM_WHITE = @"ListingInfoBathWhite";
static NSString *LISTING_INFO_BED_WHITE = @"ListingInfoBedWhite";
static NSString *LISTING_INFO_GUEST_WHITE = @"ListingInfoGuestWhite";

@interface GuidedInteractionHorizontalSwipeCardView()
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) UIStaticScrollingImageView *propertyImageView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageView;
@property (nonatomic, strong) UILabel *propertyLocationLabel;
@property (nonatomic, strong) UILabel *propertyTypeLabel;
@property (nonatomic, strong) UIImageView *propertyRatingImageView;
@property (nonatomic, strong) UIImageView *likeButton;
@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *numBedroomLabel;
@property (nonatomic, strong) UIImageView *bedroomIcon;
@property (nonatomic, strong) UILabel *numBathroomLabel;
@property (nonatomic, strong) UIImageView *bathroomIcon;
@property (nonatomic, strong) UILabel *numBedLabel;
@property (nonatomic, strong) UIImageView *bedIcon;
@property (nonatomic, strong) UILabel *numGuestLabel;
@property (nonatomic, strong) UIImageView *guestIcon;
@end

@implementation GuidedInteractionHorizontalSwipeCardView
#pragma mark - initiation
/**
 * Lazily init UIStaticScrollingImageView property image view
 * @return UIImageView
 */
-(UIStaticScrollingImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        _propertyImageView = [[UIStaticScrollingImageView alloc] init];
        
        //we also add a dark gradient to the view to make the text popped out more
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, self.contentHeight - 120, self.contentHeight, 120);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0 alpha:0.95] CGColor], nil];
        [_propertyImageView.layer addSublayer:gradient];
    }
    return _propertyImageView;
}

/**
 * Lazily init the profile image view
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)userProfileImageView {
    if (_userProfileImageView == nil) {
        _userProfileImageView = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(20, self.contentHeight - 105, 50, 50)];
        _userProfileImageView.layer.mask = nil;
        _userProfileImageView.layer.cornerRadius = 25;
    }
    return _userProfileImageView;
}

/**
 * Lazily init the location label
 * @return UILabel
 */
-(UILabel *)propertyLocationLabel {
    if (_propertyLocationLabel == nil) {
        _propertyLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.contentHeight - 105, self.contentWidth - 170, 23)];
        _propertyLocationLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _propertyLocationLabel.textColor = [UIColor whiteColor];
        _propertyLocationLabel.numberOfLines = 1;
        _propertyLocationLabel.text = @"San Francisco, CA";
    }
    return _propertyLocationLabel;
}

/**
 * Lazily init the property type label
 * @return UILabel
 */
-(UILabel *)propertyTypeLabel {
    if (_propertyTypeLabel == nil) {
        _propertyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.contentHeight - 77, 90, 22)];
        _propertyTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _propertyTypeLabel.textColor = [UIColor whiteColor];
        _propertyTypeLabel.text = @"Private space";
    }
    return _propertyTypeLabel;
}

/**
 * Lazily init the property rating view
 * @return UIImageView
 */
-(UIImageView *)propertyRatingImageView {
    if (_propertyRatingImageView == nil) {
        _propertyRatingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, self.contentHeight - 71, 60, 11)];
        _propertyRatingImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_propertyRatingImageView.hidden = YES;
    }
    return _propertyRatingImageView;
}

/**
 * Lazily init the property like Image
 * @return UIImageView
 */
-(UIImageView *)likeButton {
    if (_likeButton == nil) {
        _likeButton = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentWidth - 70, self.contentHeight - 105, 50, 50)];
        _likeButton.contentMode = UIViewContentModeScaleAspectFit;
        _likeButton.image = [UIImage imageNamed:@"LikeButtonNormal"];
    }
    return _likeButton;
}

/**
 * Lazily init the separator line
 * @return UIView
 */
-(UIView *)separatorView {
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(25, self.contentHeight - 45, self.contentWidth - 50, 1)];
        _separatorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    return _separatorView;
}

/**
 * Lazily init the listing info view
 * @return UIView
 */
-(UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake((self.contentWidth - 230)/2, self.contentHeight - 32, 230, 20)];
    }
    return _infoView;
}

/**
 * Lazily init the number of bedroom label
 * @return UILabel
 */
-(UILabel *)numBedroomLabel {
    if (_numBedroomLabel == nil) {
        _numBedroomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        _numBedroomLabel.textAlignment = NSTextAlignmentRight;
        _numBedroomLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _numBedroomLabel.textColor = [UIColor whiteColor];
        _numBedroomLabel.text = @"1";
    }
    return _numBedroomLabel;
}

/**
 * Lazily init the bedroom icon
 * @return UIImageView
 */
-(UIImageView *)bedroomIcon {
    if (_bedroomIcon == nil) {
        _bedroomIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 25, 20)];
        _bedroomIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bedroomIcon.image = [UIImage imageNamed:LISTING_INFO_BEDROOM_WHITE];
    }
    return _bedroomIcon;
}

/**
 * Lazily init the number of bathroom label
 * @return UILabel
 */
-(UILabel *)numBathroomLabel {
    if (_numBathroomLabel == nil) {
        _numBathroomLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 25, 20)];
        _numBathroomLabel.textAlignment = NSTextAlignmentRight;
        _numBathroomLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _numBathroomLabel.textColor = [UIColor whiteColor];
        _numBathroomLabel.text = @"1";
    }
    return _numBathroomLabel;
}

/**
 * Lazily init the bathroom icon
 * @return UILabel
 */
-(UIImageView *)bathroomIcon {
    if (_bathroomIcon == nil) {
        _bathroomIcon = [[UIImageView alloc] initWithFrame:CGRectMake(85, 0, 25, 20)];
        _bathroomIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bathroomIcon.image = [UIImage imageNamed:LISTING_INFO_BATHROOM_WHITE];
    }
    return _bathroomIcon;
}

/**
 * Lazily init the number of bed label
 * @return UILabel
 */
-(UILabel *)numBedLabel {
    if (_numBedLabel == nil) {
        _numBedLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 25, 20)];
        _numBedLabel.textAlignment = NSTextAlignmentRight;
        _numBedLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _numBedLabel.textColor = [UIColor whiteColor];
        _numBedLabel.text = @"1";
    }
    return _numBedLabel;
}

/**
 * Lazily init the bed icon
 * @return UIImageView
 */
-(UIImageView *)bedIcon {
    if (_bedIcon == nil) {
        _bedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 25, 20)];
        _bedIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bedIcon.image = [UIImage imageNamed:LISTING_INFO_BED_WHITE];
    }
    return _bedIcon;
}

/**
 * Lazily init the number of guest label
 * @return UILabel
 */
-(UILabel *)numGuestLabel {
    if (_numGuestLabel == nil) {
        _numGuestLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 25, 20)];
        _numGuestLabel.textAlignment = NSTextAlignmentRight;
        _numGuestLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _numGuestLabel.textColor = [UIColor whiteColor];
        _numGuestLabel.text = @"2";
    }
    return _numGuestLabel;
}

/**
 * Lazily init the guest icon
 * @return UILabel
 */
-(UIImageView *)guestIcon {
    if (_guestIcon == nil) {
        _guestIcon = [[UIImageView alloc] initWithFrame:CGRectMake(195, 0, 25, 20)];
        _guestIcon.contentMode = UIViewContentModeScaleAspectFit;
        _guestIcon.image = [UIImage imageNamed:LISTING_INFO_GUEST_WHITE];
    }
    return _guestIcon;
}

#pragma mark - public methods
-(id)init {
    self.contentWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.contentWidth, self.contentHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self addSubview:[self propertyImageView]];
        [self addSubview:[self userProfileImageView]];
        [self addSubview:[self propertyLocationLabel]];
        [self addSubview:[self propertyTypeLabel]];
        [self addSubview:[self likeButton]];
        [self addSubview:[self separatorView]];
        [self addSubview:[self infoView]];
        
        [self.infoView addSubview:[self numBedroomLabel]];
        [self.infoView addSubview:[self bedroomIcon]];
        [self.infoView addSubview:[self numBathroomLabel]];
        [self.infoView addSubview:[self bathroomIcon]];
        [self.infoView addSubview:[self numBedLabel]];
        [self.infoView addSubview:[self bedIcon]];
        [self.infoView addSubview:[self numGuestLabel]];
        [self.infoView addSubview:[self guestIcon]];
    }
    return self;
}

/**
 * Set the view index 
 * @param int
 */
-(void)setViewIndex:(int)index {
    if (index == 1) {
        [self.propertyImageView setImage:[UIImage imageNamed:HUONG_PROPERTY_IMAGE] yOffset:(self.contentHeight - self.contentWidth)/2 andPanDuration:15];
        self.userProfileImageView.image = [UIImage imageNamed:HUONG_USER_IMAGE];
        self.propertyLocationLabel.text = HUONG_LOCATION;
        
        self.numBedroomLabel.text = @"2";
        self.numBathroomLabel.text = @"1";
        self.numBedLabel.text = @"3";
        self.numGuestLabel.text = @"5";
    } else if (index == -1) {
        [self.propertyImageView setImage:[UIImage imageNamed:KAT_PROPERTY_IMAGE] yOffset:(self.contentHeight - self.contentWidth)/2 andPanDuration:15];
        self.userProfileImageView.image = [UIImage imageNamed:KAT_USER_IMAGE];
        self.propertyLocationLabel.text = KAT_LOCATION;
        
        self.numBedroomLabel.text = @"1";
        self.numBathroomLabel.text = @"1";
        self.numBedLabel.text = @"2";
        self.numGuestLabel.text = @"3";
    } else {
        [self.propertyImageView setImage:[UIImage imageNamed:MINH_PROPERTY_IMAGE] yOffset:(self.contentHeight - self.contentWidth)/2 andPanDuration:15];
        self.userProfileImageView.image = [UIImage imageNamed:MINH_USER_IMAGE];
        self.propertyLocationLabel.text = MINH_LOCATION;
        
        self.numBedroomLabel.text = @"2";
        self.numBathroomLabel.text = @"1.5";
        self.numBedLabel.text = @"2";
        self.numGuestLabel.text = @"4";
    }

}

/**
 * Do the animation to the view
 */
-(void)animateView {
    [self.propertyImageView doAnimation];
}

@end
