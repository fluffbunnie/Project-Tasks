//
//  AmenityDisplayTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "AmenityDisplayTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

@interface AmenityDisplayTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) UIImageView *amenityIcon;
@property (nonatomic, strong) TTTAttributedLabel *amenityDescriptionLabel;
@end

@implementation AmenityDisplayTableViewCell
#pragma mark - initiation
/**
 * Lazily init the amenity icon
 * @return UIImageView
 */
-(UIImageView *)amenityIcon {
    if (_amenityIcon == nil) {
        _amenityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 40, 40)];
        _amenityIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _amenityIcon;
}

/**
 * Lazily init amenity description's label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)amenityDescriptionLabel {
    if (_amenityDescriptionLabel == nil) {
        _amenityDescriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(85, 15, self.viewWidth - 130, 40)];
        _amenityDescriptionLabel.lineSpacing = 4;
        _amenityDescriptionLabel.numberOfLines = 0;
        _amenityDescriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _amenityDescriptionLabel.textColor = [FontColor titleColor];
    }
    return _amenityDescriptionLabel;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width - 40;
        [self addSubview:[self amenityIcon]];
        [self addSubview:[self amenityDescriptionLabel]];
    }
    return self;
}

/**
 * Set the amenity item
 * @param AmenityItem
 */
-(void)setAmenityItem:(AmenityItem *)item {
    self.amenityIcon.image = item.amenityImageActive;
    self.amenityDescriptionLabel.text = item.amenityDescription;
    CGSize size = [self.amenityDescriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 170, FLT_MAX)];
    self.amenityDescriptionLabel.frame = CGRectMake(85, 15, self.viewWidth - 130, size.height);
    self.amenityIcon.frame = CGRectMake(25, 15, 40, 40);
    [self layoutSubviews];
}

/**
 * Get the height for the given amenity item
 * @param AmenityItem
 * @return CGFloat
 */
+(CGFloat)heightForAmenity:(AmenityItem *)item {
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width - 40;
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(85, 15, viewWidth - 130, 40)];
    label.lineSpacing = 4;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    label.text = item.amenityDescription;
    CGSize size = [label sizeThatFits:CGSizeMake(viewWidth - 130, FLT_MAX)];
    return MAX(size.height, 40) + 30;
}

@end
