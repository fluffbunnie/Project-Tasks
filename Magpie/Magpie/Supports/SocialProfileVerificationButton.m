//
//  SocialProfileVerificationButton.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SocialProfileVerificationButton.h"
#import "FontColor.h"

@interface SocialProfileVerificationButton()
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIImageView *checkIconView;
@end

@implementation SocialProfileVerificationButton

#pragma mark - initiation
/**
 * Lazily init the check icon view
 * @return UIImageView
 */
-(UIImageView *)checkIconView {
    if (_checkIconView == nil) {
        _checkIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 - (self.frame.size.height - 30), 15, self.frame.size.height - 30, self.frame.size.height - 30)];
        _checkIconView.contentMode = UIViewContentModeScaleAspectFit;
        _checkIconView.image = [UIImage imageNamed:@"SocialVerificationCheckButtonIcon"];
        _checkIconView.hidden = YES;
    }
    return _checkIconView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        self.titleLabel.textAlignment =  NSTextAlignmentCenter;
        [self addSubview:[self checkIconView]];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)setDefaultBackgroundColor:(UIColor *)normalColor andHighLightColor:(UIColor *)highlightColor {
    self.defaultColor = normalColor;
    self.highlightColor = highlightColor;
    self.backgroundColor = self.defaultColor;
}

#pragma mark - override the default behavior
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) self.backgroundColor = self.highlightColor ? self.highlightColor : [FontColor defaultBackgroundColor];
    else if (self.enabled) self.backgroundColor = self.defaultColor ? self.defaultColor : [FontColor defaultBackgroundColor];
    else self.backgroundColor = [FontColor defaultBackgroundColor];
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
        self.backgroundColor = [FontColor defaultBackgroundColor];
        self.checkIconView.hidden = NO;
    }
}

@end
