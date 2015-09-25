//
//  RadioButton.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "RadioButton.h"
#import "FontColor.h"

@interface RadioButton()
@property (nonatomic, strong) UIImageView *radioImage;
@property (nonatomic, strong) UILabel *optionLabel;
@end

@implementation RadioButton
#pragma mark - initiation
/**
 * Lazily init the radio image
 * @return UIImageView
 */
-(UIImageView *)radioImage {
    if (_radioImage == nil) {
        _radioImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, self.frame.size.height)];
        _radioImage.contentMode = UIViewContentModeScaleAspectFit;
        _radioImage.image = [UIImage imageNamed:@"RadioIconNormal"];
    }
    return _radioImage;
}

/**
 * Lazily init the option label
 * @return UILabel
 */
-(UILabel *)optionLabel {
    if (_optionLabel == nil) {
        _optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 40, self.frame.size.height)];
        _optionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _optionLabel.textColor = [FontColor titleColor];
    }
    return _optionLabel;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self radioImage]];
        [self addSubview:[self optionLabel]];
    }
    return self;
}

/**
 * Set the title for the title label
 * @param NSString
 */
-(void)setTitle:(NSString *)title {
    self.optionLabel.text = title;
}

#pragma mark - override its inherit method
/**
 * Override highlight
 */
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted || !self.enabled || self.selected) self.radioImage.image = [UIImage imageNamed:@"RadioIconHighlight"];
    else self.radioImage.image = [UIImage imageNamed:@"RadioIconNormal"];
}

/**
 * Override enable
 */
-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled || self.highlighted || self.selected) self.radioImage.image = [UIImage imageNamed:@"RadioIconHighlight"];
    else self.radioImage.image = [UIImage imageNamed:@"RadioIconNormal"];
}

/**
 * Override selected
 */
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected ||!self.enabled || self.highlighted) self.radioImage.image = [UIImage imageNamed:@"RadioIconHighlight"];
    else self.radioImage.image = [UIImage imageNamed:@"RadioIconNormal"];
}

@end
