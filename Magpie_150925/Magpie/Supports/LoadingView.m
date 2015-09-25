//
//  LoadingView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@end

@implementation LoadingView
#pragma mark - initiation
/**
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 143)/2, self.viewHeight/2 - 40, 143, 80)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"Loading" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the loading text
 * @return UILabel
 */
-(UILabel *)loadingText {
    if (_loadingText == nil) {
        _loadingText = [[UILabel alloc] init];
        _loadingText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _loadingText.text = [NSString stringWithFormat:@"%@ .", self.message];
        _loadingText.textColor = [UIColor whiteColor];
        CGSize size = [_loadingText sizeThatFits:CGSizeMake(self.viewWidth, self.viewHeight)];
        _loadingText.frame = CGRectMake((self.viewWidth - size.width)/2 - 1, self.viewHeight/2 + 50, size.width + 10, size.height);
    }
    return _loadingText;
}

#pragma mark - public method
/**
 * Init the view with a loading message
 * @param NSString
 */
-(id)initWithMessage:(NSString *)message {
    self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
    self.viewHeight = [[UIScreen mainScreen] bounds].size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.message = message;
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:[self loadingIcon]];
        [self addSubview:[self loadingText]];
        
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
    }
    return self;
}

/** 
 * Show the loading view on top of the given parent view
 * @param UIView
 */
-(void)showInView:(UIView *)view {
    self.parentView = view;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.parentView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

/**
 * Dismiss the loading view
 */
-(void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        [self removeFromSuperview];
        self.parentView = nil;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark - private method
/**
 * Animate the loading text
 */
-(void)animateLoadingText {
    NSString *oneDot = [NSString stringWithFormat:@"%@ .", self.message];
    NSString *twoDots = [NSString stringWithFormat:@"%@ ..", self.message];
    NSString *threeDots = [NSString stringWithFormat:@"%@ ...", self.message];
    if ([self.loadingText.text isEqualToString:oneDot]) self.loadingText.text = twoDots;
    else if ([self.loadingText.text isEqualToString:twoDots]) self.loadingText.text = threeDots;
    else self.loadingText.text = oneDot;
    
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}

@end
