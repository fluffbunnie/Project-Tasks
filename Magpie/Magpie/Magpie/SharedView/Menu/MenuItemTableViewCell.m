//
//  MenuItemTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MenuItemTableViewCell.h"
#import "FontColor.h"

@interface MenuItemTableViewCell()

@property (nonatomic, strong) UIImage *normalIcon;
@property (nonatomic, strong) UIImage *highlightIcon;

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numUnreadLabel;
@property (nonatomic, strong) UIView *cellSeparator;

@end

@implementation MenuItemTableViewCell

#pragma mark - initiation
/**
 * Lazily init the cell icon
 * @return UIImageView
 */
-(UIImageView *)cellIcon {
    if (_cellIcon == nil) {
        _cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        _cellIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cellIcon;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 220, 30)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        _titleLabel.textColor = [FontColor titleColor];
    }
    return _titleLabel;
}

/**
 * Lazily init the number of unread label
 * @return UILabel
 */
-(UILabel *)numUnreadLabel {
    if (_numUnreadLabel == nil) {
        _numUnreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 220, 20)];
        _numUnreadLabel.backgroundColor = [FontColor themeColor];
        _numUnreadLabel.clipsToBounds = YES;
        _numUnreadLabel.layer.cornerRadius = 10;
        _numUnreadLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _numUnreadLabel.textColor = [UIColor whiteColor];
        _numUnreadLabel.textAlignment = NSTextAlignmentCenter;
        _numUnreadLabel.hidden = YES;
    }
    return _numUnreadLabel;
}

/**
 * Lazily ini the cell separator
 * @return UIView
 */
-(UIView *)cellSeparator {
    if (_cellSeparator == nil) {
        _cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(60, 54, 220, 1)];
        _cellSeparator.backgroundColor = [FontColor defaultBackgroundColor];
    }
    return _cellSeparator;
}


#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:[self cellIcon]];
        [self.contentView addSubview:[self titleLabel]];
        [self.contentView addSubview:[self numUnreadLabel]];
        //[self.contentView addSubview:[self cellSeparator]];
    }
    return self;
}

/**
 * Set the title and image icon for the cell, as well as its highlight state
 * @param icon
 * @param highlightIcon
 * @param title
 */
-(void)setIcon:(UIImage *)icon highlighedStateIcon:(UIImage *)highlightIcon andTitle:(NSString *)title {
    self.normalIcon = icon;
    self.highlightIcon = highlightIcon;
    
    self.cellIcon.image = self.normalIcon;
    self.titleLabel.text = title;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(220, 30)];
    self.titleLabel.frame = CGRectMake(60, 15, titleLabelSize.width, 30);
    
    self.numUnreadLabel.hidden = YES;
}

/**
 * Set the notification for the cell
 * @param labelText
 */
-(void)setNotificationLabel:(NSString *)label {
    self.numUnreadLabel.text = label;
    CGSize numUnreadLabelSize= [self.numUnreadLabel sizeThatFits:CGSizeMake(220, 20)];
    self.numUnreadLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 20, numUnreadLabelSize.width + 20, 20);
    self.numUnreadLabel.hidden = NO;
}

/**
 * Override the set highlight state of the cell
 * @param highlight
 * @param animated
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.cellIcon.image = self.highlightIcon;
        self.titleLabel.textColor = [FontColor themeColor];
    } else {
        self.cellIcon.image = self.normalIcon;
        self.titleLabel.textColor = [FontColor titleColor];
    }
}

/**
 * Override set selected state of the cell
 * @param selected
 * @param animated
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.contentView.backgroundColor = [UIColor clearColor];
}

@end
