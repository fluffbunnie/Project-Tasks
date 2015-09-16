//
//  GuidedInteractionCompletedOverlayView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionCompletedOverlayView.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * const MAGPIE_ICON = @"MagpieIcon";

static NSString * const TITLE_TEXT = @"That’s it, my friend!\nYou're ready to explore.";
static NSString * const BUTTON_TEXT = @"Let the journey begin…";

@interface GuidedInteractionCompletedOverlayView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *magpieIcon;
@property (nonatomic, strong) TTTAttributedLabel * titleLabel;
@property (nonatomic, strong) UIButton *goToHomePageButton;
@end

@implementation GuidedInteractionCompletedOverlayView
#pragma mark - initiation
/**
 * Lazily init Magpie icon
 * @return UIImageView
 */
-(UIImageView *)magpieIcon {
    if (_magpieIcon == nil) {
        _magpieIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.viewWidth, 75)];
        _magpieIcon.contentMode = UIViewContentModeScaleAspectFit;
        _magpieIcon.image = [UIImage imageNamed:MAGPIE_ICON];
    }
    return _magpieIcon;
}

/**
 * Lazily init the title label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake((self.viewWidth - 260)/2, 140, 260, 65)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:21];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = TITLE_TEXT;
    }
    return _titleLabel;
}

/**
 * Lazily init go to home page button
 * @return UIButton
 */
-(UIButton *)goToHomePageButton {
    if (_goToHomePageButton == nil) {
        _goToHomePageButton = [[UIButton alloc] initWithFrame:CGRectMake(35, self.viewHeight - 100, self.viewWidth - 70, 50)];
        _goToHomePageButton.layer.cornerRadius = 25;
        _goToHomePageButton.layer.masksToBounds = YES;
        _goToHomePageButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_goToHomePageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goToHomePageButton setTitle:BUTTON_TEXT forState:UIControlStateNormal];
        [_goToHomePageButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        [_goToHomePageButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        [_goToHomePageButton addTarget:self action:@selector(goToHomePageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToHomePageButton;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.9];
        self.alpha = 0;
        [self addSubview:[self magpieIcon]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self goToHomePageButton]];
    }
    return self;
}

/**
 * Set the view alpha
 * @param CGFloat
 */
-(void)setViewAlpha:(CGFloat)alphaValue {
    CGFloat backgroundColorAlpha = 0.3 + 0.6 * alphaValue;
    self.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:backgroundColorAlpha];
    
    CGFloat stayComponentAlpha = 0.5 + 0.5 * alphaValue;
    self.magpieIcon.alpha = stayComponentAlpha;

    self.titleLabel.alpha = alphaValue;
    self.goToHomePageButton.alpha = alphaValue;
}

/**
 * Handle the behavior when user click on go to home page button
 */
-(void)goToHomePageButtonClick {
    [self.delegate completeGuidedInteractionButtonClick];
}


@end
