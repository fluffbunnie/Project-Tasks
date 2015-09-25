//
//  MenuHeaderPostLoggedIn.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MenuHeaderPostLoggedIn.h"
#import "FontColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SquircleProfileImage.h"
#import "UserManager.h"

static NSString * VIEW_PROFILE_LABEL_TEXT =@"View Profile";

@interface MenuHeaderPostLoggedIn()
@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *viewProfileLabel;
@end

@implementation MenuHeaderPostLoggedIn
#pragma mark - initiation
/**
 * Lazily init the profile image
 * @return UIImageView
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(90, 74, 70, 70)];
    }
    return _profileImage;
}

/**
 * Lazily init the name label
 * @return UILabel
 */
-(UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 154, 190, 25)];
        _nameLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _nameLabel.textColor = [FontColor titleColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

/**
 * Lazily init the view profile label
 * @return UILabel
 */
-(UILabel *)viewProfileLabel {
    if (_viewProfileLabel == nil) {
        _viewProfileLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 184, 190, 20)];
        _viewProfileLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _viewProfileLabel.textColor = [FontColor descriptionColor];
        _viewProfileLabel.textAlignment = NSTextAlignmentCenter;
        _viewProfileLabel.text = VIEW_PROFILE_LABEL_TEXT;
    }
    return _viewProfileLabel;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self profileImage]];
        [self addSubview:[self nameLabel]];
        [self addSubview:[self viewProfileLabel]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileClicked)];
        [self addGestureRecognizer:tapGesture];

        [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
            self.userObj = userObj;
            [self reload];
        }];
    }
    return self;
}

/**
 * Update the new user object
 */
-(void)reload {
    self.nameLabel.text = [UserManager getUserNameFromUserObj:self.userObj];
    NSString *profileUrl = self.userObj[@"profilePic"] ? self.userObj[@"profilePic"] : nil;
    [self.profileImage setProfileImageWithUrl:profileUrl];
}

/**
 * Handle the touch gesture on the view.
 * ie. when user pressed on the profile
 */
-(void)userProfileClicked {
    [self.menuHeaderDelegate profileClicked];
}

@end
