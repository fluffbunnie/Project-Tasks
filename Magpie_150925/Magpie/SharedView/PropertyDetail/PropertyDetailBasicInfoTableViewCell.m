//
//  PropertyDetailBasicInfoTableViewCell.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/21/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailBasicInfoTableViewCell.h"
#import "ParseConstant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FontColor.h"
#import "ImageUrl.h"
#import "SquircleProfileImage.h"
#import "UserManager.h"

static NSString *PROPERTY_IMAGE_MASK_INVERSE = @"PropertyImageMaskInverse";

@interface PropertyDetailBasicInfoTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) SquircleProfileImage *profileImageBorder;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UIImageView *starRating;
@property (nonatomic, strong) UILabel *hostName;
@end

@implementation PropertyDetailBasicInfoTableViewCell
#pragma mark - initiation
/**
 * Lazily init the background view
 * @return UIImageView
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.07 * self.viewWidth, self.viewWidth, [self viewHeight] - 0.07 * self.viewWidth + 1)];
        _backgroundImageView.image = [UIImage imageNamed:PROPERTY_IMAGE_MASK_INVERSE];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _backgroundImageView;
}

/**
 * Lazily init the profile image's border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImageBorder {
    if (_profileImageBorder == nil) {
        _profileImageBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(0.42 * self.viewWidth - 3, 0, 0.16 * self.viewWidth + 6, 0.16 * self.viewWidth + 6)];
    }
    return _profileImageBorder;
}

/**
 * Lazily init the profile picture
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(0.42 * self.viewWidth, 3, 0.16 * self.viewWidth, 0.16 * self.viewWidth)];
    }
    return _profileImage;
}

/**
 * Lazily init the star rating
 * @return UIImageView
 */
-(UIImageView *)starRating {
    if (_starRating == nil) {
        _starRating = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * self.viewWidth, 0.16 * self.viewWidth + 11, 0.2 * self.viewWidth, 0.2/6.0 * self.viewWidth)];
        _starRating.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _starRating;
}

/**
 * Lazily init the property name
 * @return UILabel
 */
-(UILabel *)hostName {
    if (_hostName == nil) {
        _hostName = [[UILabel alloc] initWithFrame:CGRectMake(20, (0.16 * self.viewWidth + 6) + 10, self.viewWidth - 40, 24)];

        _hostName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _hostName.textColor = [FontColor titleColor];
        _hostName.numberOfLines = 1;
        _hostName.textAlignment = NSTextAlignmentCenter;
        _hostName.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _hostName;
}

#pragma mark - public method
-(id)init {
    self = [super init];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:[self backgroundImageView]];
        [self.contentView addSubview:[self profileImageBorder]];
        [self.contentView addSubview:[self profileImage]];
        //[self.contentView addSubview:[self starRating]];
        [self.contentView addSubview:[self hostName]];
    }
    return self;
}

/**
 * Set the property object to be display
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    PFObject *userObj = propertyObj[@"owner"];
    if (userObj[@"profilePic"]) [self.profileImage setProfileImageWithUrl:userObj[@"profilePic"]];
    else [self.profileImage setProfileImageWithUrl:nil];
    
    CGFloat propertyRating = propertyObj[@"rating"] ? [((NSNumber *)propertyObj[@"rating"]) floatValue] : 0;
    if (propertyRating == 1) _starRating.image = [UIImage imageNamed:@"Rating1Star"];
    else if (propertyRating == 1.5) _starRating.image = [UIImage imageNamed:@"Rating1.5Stars"];
    else if (propertyRating == 2) _starRating.image = [UIImage imageNamed:@"Rating2Stars"];
    else if (propertyRating == 2.5) _starRating.image = [UIImage imageNamed:@"Rating2.5Stars"];
    else if (propertyRating == 3) _starRating.image = [UIImage imageNamed:@"Rating3Stars"];
    else if (propertyRating == 3.5) _starRating.image = [UIImage imageNamed:@"Rating3.5Stars"];
    else if (propertyRating == 4) _starRating.image = [UIImage imageNamed:@"Rating4Stars"];
    else if (propertyRating == 4.5) _starRating.image = [UIImage imageNamed:@"Rating4.5Stars"];
    else if (propertyRating == 5) _starRating.image = [UIImage imageNamed:@"Rating5Stars"];
    else self.starRating.image = [UIImage imageNamed:@"Rating0Star"];
    
    self.hostName.text = [UserManager getUserNameFromUserObj:userObj];
}

-(CGFloat)viewHeight {
//    return (0.16 * self.viewWidth + 6) + (0.2/6.0 * self.viewWidth + 5) + (10 + 24) + 15;
    return (0.16 * self.viewWidth + 6) + (10 + 24) + 15;

}


@end
