//
//  PreviewMenuSignupView.m
//  Magpie
//
//  Created by minh thao nguyen on 4/24/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PreviewMenuSignupView.h"
#import "FontColor.h"
#import "TTTAttributedLabel.h"
#import "RoundButton.h"
#import "UnderLineButton.h"

static NSString * SIGN_UP_BUTTON_TEXT = @"Sign up now";
static NSString * LOG_IN_BUTTON_TEXT = @"I already have an account";

@interface PreviewMenuSignupView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;

@property (nonatomic, strong) RoundButton *signupButton;
@property (nonatomic, strong) UnderLineButton *loginButton;

@end

@implementation PreviewMenuSignupView

#pragma mark -initiation
/**
 * Lazily init the background image
 * @return UIImage
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

/**
 * Lazily init the gradient view
 * @return UIView
 */
-(UIView *)gradientView {
    if (_gradientView == nil) {
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        
        //we also add a dark gradient to the view to make the text popped out more
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0.75] CGColor], (id)[[UIColor colorWithWhite:1 alpha:0.93] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        [_gradientView.layer addSublayer:gradient];
    }
    return _gradientView;
}

/**
 * Lazily init the icon image view
 * @return UIImageView
 */
-(UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 340, self.viewWidth, 60)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.viewHeight - 260, self.viewWidth - 30, 30)];
        _titleLabel.textAlignment =  NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _titleLabel.textColor = [FontColor titleColor];
    }
    return _titleLabel;
}

/**
 * Lazily init the description label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake((self.viewWidth - 265)/2, self.viewHeight - 215, 265, 60)];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineSpacing = 10;
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [FontColor descriptionColor];
    }
    return _descriptionLabel;
}

/**
 * Lazily init the signup button
 * @return UIButton
 */
-(RoundButton *)signupButton {
    if (_signupButton == nil) {
        _signupButton = [[RoundButton alloc] initWithFrame:CGRectMake(45, self.viewHeight - 130, self.viewWidth - 90, 50)];
        [_signupButton setTitle:SIGN_UP_BUTTON_TEXT forState:UIControlStateNormal];
        [_signupButton addTarget:self action:@selector(signupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

/**
 * Lazily init the login button
 * @return UIButton
 */
-(UnderLineButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UnderLineButton createButton];
        _loginButton.frame = CGRectMake((self.viewWidth - 180) / 2, self.viewHeight - 60, 180, 20);
        [_loginButton setTitle:LOG_IN_BUTTON_TEXT forState:UIControlStateNormal];
        [_loginButton sizeToFit];
        CGFloat loginButtonWidth = _loginButton.frame.size.width;
        _loginButton.frame = CGRectMake((self.viewWidth - loginButtonWidth) / 2, self.viewHeight - 60, loginButtonWidth, 20);
        [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}


#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self addSubview:[self backgroundImageView]];
        [self addSubview:[self gradientView]];
        [self addSubview:[self iconImageView]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self descriptionLabel]];
        [self addSubview:[self signupButton]];
        [self addSubview:[self loginButton]];
    }
    return self;
}

/**
 * Set the background image, icon image, title, and description for this view
 * @param UIImage backgroundImage
 * @param UIImage iconImage
 * @param NSString title
 * @param NSString description
 */
-(void)setBackGroundImage:(UIImage *)backgroundImage
                iconImage:(UIImage *)iconImage
                    title:(NSString *)title
           andDescription:(NSString *)description {
    CGFloat backgroundRatio = backgroundImage.size.height/backgroundImage.size.width;
    self.backgroundImageView.frame = CGRectMake(0, 64, self.viewWidth, self.viewWidth * backgroundRatio);
    self.backgroundImageView.image = backgroundImage;
    
    self.iconImageView.image = iconImage;
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}

#pragma mark - button selection
/**
 * Handle the behavior when the user tap on the sign up button
 */
-(void)signupButtonClicked {
    [self.signupPreviewDelegate previewSignupClick];
}

/**
 * Handle the behavior when the user tap on the login button
 */
-(void)loginButtonClicked {
    [self.signupPreviewDelegate previewLoginClick];
}

@end
