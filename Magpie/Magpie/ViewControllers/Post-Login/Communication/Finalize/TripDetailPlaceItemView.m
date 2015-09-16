//
//  TripDetailPlaceItemView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripDetailPlaceItemView.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ParseConstant.h"

static NSString * NO_COVER_IMAGE = @"NoCoverImage";

@interface TripDetailPlaceItemView()
@property (nonatomic, strong) UIImageView *propertyImage;
@property (nonatomic, strong) UILabel *propertyLocation;
@property (nonatomic, strong) UILabel *propertyType;
@end

@implementation TripDetailPlaceItemView
#pragma mark - initiation
/**
 * Lazily init the property image view
 * @return UIImageView
 */
-(UIImageView *)propertyImage {
    if (_propertyImage == nil) {
        _propertyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 60)];
        _propertyImage.backgroundColor = [FontColor defaultBackgroundColor];
        _propertyImage.clipsToBounds = YES;
        _propertyImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _propertyImage;
}

/**
 * Lazily init the property location label
 * @return UILabel
 */
-(UILabel *)propertyLocation {
    if (_propertyLocation == nil) {
        _propertyLocation = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 52, self.frame.size.width - 40, 20)];
        _propertyLocation.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _propertyLocation.textColor = [FontColor titleColor];
    }
    return _propertyLocation;
}

/**
 * Lazily init the property type
 * @return UILabel
 */
-(UILabel *)propertyType {
    if (_propertyType == nil) {
        _propertyType = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 30, self.frame.size.width - 40, 20)];
        _propertyType.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _propertyType.textColor = [FontColor descriptionColor];
    }
    return _propertyType;
}


#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self addSubview:[self propertyImage]];
        [self addSubview:[self propertyLocation]];
        [self addSubview:[self propertyType]];
    }
    return self;
}

/**
 * set the property obj. Do this by changing the image and location
 * @param PFObject
 */
-(void)setPropertyObj:(PFObject *)propertyObj {
    self.propertyImage.image = [FontColor imageWithColor:[FontColor defaultBackgroundColor]];
    
    self.propertyLocation.text = propertyObj[@"location"] ? propertyObj[@"location"]: @"Unknown location";
    
    if ([propertyObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT]) self.propertyType.text = @"Entire place";
    else if ([propertyObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM]) self.propertyType.text = @"Private space";
    else if ([propertyObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM]) self.propertyType.text = @"Shared space";
    else self.propertyType.text = @"";
    
    NSString * coverPic = propertyObj[@"coverPic"] ? propertyObj[@"coverPic"] : @"";
    if (coverPic.length > 0) {
        NSString *url = [ImageUrl listingImageUrlFromUrl:coverPic];
        [self.propertyImage setImageWithURL:[NSURL URLWithString:url]];
    } else self.propertyImage.image = [UIImage imageNamed:NO_COVER_IMAGE];
}
@end
