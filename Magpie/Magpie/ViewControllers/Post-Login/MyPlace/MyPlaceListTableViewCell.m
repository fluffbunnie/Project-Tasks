//
//  MyPlaceTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FontColor.h"
#import "TTTAttributedLabel.h"
#import "ImageUrl.h"
#import "ParseConstant.h"

static NSString * NO_COVER_IMAGE = @"NoCoverImage";

@interface MyPlaceListTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, strong) UIImage *noCoverImage;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *propertyImage;
@property (nonatomic, strong) UILabel *privateStateOverlayLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) TTTAttributedLabel *statusLabel;

@end

@implementation MyPlaceListTableViewCell
#pragma mark - initiation
/**
 * Lazily init the no cover image
 * @return UIImage
 */
-(UIImage *)noCoverImage {
    if (_noCoverImage == nil) {
        _noCoverImage = [UIImage imageNamed:NO_COVER_IMAGE];
    }
    return _noCoverImage;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.viewWidth - 30, 200)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.borderColor = [FontColor defaultBackgroundColor].CGColor;
        _containerView.layer.borderWidth = 0.5;
        _containerView.layer.masksToBounds = YES;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}


/**
 * Lazily init the property image
 * @return UIImageView
 */
-(UIImageView *)propertyImage {
    if (_propertyImage == nil) {
        _propertyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth - 30, 140)];
        _propertyImage.backgroundColor = [FontColor defaultBackgroundColor];
        _propertyImage.contentMode = UIViewContentModeScaleAspectFill;
        _propertyImage.clipsToBounds = YES;
    }
    return _propertyImage;
}

/**
 * Lazily init the overlay label for the property image
 * @return UILabel
 */
-(UILabel *)privateStateOverlayLabel {
    if (_privateStateOverlayLabel == nil) {
        _privateStateOverlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth - 30, 140)];
        _privateStateOverlayLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _privateStateOverlayLabel.text = @"not published yet";
        _privateStateOverlayLabel.textColor = [FontColor defaultBackgroundColor];
        _privateStateOverlayLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _privateStateOverlayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _privateStateOverlayLabel;
}

/**
 * Lazily init the address label
 * @return UILabel
 */
-(UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 148, self.viewWidth - 70, 20)];
        _addressLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _addressLabel.textColor = [FontColor titleColor];
    }
    return _addressLabel;
}

/**
 * Lazily init the status label
 * @return UILabel
 */
-(TTTAttributedLabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 170, self.viewWidth - 70, 20)];
        _statusLabel.textColor = [FontColor descriptionColor];
        _statusLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    }
    return _statusLabel;
}


#pragma mark - public methods
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:[self containerView]];
        [self.containerView addSubview:[self propertyImage]];
        [self.containerView addSubview:[self privateStateOverlayLabel]];
        [self.containerView addSubview:[self addressLabel]];
        [self.containerView addSubview:[self statusLabel]];
    }
    return self;
}

/**
 * Set the place object
 * @param PFObject
 */
-(void)setPlace:(PFObject *)placeObj {
    NSString * coverPic = placeObj[@"coverPic"] ? placeObj[@"coverPic"] : @"";
    if (coverPic.length > 0) {
        NSString *url = [ImageUrl listingImageUrlFromUrl:coverPic];
        [self.propertyImage setImageWithURL:[NSURL URLWithString:url]];
    } else {
        self.propertyImage.image = [self noCoverImage];
    }
    
    NSString *location = placeObj[@"location"] ? placeObj[@"location"] : @"Place's location";
    self.addressLabel.text = location;
    
    self.statusLabel.text = @"Type";
    if (placeObj[@"listingType"]) {
        if ([placeObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT])
            self.statusLabel.text = @"Entire place";
        if ([placeObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM])
            self.statusLabel.text = @"Private space";
        if ([placeObj[@"listingType"] isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM])
            self.statusLabel.text = @"Shared space";
    }
    
    if (placeObj[@"state"]) {
        if ([placeObj[@"state"] isEqualToString:PROPERTY_APPROVAL_STATE_PRIVATE]) self.privateStateOverlayLabel.hidden = NO;
        else self.privateStateOverlayLabel.hidden = YES;
    }
}



@end
