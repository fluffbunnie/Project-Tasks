//
//  PropertyDetailAboutUserTableViewCell.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/23/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailAboutUserTableViewCell.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTTAttributedLabel.h"

#define DEFAULT_HEIGHT 200

@interface PropertyDetailAboutUserTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) NSString *descriptionText;

@property (nonatomic, strong) TTTAttributedLabel *userDescriptionLabel;
@property (nonatomic, strong) UIButton *goToUserProfileButton;
@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic) BOOL expanded;
@end

@implementation PropertyDetailAboutUserTableViewCell
#pragma mark - initiation
/**
 * Lazily init user description label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)userDescriptionLabel {
    if (_userDescriptionLabel == nil) {
        _userDescriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(25, 0, self.viewWidth - 50, DEFAULT_HEIGHT)];
        _userDescriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _userDescriptionLabel.textColor = [FontColor titleColor];
        _userDescriptionLabel.lineSpacing = 4;
        _userDescriptionLabel.userInteractionEnabled = YES;
        _userDescriptionLabel.numberOfLines = 0;
        _userDescriptionLabel.clipsToBounds = YES;
        
        UITapGestureRecognizer *descriptionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutUserTextExpand)];
        [_userDescriptionLabel addGestureRecognizer:descriptionTap];
    }
    return _userDescriptionLabel;
}

/**
 * Lazily init the go to user profile button
 * @return UIButton
 */
-(UIButton *)goToUserProfileButton {
    if (_goToUserProfileButton == nil) {
        _goToUserProfileButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth/2 - 100, 0, 200, 25)];
        _goToUserProfileButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:13];
        [_goToUserProfileButton setTitle:@"Edit your user profile" forState:UIControlStateNormal];
        [_goToUserProfileButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_goToUserProfileButton setTitleColor:[FontColor titleColor] forState:UIControlStateHighlighted];
        [_goToUserProfileButton addTarget:self action:@selector(goToUserProfileButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _goToUserProfileButton.hidden = YES;
    }
    return _goToUserProfileButton;
}

/**
 * Lazily init the gradient view
 * @return CALayer
 */
-(CAGradientLayer *)gradient {
    if (_gradient == nil) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, DEFAULT_HEIGHT - 40, self.viewWidth - 50, 40);
        _gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    }
    return _gradient;
}

#pragma mark - public method
-(id)init {
    self = [super init];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self.contentView addSubview:[self userDescriptionLabel]];
        [self.userDescriptionLabel.layer addSublayer:[self gradient]];
        [self.contentView addSubview:[self goToUserProfileButton]];
    }
    return self;
}

/**
 * Set the user object, expand or collapse the view if necessary
 * @param PFObject
 */
-(void)setUserObject:(PFObject *)userObj {
    self.expanded = NO;
    self.gradient.hidden = NO;
    self.descriptionText = userObj[@"description"] ? userObj[@"description"] : @"";
    self.userDescriptionLabel.text = self.descriptionText;
    
    if (self.descriptionText.length == 0) {
        self.userDescriptionLabel.frame = CGRectZero;
        if (self.shouldAllowUserToEditProfile) self.goToUserProfileButton.hidden = NO;
    } else self.goToUserProfileButton.hidden = YES;
    
    CGSize textViewSize = [self.userDescriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)];
    if (textViewSize.height <= DEFAULT_HEIGHT ) {
        self.userDescriptionLabel.frame = CGRectMake(25, 0, self.viewWidth - 50, textViewSize.height);
        self.gradient.hidden = YES;
    } else {
        self.userDescriptionLabel.frame = CGRectMake(25, 0, self.viewWidth - 50, DEFAULT_HEIGHT);
        self.gradient.hidden = NO;
    }
    
    [self.delegate refreshTable];

}

/**
 * Get the view height
 * @return the height of the view
 */
-(CGFloat)viewHeight {
    if (self.descriptionText.length > 0) {
        CGFloat textViewHeight = DEFAULT_HEIGHT;
        CGSize textViewSize = [self.userDescriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)];
        if (textViewSize.height <= DEFAULT_HEIGHT || self.expanded) textViewHeight = textViewSize.height;
        
        return textViewHeight;
    } else if (self.shouldAllowUserToEditProfile) return 25;
    return 0;
}

#pragma mark- gesture recognizer actions
/**
 * Recognize the click and expand the description view height
 */
-(void)aboutUserTextExpand {
    if (!self.expanded && !self.gradient.hidden) {
        self.expanded = YES;
        self.gradient.hidden = YES;
        CGSize textViewSize = [self.userDescriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)];
        self.userDescriptionLabel.frame = CGRectMake(25, 0, self.viewWidth - 50, textViewSize.height);
        
        [self.delegate refreshTable];
    }
}

/**
 * Handle the behavior when user click on go to user profile button
 */
-(void)goToUserProfileButtonClick {
    [self.delegate goToUserProfile];
}

@end
