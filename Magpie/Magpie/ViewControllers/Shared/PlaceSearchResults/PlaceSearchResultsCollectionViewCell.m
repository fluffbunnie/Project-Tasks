//
//  PlaceSearchResultsCollectionViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 8/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PlaceSearchResultsCollectionViewCell.h"
#import "SquircleProfileImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageUrl.h"
#import "FontColor.h"

static CGFloat IMAGE_HEIGHT = 220;
static CGFloat AVATAR_SIZE = 40;
static CGFloat NAME_HEIGHT = 18;

@interface PlaceSearchResultsCollectionViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) SquircleProfileImage *profileImageBorder;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@end


@implementation PlaceSearchResultsCollectionViewCell
#pragma mark - instantiation
/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.clipsToBounds = YES;
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the property image view
 * @return UIImageView
 */
-(UIImageView *)propertyImageView {
    if (_propertyImageView == nil) {
        _propertyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, IMAGE_HEIGHT)];
        _propertyImageView.contentMode = UIViewContentModeScaleAspectFill;
        _propertyImageView.clipsToBounds = YES;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:@"FavoriteImageMask"] CGImage];
        maskLayer.frame = CGRectMake(0, 0, self.viewWidth, IMAGE_HEIGHT);
        _propertyImageView.layer.mask = maskLayer;
        _propertyImageView.layer.masksToBounds = YES;
    }
    return _propertyImageView;
}

/**
 * Lazily init the border for the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImageBorder {
    if (_profileImageBorder == nil) {
        _profileImageBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(self.viewWidth - AVATAR_SIZE - 10 - 2, IMAGE_HEIGHT - 0.6 * AVATAR_SIZE - 2, AVATAR_SIZE + 4, AVATAR_SIZE + 4)];
    }
    return _profileImageBorder;
}

/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(self.viewWidth - AVATAR_SIZE - 10, IMAGE_HEIGHT - 0.6 * AVATAR_SIZE, AVATAR_SIZE, AVATAR_SIZE)];
    }
    return _profileImage;
}

/**
 * Lazily init the user's name
 * @return UILabel
 */
-(UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, IMAGE_HEIGHT + 5, self.viewWidth - 20 - 10 - AVATAR_SIZE, NAME_HEIGHT)];
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        _userNameLabel.textColor = [FontColor titleColor];
    }
    return _userNameLabel;
}

/**
 * Lazily init the location label
 * @return UILabel
 */
-(UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, IMAGE_HEIGHT + 5 + NAME_HEIGHT, self.viewWidth - 20, self.viewHeight - CGRectGetMaxY(self.userNameLabel.frame) - 7)];
        _locationLabel.textColor = [FontColor descriptionColor];
        _locationLabel.numberOfLines = 0;
        _locationLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    }
    return _locationLabel;
}

#pragma mark -  public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self.contentView addSubview:[self containerView]];
        [self.containerView addSubview:[self propertyImageView]];
        [self.containerView addSubview:[self profileImageBorder]];
        [self.containerView addSubview:[self profileImage]];
        [self.containerView addSubview:[self userNameLabel]];
        [self.containerView addSubview:[self locationLabel]];    }
    return self;
}

/**
 * Set the property obj. Resize if necessary
 * @param PFObject
 * @param double
 */
-(void)setPropertyObj:(PFObject *)propertyObj withDistance:(double)distance {
    PFObject *userObj = propertyObj[@"owner"];
    CGSize newSize = [PlaceSearchResultsCollectionViewCell sizeForPropertyObj:propertyObj withDistance:distance];
    if (newSize.height != self.viewHeight || newSize.width != self.viewWidth) {
        self.viewWidth = newSize.width;
        self.viewHeight = newSize.height;
        self.containerView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        self.locationLabel.frame = CGRectMake(10, IMAGE_HEIGHT + 5 + NAME_HEIGHT, self.viewWidth - 20, self.viewHeight - CGRectGetMaxY(self.userNameLabel.frame)  - 7);
    }
    
    NSString *propertyPhoto = propertyObj[@"coverPic"] ? propertyObj[@"coverPic"] : @"";
    self.propertyImageView.image = [FontColor imageWithColor:[UIColor whiteColor]];
    if (propertyPhoto.length > 0) [self.propertyImageView setImageWithURL:[NSURL URLWithString:[ImageUrl favoritePropertyImageUrlFromUrl:propertyPhoto]]];
    
    [self.profileImage setProfileImageWithUrl:userObj[@"profilePic"]];
    NSString *userName = userObj[@"username"] ? userObj[@"username"] : nil;
    if (userName.length == 0) userName = userObj[@"email"] ? userObj[@"email"] : @"";
    self.userNameLabel.text = userName;
    
    //input the location
    NSString *location = propertyObj[@"location"] ? propertyObj[@"location"] : @"";
    self.locationLabel.attributedText = [PlaceSearchResultsCollectionViewCell getLocationAttributedString:location andDistance:distance];
}

/**
 * Get the cell size for a given property Obj
 * @param PFObject
 * @param double
 * @return CGSize
 */
+(CGSize)sizeForPropertyObj:(PFObject *)propertyObj withDistance:(double)distance {
    CGFloat cellWidth = ([[UIScreen mainScreen] bounds].size.width - 45) / 2;
    NSString *location = propertyObj[@"location"] ? propertyObj[@"location"] : @"";
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.numberOfLines = 0;
    tempLabel.attributedText = [PlaceSearchResultsCollectionViewCell getLocationAttributedString:location andDistance:distance];
    CGSize sizeForLocation = [tempLabel sizeThatFits:CGSizeMake(cellWidth - 20, FLT_MAX)];
    
    return CGSizeMake(cellWidth, MAX(IMAGE_HEIGHT + 5 + NAME_HEIGHT + 15 + 7, IMAGE_HEIGHT + 5 + NAME_HEIGHT + sizeForLocation.height + 7));
}

/**
 * Get the attributed string for the location and distance
 * @param location
 * @param distance
 */
+(NSMutableAttributedString *)getLocationAttributedString:(NSString *)location andDistance:(double)distance {
    NSString *distanceText = [NSString stringWithFormat:@"%d mi", (int)distance];
    if (distance < 10) distanceText = [NSString stringWithFormat:@"%.1f mi", distance];
    
    NSString *locationText = [NSString stringWithFormat:@"%@ ∙ ", location];
    NSUInteger commaIndex = [location rangeOfString:@","].location;
    if (commaIndex != NSNotFound) locationText = [NSString stringWithFormat:@"%@ ∙ ", [location substringToIndex:commaIndex]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:locationText attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:12.0]}];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:distanceText attributes:@{NSForegroundColorAttributeName:[FontColor subTitleColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:12.0]}]];
    
    return attributedString;
}

@end
