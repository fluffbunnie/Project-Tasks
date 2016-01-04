//
//  MyUpcomingTripHostTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyUpcomingTripHostTableViewCell.h"
#import "SquircleProfileImage.h"
#import "FontColor.h"
#import "PMCalendar.h"
#import "UserManager.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const NO_COVER_IMAGE = @"NoCoverImage";

static NSString * const TRIP_GUEST_NAME = @"You're hosting %@";
static NSString * const TRIP_LOCATION_ICON = @"TripLocationIcon";
static NSString * const TRIP_DATE_ICON = @"TripDateIcon";
static NSString * const TRIP_GUEST_ICON = @"TripGuestIcon";

@interface MyUpcomingTripHostTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) PFObject *currentTripObj;

@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UILabel *guestName;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) UIView *additionalInfoContainter;
@property (nonatomic, strong) UIImageView *locationImageIcon;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *guestImageIcon;
@property (nonatomic, strong) UILabel *guestLabel;

@property (nonatomic, strong) UIView *separatorView;
@end

@implementation MyUpcomingTripHostTableViewCell
#pragma mark - initiation
/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(self.viewWidth - 60, 20, 45, 45)];
    }
    return _profileImage;
}

/**
 * Lazily init the guest name
 * @return UILabel
 */
-(UILabel *)guestName {
    if (_guestName == nil) {
        _guestName = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, self.viewWidth - 90, 20)];
        _guestName.textAlignment = NSTextAlignmentRight;
    }
    return _guestName;
}

/**
 * Lazily init the duration label
 * @return UILabel
 */
-(UILabel *)durationLabel {
    if (_durationLabel == nil) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47, self.viewWidth - 90, 18)];
        _durationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _durationLabel.textColor = [FontColor descriptionColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, self.viewWidth - 30, 155)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = YES;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the property image view
 * @return UIImageView
 */
-(UIImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        _propertyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), 100)];
        _propertyImageView.contentMode = UIViewContentModeScaleAspectFill;
        _propertyImageView.clipsToBounds = YES;
    }
    return _propertyImageView;
}

/**
 * Lazily init the additional info container
 * @return UIView
 */
-(UIView *)additionalInfoContainer {
    if (_additionalInfoContainter == nil) {
        _additionalInfoContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.containerView.frame), 55)];
        _additionalInfoContainter.backgroundColor = [UIColor whiteColor];
    }
    return _additionalInfoContainter;
}

/**
 * Lazily init the location image icon
 * @return UIImageView
 */
-(UIImageView *)locationImageIcon {
    if (_locationImageIcon == nil) {
        _locationImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 105, 20, 20)];
        _locationImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _locationImageIcon.image = [UIImage imageNamed:TRIP_LOCATION_ICON];
    }
    return _locationImageIcon;
}

/**
 * Lazily init the location label
 * @return UILabel
 */
-(UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 105, self.viewWidth - 90, 20)];
        _locationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _locationLabel.textColor = [FontColor descriptionColor];
    }
    return _locationLabel;
}

/**
 * Lazily init the number of guests image icon
 * @return UIImageView
 */
-(UIImageView *)guestImageIcon {
    if (_guestImageIcon == nil) {
        _guestImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, 20, 20)];
        _guestImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _guestImageIcon.image = [UIImage imageNamed:TRIP_GUEST_ICON];
    }
    return _guestImageIcon;
}

/**
 * Lazily init the number of guest label
 * @return UILabel
 */
-(UILabel *)guestLabel {
    if (_guestLabel == nil) {
        _guestLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 130, self.viewWidth - 90, 20)];
        _guestLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _guestLabel.textColor = [FontColor descriptionColor];
    }
    return _guestLabel;
}

/**
 * Lazily init the separator view
 * @return UIView
 */
-(UIView *)separatorView {
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 258, self.viewWidth, 2)];
        _separatorView.backgroundColor = [UIColor whiteColor];
    }
    return _separatorView;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [UIScreen mainScreen].bounds.size.width;
        self.contentView.backgroundColor = [FontColor profileImageBackgroundColor];//[UIColor whiteColor];
        
        [self.contentView addSubview:[self profileImage]];
        [self.contentView addSubview:[self guestName]];
        [self.contentView addSubview:[self durationLabel]];
        [self.contentView addSubview:[self containerView]];
        [self.containerView addSubview:[self propertyImageView]];
        [self.containerView addSubview:[self additionalInfoContainer]];
        [self.containerView addSubview:[self locationImageIcon]];
        [self.containerView addSubview:[self locationLabel]];
        [self.containerView addSubview:[self guestImageIcon]];
        [self.containerView addSubview:[self guestLabel]];
        [self.contentView addSubview:[self separatorView]];
    }
    return self;
}

/**
 * Override the on-highlighted function
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.additionalInfoContainter.backgroundColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [FontColor profileImageBackgroundColor];
        self.additionalInfoContainter.backgroundColor = [UIColor whiteColor];
    }
}

/**
 * Override the on-selected function
 */
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //TODO do nothing;
}

/**
 * Set the trip object to be display
 * @param PFObject
 */
-(void)setTripObj:(PFObject *)tripObj {
    self.currentTripObj = tripObj;
    
    //set the profile pic
    NSString *profilePic = tripObj[@"guest"][@"profilePic"] ? tripObj[@"guest"][@"profilePic"] : @"";
    [self.profileImage setImage:[FontColor imageWithColor:[FontColor profileImageBackgroundColor]]];
    [self.profileImage setProfileImageWithUrl:profilePic];
    
    //set the user name
    NSString *name = [NSString stringWithFormat:TRIP_GUEST_NAME, [UserManager getUserNameFromUserObj:tripObj[@"guest"]]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[FontColor titleColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:15.0]}];
    NSRange standardRange = [name rangeOfString:@"You're hosting"];
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"AvenirNext-Regular" size:15]
                           range:standardRange];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[FontColor descriptionColor]
                           range:standardRange];
    self.guestName.attributedText = attributedText;
    
    //set the date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormat dateFromString:tripObj[@"startDate"]];
    NSDate *endDate = [dateFormat dateFromString:tripObj[@"endDate"]];
    self.durationLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateStringWithFormat:@"MMM dd yyyy"], [endDate dateStringWithFormat:@"MMM dd yyyy"]];

    //set the property photo
    NSString * coverPic = tripObj[@"place"][@"coverPic"];
    if (coverPic.length > 0) {
        NSString *url = [ImageUrl listingImageUrlFromUrl:coverPic];
        [self.propertyImageView setImageWithURL:[NSURL URLWithString:url]];
    } else {
        self.propertyImageView.image = [UIImage imageNamed:NO_COVER_IMAGE];
    }

    
    //set the location
    NSString *location = tripObj[@"place"][@"location"];
    self.locationLabel.text = location;
    CGSize expectSize = [self.locationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
    if (expectSize.width > self.viewWidth - 155) {
        NSMutableArray *locationComponents = [[NSMutableArray alloc] initWithArray:[location componentsSeparatedByString:@","]];
        
        if (locationComponents.count <= 2) {
            self.locationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
        } else {
            [locationComponents removeLastObject];
            NSString *newLocation = [locationComponents componentsJoinedByString:@","];
            self.locationLabel.text = newLocation;
            
            expectSize = [self.locationLabel sizeThatFits:CGSizeMake(FLT_MAX, 23)];
            if (expectSize.width > self.viewWidth - 155) {
                self.locationLabel.text = [[location componentsSeparatedByString:@","] firstObject];
            }
        }
    }
    
    //set the number of guest
    int numGuests = [tripObj[@"numGuests"] intValue];
    if (numGuests <= 1) self.guestLabel.text = [NSString stringWithFormat:@"%d person", numGuests];
    else self.guestLabel.text = [NSString stringWithFormat:@"%d people", numGuests];
}

@end
