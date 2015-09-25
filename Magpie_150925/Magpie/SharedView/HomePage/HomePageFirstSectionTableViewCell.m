//
//  HomePageFirstSectionTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageFirstSectionTableViewCell.h"
#import "UIImage+ImageEffects.h"

@interface HomePageFirstSectionTableViewCell()
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HomePageFirstSectionTableViewCell
#pragma mark - initiation
/**
 * Lazily init the image view
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, screenWidth - 30, 200)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.clipsToBounds = YES;
        _backgroundImage.layer.cornerRadius = 5;
    }
    return _backgroundImage;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth - 30, 200)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:[self backgroundImage]];
        [self.contentView addSubview:[self titleLabel]];
    }
    return self;
}

/**
 * Set the background image and the title for the cell
 * @param image
 * @param title
 */
-(void)setBackgroundImage:(UIImage *)image andTitle:(NSString *)title {
    self.normalImage = image;
    self.highlightImage = [image applyBlur:3 tintColor:[UIColor colorWithWhite:0 alpha:0.1]];
    self.backgroundImage.image = image;
    self.titleLabel.text = title;
}

/**
 * Override the set highlight state of the cell
 * @param highlight
 * @param animated
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) self.backgroundImage.image = self.highlightImage;
    else self.backgroundImage.image = self.normalImage;
}


@end
