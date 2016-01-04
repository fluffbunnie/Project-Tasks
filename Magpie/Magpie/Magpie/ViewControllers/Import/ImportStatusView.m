//
//  ImportStatusView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportStatusView.h"
#import "FontColor.h"

static NSString *LOADING_TEXT = @"Importing";
static NSString *PLEASE_WAIT = @"Please wait while we import your airbnb's listings.";

@interface ImportStatusView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *loadingContainer;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingMessage;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *askForWaitingMessage;
@end

@implementation ImportStatusView
#pragma mark - initiation
/**
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight / 2 - 90, self.viewWidth, 80)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"LoadingDark" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the loading message
 * @return UILabel
 */
-(UILabel *)loadingMessage {
    if (_loadingMessage == nil) {
        _loadingMessage = [[UILabel alloc] init];
        _loadingMessage.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
        _loadingMessage.text = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
        _loadingMessage.textColor = [FontColor titleColor];
        CGSize size = [_loadingMessage sizeThatFits:CGSizeMake(self.viewWidth, self.viewHeight)];
        _loadingMessage.frame = CGRectMake((self.viewWidth - size.width)/2 - 1, self.viewHeight/2, size.width + 10, size.height);
    }
    return _loadingMessage;
}

/**
 * Lazily init the progress label
 * @return UILabel
 */
-(UILabel *)progressLabel {
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.viewHeight/2 + 33, self.viewWidth - 60, 30)];
        _progressLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [FontColor descriptionColor];
        _progressLabel.numberOfLines = 0;
    }
    return _progressLabel;
}

/**
 * Lazily init the 'ask for waiting' message
 * @return UILabel
 */
-(UILabel *)askForWaitingMessage {
    if (_askForWaitingMessage == nil) {
        _askForWaitingMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewHeight - 50, self.viewWidth, 20)];
        _askForWaitingMessage.textAlignment = NSTextAlignmentCenter;
        _askForWaitingMessage.textColor = [FontColor descriptionColor];
        _askForWaitingMessage.text = PLEASE_WAIT;
        _askForWaitingMessage.numberOfLines = 0;
        _askForWaitingMessage.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    }
    return _askForWaitingMessage;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self addSubview:[self loadingIcon]];
        [self addSubview:[self loadingMessage]];
        [self addSubview:[self askForWaitingMessage]];
        [self addSubview:[self progressLabel]];
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
    }
    return self;
}

/**
 * Set the progress text for the importing view
 * @param NSString
 */
-(void)setProgressText:(NSString *)progressText {
    self.progressLabel.text = progressText;
    CGSize fitSize = [self.progressLabel sizeThatFits:CGSizeMake(self.viewWidth - 60, FLT_MAX)];
    self.progressLabel.frame = CGRectMake(30, self.viewHeight/2 + 33, self.viewWidth - 60, fitSize.height);
}

#pragma mark - private method
/**
 * Animate the loading text
 */
-(void)animateLoadingText {
    NSString *oneDot = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
    NSString *twoDots = [NSString stringWithFormat:@"%@ ..", LOADING_TEXT];
    NSString *threeDots = [NSString stringWithFormat:@"%@ ...", LOADING_TEXT];
    if ([self.loadingMessage.text isEqualToString:oneDot]) {
        self.loadingMessage.text = twoDots;
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
    } else if ([self.loadingMessage.text isEqualToString:twoDots]) {
        self.loadingMessage.text = threeDots;
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
    } else if ([self.loadingMessage.text isEqualToString:threeDots]){
        self.loadingMessage.text = oneDot;
        [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
    }
}

@end
