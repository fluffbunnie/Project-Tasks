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

static NSString * const TRIP_GUEST_NAME = @"You're hosting %@";
static NSString * TRIP_LOCATION_ICON = @"TripLocationIcon";
static NSString * TRIP_DATE_ICON = @"TripDateIcon";
static NSString * TRIP_GUEST_ICON = @"TripGuestIcon";

@interface MyUpcomingTripHostTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) PFObject *currentTripObj;

@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UIView *leftBorder;
@property (nonatomic, strong) UILabel *guestName;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *locationImageIcon;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *calendarImageIcon;
@property (nonatomic, strong) UILabel *calendarLabel;
@property (nonatomic, strong) UIImageView *guestImageIcon;
@property (nonatomic, strong) UILabel *guestLabel;
@end

@implementation MyUpcomingTripHostTableViewCell
#pragma mark - initiation
/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    }
    return _profileImage;
}

/**
 * Lazily init the left border
 * @return UIView
 */
-(UIView *)leftBorder {
    if (_leftBorder == nil) {
        _leftBorder = [[UIView alloc] initWithFrame:CGRectMake(35, 60, 1, 95)];
        _leftBorder.backgroundColor = [FontColor defaultBackgroundColor];
    }
    return _leftBorder;
}

/**
 * Lazily init the guest name
 * @return TTTAttributedLabel
 */
-(UILabel *)guestName {
    if (_guestName == nil) {
        _guestName = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, self.viewWidth - 90, 20)];
    }
    return _guestName;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(70, 40, self.viewWidth - 85, 100)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = YES;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the location image icon
 * @return UIImageView
 */
-(UIImageView *)locationImageIcon {
    if (_locationImageIcon == nil) {
        _locationImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 20)];
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
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.viewWidth - 155, 20)];
        _locationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _locationLabel.textColor = [FontColor descriptionColor];
    }
    return _locationLabel;
}

/**
 * Lazily init the calendar image icon
 * @return UIImageView
 */
-(UIImageView *)calendarImageIcon {
    if (_calendarImageIcon == nil) {
        _calendarImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 25, 20)];
        _calendarImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _calendarImageIcon.image = [UIImage imageNamed:TRIP_DATE_ICON];
    }
    return _calendarImageIcon;
}

/**
 * Lazily init the calendar label
 * @return UILabel
 */
-(UILabel *)calendarLabel {
    if (_calendarLabel == nil) {
        _calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, self.viewWidth - 145, 20)];
        _calendarLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _calendarLabel.textColor = [FontColor descriptionColor];
    }
    return _calendarLabel;
}

/**
 * Lazily init the number of guests image icon
 * @return UIImageView
 */
-(UIImageView *)guestImageIcon {
    if (_guestImageIcon == nil) {
        _guestImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 25, 20)];
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
        _guestLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, self.viewWidth - 155, 20)];
        _guestLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _guestLabel.textColor = [FontColor descriptionColor];
    }
    return _guestLabel;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [UIScreen mainScreen].bounds.size.width;
        self.contentView.backgroundColor = [FontColor tableSeparatorColor];
        
        [self.contentView addSubview:[self profileImage]];
        [self.contentView addSubview:[self leftBorder]];
        [self.contentView addSubview:[self guestName]];
        [self.contentView addSubview:[self containerView]];
        [self.containerView addSubview:[self locationImageIcon]];
        [self.containerView addSubview:[self locationLabel]];
        [self.containerView addSubview:[self calendarImageIcon]];
        [self.containerView addSubview:[self calendarLabel]];
        [self.containerView addSubview:[self guestImageIcon]];
        [self.containerView addSubview:[self guestLabel]];
    }
    return self;
}

/**
 * Set the trip object to be display
 * @param PFObject
 */
-(void)setTripObj:(PFObject *)tripObj {
    self.currentTripObj = tripObj;
    
    //set the profile pic
    NSString *profilePic = tripObj[@"guest"][@"profilePic"] ? tripObj[@"guest"][@"profilePic"] : @"";
    [self.profileImage setImage:[FontColor imageWithColor:[FontColor tableSeparatorColor]]];
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
    
    //set the date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormat dateFromString:tripObj[@"startDate"]];
    NSDate *endDate = [dateFormat dateFromString:tripObj[@"endDate"]];
    self.calendarLabel.text = [NSString stringWithFormat:@"%@ - %@", [startDate dateStringWithFormat:@"MMM dd yyyy"], [endDate dateStringWithFormat:@"MMM dd yyyy"]];
    
    //set the number of guest
    int numGuests = [tripObj[@"numGuests"] intValue];
    if (numGuests <= 1) self.guestLabel.text = [NSString stringWithFormat:@"%d person", numGuests];
    else self.guestLabel.text = [NSString stringWithFormat:@"%d people", numGuests];
}

@end
