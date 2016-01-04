//
//  BrowseCardView.m
//  Magpie
//
//  Created by minh thao nguyen on 6/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "BrowseCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FontColor.h"
#import "PhotoButton.h"
#import "UserManager.h"
#import "Property.h"
#import "ImageUrl.h"
#import "SquircleProfileImage.h"
#import "LikeButton.h"
#import "ParseConstant.h"

static CGFloat ACTION_MARGIN = 75;
static CGFloat IMAGE_OFFSIDE = 250;
static CGFloat IMAGE_SLIDE_DURATION = 20;

static NSString *NO_PROFILE_IMAGE_NAME = @"NoProfileImage";
static NSString *LISTING_INFO_BEDROOM_WHITE = @"ListingInfoBedroomWhite";
static NSString *LISTING_INFO_BATHROOM_WHITE = @"ListingInfoBathWhite";
static NSString *LISTING_INFO_BED_WHITE = @"ListingInfoBedWhite";
static NSString *LISTING_INFO_GUEST_WHITE = @"ListingInfoGuestWhite";

static NSString *CARD_LIKE_NORMAL = @"LikeButtonNormal";
static NSString *CARD_LIKE_SELECTED = @"LikeButtonSelected";

@interface BrowseCardView()
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) PFObject *propertyObj;

@property (nonatomic, assign) int panState;
@property (nonatomic, assign) CGFloat xFromCenter;
@property (nonatomic, assign) CGFloat yFromCenter;

@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) SquircleProfileImage *userProfileImageView;
@property (nonatomic, strong) UILabel *propertyLocationLabel;
@property (nonatomic, strong) UILabel *propertyTypeLabel;
@property (nonatomic, strong) UIImageView *propertyRatingImageView;
@property (nonatomic, strong) LikeButton *likeButton;
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

@property (nonatomic, strong) PFObject *likeObj;
@end

@implementation BrowseCardView
#pragma mark - initiation
/**
 * Lazily init the property image view
 * @return UIImageView
 */
-(UIImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        _propertyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- IMAGE_OFFSIDE, 0, self.contentWidth +  2 * IMAGE_OFFSIDE, self.contentHeight)];
        _propertyImageView.contentMode = UIViewContentModeScaleAspectFill;
        _propertyImageView.backgroundColor = [FontColor propertyImageBackgroundColor];
        
        //we also add a dark gradient to the view to make the text popped out more
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, self.contentHeight - 120, self.contentWidth + 2 * IMAGE_OFFSIDE, 120);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0 alpha:0.95] CGColor], nil];
        [_propertyImageView.layer insertSublayer:gradient atIndex:0];
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
    }
    return _propertyLocationLabel;
}

/**
 * Lazily init the property type label
 * @return UILabel
 */
-(UILabel *)propertyTypeLabel {
    if (_propertyTypeLabel == nil) {
        _propertyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.contentHeight - 77, 100, 22)];
        _propertyTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _propertyTypeLabel.textColor = [UIColor whiteColor];
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
 * Lazily init the property like button
 * @return LikeButton
 */
-(LikeButton *)likeButton {
    if (_likeButton == nil) {
        _likeButton = [[LikeButton alloc] initWithFrame:CGRectMake(self.contentWidth - 70, self.contentHeight - 105, 50, 50)];
        
        [_likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentController = parentController;
        self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        self.contentWidth = frame.size.width;
        self.contentHeight = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self addSubview:[self propertyImageView]];
        [self addSubview:[self userProfileImageView]];
        [self addSubview:[self propertyLocationLabel]];
        [self addSubview:[self propertyTypeLabel]];
        //[self addSubview:[self propertyRatingImageView]];
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
        
        UITapGestureRecognizer *cardTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
        [self addGestureRecognizer:cardTapped];
        
        UIPanGestureRecognizer *cardDragged = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardDragged:)];
        [self addGestureRecognizer:cardDragged];
    }
    return self;
}

/**
 * Set the card's property object value
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    self.propertyObj = propertyObj;
    
    [self.likeButton setHidden:YES];
    [self loadPropertyImageView];
    [self loadUserProfileImage];
    [self loadPropertyLocationLabel];
    [self loadPropertyTypeLabel];
    [self loadPropertyRating];
    [self loadPropertyInfo];
}

/**
 * Animate the card with the panning effect
 */
-(void)animateView {
    [UIView animateWithDuration:IMAGE_SLIDE_DURATION / 2
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.propertyImageView.transform = CGAffineTransformMakeTranslation(-IMAGE_OFFSIDE, 0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:IMAGE_SLIDE_DURATION // twice as long!
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse
                                          animations:^{
                                              self.propertyImageView.transform = CGAffineTransformMakeTranslation(IMAGE_OFFSIDE, 0);
                                          }
                                          completion:nil
                          ];
                         
                     }
     ];
}

/**
 * Set the state of the like button
 * @param BOOL
 */
-(void)setLike:(BOOL)like {
    self.likeButton.hidden = NO;
    [self.likeButton setLike:like];
    self.likeButton.enabled = YES;
}

#pragma mark - set the view components
/**
 * Load the property image view
 */
-(void)loadPropertyImageView {
    NSString *imageUrl = self.propertyObj[@"coverPic"] ? self.propertyObj[@"coverPic"] : nil;
    if (imageUrl.length > 0) imageUrl = [ImageUrl coverImageUrlFromUrl:imageUrl];
    
    //TODO make this more optimize
    if (imageUrl.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.propertyImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[FontColor imageWithColor:[FontColor defaultBackgroundColor]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //TODO load faster image
            [weakSelf animateView];
        }];
    }
}

/**
 * Load the property's location
 */
-(void)loadPropertyLocationLabel {
    NSString *location = self.propertyObj[@"location"] ? self.propertyObj[@"location"] : nil;
    self.propertyLocationLabel.text = location;
    CGSize expectSize = [self.propertyLocationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
    if (expectSize.width > self.contentWidth - 170) {
        NSMutableArray *locationComponents = [[NSMutableArray alloc] initWithArray:[location componentsSeparatedByString:@","]];
        
        if (locationComponents.count <= 2) {
            self.propertyLocationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
        } else {
            [locationComponents removeLastObject];
            NSString *newLocation = [locationComponents componentsJoinedByString:@","];
            self.propertyLocationLabel.text = newLocation;
            
            expectSize = [self.propertyLocationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
            if (expectSize.width > self.contentWidth - 170) {
                self.propertyLocationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
            }
        }
    }
}

/**
 * Load the property's type
 */
-(void)loadPropertyTypeLabel {
    NSString *propertyType = self.propertyObj[@"listingType"] ? self.propertyObj[@"listingType"] : @"";
    if ([propertyType isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM]) self.propertyTypeLabel.text = @"Private space";
    else if ([propertyType isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM]) self.propertyTypeLabel.text = @"Shared space";
    else self.propertyTypeLabel.text = @"Entire place";
}

/**
 * Load the property rating view
 */
-(void)loadPropertyRating {
    CGFloat rating = self.propertyObj[@"rating"] ? [((NSNumber *)self.propertyObj[@"rating"]) floatValue] : 0;
    if (rating == 1) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating1Star"]];
    else if (rating == 1.5) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating1.5Stars"]];
    else if (rating == 2) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating2Stars"]];
    else if (rating == 2.5) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating2.5Stars"]];
    else if (rating == 3) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating3Stars"]];
    else if (rating == 3.5) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating3.5Stars"]];
    else if (rating == 4) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating4Stars"]];
    else if (rating == 4.5) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating4.5Stars"]];
    else if (rating == 5) [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating5Stars"]];
    else [self.propertyRatingImageView setImage:[UIImage imageNamed:@"Rating0Star"]];
}

/**
 * Loat the property asset view
 */
-(void)loadPropertyInfo {
    if (self.propertyObj[@"numBedrooms"]) {
        int numBedrooms = [self.propertyObj[@"numBedrooms"] intValue];
        if (numBedrooms > 6) self.numBedroomLabel.text = @"6+";
        else self.numBedroomLabel.text = [NSString stringWithFormat:@"%d", numBedrooms];
    } else self.numBedroomLabel.text = @"n/a";
    
    if (self.propertyObj[@"numBathrooms"]) {
        float numBathrooms = [self.propertyObj[@"numBathrooms"] floatValue];
        if (numBathrooms > 4) self.numBathroomLabel.text = @"4+";
        else if (numBathrooms == (int)numBathrooms) self.numBathroomLabel.text = [NSString stringWithFormat:@"%d", (int)numBathrooms];
        else self.numBathroomLabel.text = [NSString stringWithFormat:@"%.1f", numBathrooms];
    } else self.numBathroomLabel.text = @"n/a";
    
    if (self.propertyObj[@"numBeds"]) {
        int numBeds = [self.propertyObj[@"numBeds"] intValue];
        if (numBeds > 9) self.numBedLabel.text = @"9+";
        else self.numBedLabel.text = [NSString stringWithFormat:@"%d", numBeds];
    } else self.numBedLabel.text = @"n/a";
    
    if (self.propertyObj[@"numGuests"]) {
        int numGuests = [self.propertyObj[@"numGuests"] intValue];
        if (numGuests > 9) self.numGuestLabel.text = @"9+";
        else self.numGuestLabel.text = [NSString stringWithFormat:@"%d", numGuests];
    } else self.numGuestLabel.text = @"n/a";
}

/**
 * Load the user's profile image view
 */
-(void)loadUserProfileImage {
    PFObject *ownerObj = [self.propertyObj objectForKey:@"owner"];
    NSString *url = (ownerObj && ownerObj[@"profilePic"])? ownerObj[@"profilePic"] : nil;
    [self.userProfileImageView setProfileImageWithUrl:url];
}


#pragma mark - gestures
/**
 * Handle the action when the like button is pressed
 */
-(void)likeButtonClick {
    self.likeButton.enabled = NO;
    [self.parentController likeClickForPropertyObj:self.propertyObj];
}

/**
 * Handle the action when the card is tapped
 */
-(void)cardTapped {
    [self.parentController showCardDetail];
}

/**
 * Handle the action when the card is dragged
 * @param pan gesture
 */
-(void)cardDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    self.xFromCenter = [gestureRecognizer translationInView:self].x;
    self.yFromCenter = [gestureRecognizer translationInView:self].y;
    if (self.panState == 0) {
        if (fabs(self.yFromCenter) > fabs(self.xFromCenter)) self.panState = 1; //pan vertically
        else self.panState = 2; //pan horizontally
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.panState = 0; //state began
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            if (self.panState == 1) [self.parentController cardSwipeYOffset:self.yFromCenter];
            else [self.cardDelegate cardSwipingXOffset:self.xFromCenter];
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            if (self.panState == 1) {
                if (self.yFromCenter > 1.5 * ACTION_MARGIN) [self.parentController goBack];
                else if (self.yFromCenter < -ACTION_MARGIN) [self.parentController showCardDetail];
                else [self.parentController hideCardDetail];
            } else {
                if (self.xFromCenter > ACTION_MARGIN) [self.parentController showPrevCard];
                else if (self.xFromCenter < -ACTION_MARGIN) [self.parentController showNextCard];
                else [self.cardDelegate cardHorizontalSwipingStopped];
            }
            break;
        };
            
        default: break;
    }
}



@end
