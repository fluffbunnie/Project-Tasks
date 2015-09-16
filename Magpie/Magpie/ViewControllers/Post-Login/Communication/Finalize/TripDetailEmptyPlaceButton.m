//
//  TripDetailEmptyPlaceButton.m
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripDetailEmptyPlaceButton.h"
#import "UIImage+ImageEffects.h"

static NSString * IMAGE_NAME = @"PickPlaceHolder";
static NSString * ACTION_LABEL = @"Please pick a place";

@interface TripDetailEmptyPlaceButton()
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, strong) UIImageView *filledBackgroundImage;
@property (nonatomic, strong) UILabel *actionLabel;

@end

@implementation TripDetailEmptyPlaceButton
#pragma mark - initiation
/**
 * Lazily init the image view
 * @return UIImageView
 */
-(UIImageView *)filledBackgroundImage {
    if (_filledBackgroundImage == nil) {
        _filledBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _filledBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _filledBackgroundImage.clipsToBounds = YES;
        _filledBackgroundImage.layer.cornerRadius = 5;
        _filledBackgroundImage.image = self.normalImage;
    }
    return _filledBackgroundImage;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)actionLabel {
    if (_actionLabel == nil) {
        _actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _actionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _actionLabel.textColor = [UIColor whiteColor];
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        _actionLabel.text = ACTION_LABEL;
    }
    return _actionLabel;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalImage = [UIImage imageNamed:IMAGE_NAME];
        self.highlightImage = [self.normalImage applyBlur:0.3 tintColor:[UIColor colorWithWhite:0 alpha:0.1]];
        [self addSubview:[self filledBackgroundImage]];
        [self addSubview:[self actionLabel]];
    }
    return self;
}

/**
 * Override the set highlight state of the cell
 * @param highlight
 * @param animated
 */
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) self.filledBackgroundImage.image = self.highlightImage;
    else self.filledBackgroundImage.image = self.normalImage;
}

@end
