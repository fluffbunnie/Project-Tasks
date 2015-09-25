//
//  GuidedInteractionOverlayView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/13/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionOverlayView.h"
#import "TTTAttributedLabel.h"
#import "Device.h"
#import "UserManager.h"

static NSString * const MAGPIE_ICON = @"MagpieIcon";

@interface GuidedInteractionOverlayView()
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *magpieIcon;
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *interactionImage;

@property (nonatomic, strong) UIImageView *pageIndicatorImage;
@end

@implementation GuidedInteractionOverlayView
#pragma mark - initiation
/**
 * Lazily init magpie icon
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
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 140, self.viewWidth, 65)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        
        if (self.index == 0) {
            [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                if (userObj != nil) {
                    if (userObj[@"firstname"]) _titleLabel.text = [NSString stringWithFormat:PAGE_ONE_TITLE, userObj[@"firstname"]];
                    else _titleLabel.text = [NSString stringWithFormat:PAGE_ONE_TITLE, userObj[@"username"]];
                }
                else _titleLabel.text = PAGE_ONE_TITLE_NO_NAME;
            }];
        } else {
            _titleLabel.frame = CGRectMake(30, 140, self.viewWidth - 60, 30);
            if (self.index == 1) _titleLabel.text = PAGE_TWO_TITLE;
            else if (self.index == 2) _titleLabel.text = PAGE_THREE_TITLE;
            else if (self.index == 3) _titleLabel.text =  PAGE_FOUR_TITLE;
            else _titleLabel.text = PAGE_FIVE_TITLE;
        }
    }
    return _titleLabel;
}

/**
 * Lazily init the description label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 260)/2, 310, 260, 50);
        if ([Device isIphone6]) frame = CGRectMake((self.viewWidth - 260)/2, 290, 260, 50);
        else if ([Device isIphone5]) frame = CGRectMake((self.viewWidth - 260)/2, 270, 260, 50);
        else if ([Device isIphone4]) frame = CGRectMake((self.viewWidth - 260)/2, 240, 260, 50);
        _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        
        if (self.index == 0) _descriptionLabel.text = PAGE_ONE_MESSAGE;
        else if (self.index == 1) _descriptionLabel.text = PAGE_TWO_MESSAGE;
        else if (self.index == 2) {
            _descriptionLabel.frame = CGRectMake((self.viewWidth - 300)/2, frame.origin.y, 300, 50);
            _descriptionLabel.text = PAGE_THREE_MESSAGE;
        }
        else if (self.index == 3) _descriptionLabel.text = PAGE_FOUR_MESSAGE;
        else _descriptionLabel.text = PAGE_FIVE_MESSAGE;
    }
    return _descriptionLabel;
}

/**
 * Lazily init the interation image
 * @return UIImageView
 */
-(UIImageView *)interactionImage {
    if (_interactionImage == nil) {
        CGRect frame = CGRectMake(85, CGRectGetMaxY(self.descriptionLabel.frame) + 30, self.viewWidth - 170, self.viewHeight - CGRectGetMaxY(self.descriptionLabel.frame) - 110);
        if ([Device isIphone4] || [Device isIphone5]) frame = CGRectMake(60, CGRectGetMaxY(self.descriptionLabel.frame) + 20, self.viewWidth - 120, self.viewHeight - CGRectGetMaxY(self.descriptionLabel.frame) - 90);
        _interactionImage = [[UIImageView alloc] initWithFrame:frame];
        _interactionImage.contentMode = UIViewContentModeScaleAspectFit;
        
        if (self.index == 0) _interactionImage.image = [UIImage imageNamed:SWIPE_LEFT_RIGHT_ICON];
        else if (self.index == 1) _interactionImage.image = [UIImage imageNamed:SWIPE_UP_ICON];
        else if (self.index == 2) _interactionImage.image = [UIImage imageNamed:SWIPE_LEFT_RIGHT_ICON];
        else if (self.index == 3) _interactionImage.image = [UIImage imageNamed:SWIPE_DOWN_ICON];
        else _interactionImage.image = [UIImage imageNamed:SWIPE_DOWN_ICON];
    }
    return _interactionImage;
}

/**
 * Lazily init the page indicator image
 * @return UIImageView
 */
-(UIImageView *)pageIndicatorImage {
    if (_pageIndicatorImage == nil) {
        _pageIndicatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 50, self.viewWidth, 8)];
        _pageIndicatorImage.contentMode = UIViewContentModeScaleAspectFit;
        
        if (self.index == 0) _pageIndicatorImage.image = [UIImage imageNamed:PAGE_ONE_ICON];
        else if (self.index == 1) _pageIndicatorImage.image = [UIImage imageNamed:PAGE_TWO_ICON];
        else if (self.index == 2) _pageIndicatorImage.image = [UIImage imageNamed:PAGE_THREE_ICON];
        else if (self.index == 3) _pageIndicatorImage.image = [UIImage imageNamed:PAGE_FOUR_ICON];
        else _pageIndicatorImage.image = [UIImage imageNamed:PAGE_FIVE_ICON];
    }
    return _pageIndicatorImage;
}

#pragma mark - public method
-(id)initWithIndex:(int)index {
    self.index = index;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.9];
        self.alpha = 0;
        [self addSubview:[self magpieIcon]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self descriptionLabel]];
        [self addSubview:[self interactionImage]];
        [self addSubview:[self pageIndicatorImage]];
    }
    return self;
}

/**
 * Set the information for the overlay view
 * @param NSString - message
 * @param NSString - action image
 * @param NSString - page indicator
 */
-(void)setInteractionMessage:(NSString *)message imageFileName:(NSString *)imageName andPageIndicatorImageName:(NSString *)pageIndicatorImageName {
    self.titleLabel.text = message;
    self.interactionImage.image = [UIImage imageNamed:imageName];
    self.pageIndicatorImage.image = [UIImage imageNamed:pageIndicatorImageName];
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
    self.pageIndicatorImage.alpha = stayComponentAlpha;
    
    self.titleLabel.alpha = alphaValue;
    self.interactionImage.alpha = alphaValue;
    self.descriptionLabel.alpha = alphaValue;
}
@end
