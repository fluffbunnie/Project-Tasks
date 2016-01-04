//
//  TWMessageView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TWMessageView.h"
#import "FontColor.h"

@interface TWMessageView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) SquircleProfileImage *notifIcon;
@property (nonatomic, strong) UILabel * notifTitle;
@property (nonatomic, strong) UILabel * notifDescription;
@end


@implementation TWMessageView
#pragma mark - initiation
/**
 * Lazily init the notification image
 * @return SquicleProfileImage
 */
-(SquircleProfileImage *)notifIcon {
    if (_notifIcon == nil) {
        _notifIcon = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(10, NOTIFICATION_PADDING_TOP + 5, NOTIFICATION_AVATAR_SIZE, NOTIFICATION_AVATAR_SIZE)];
    }
    return _notifIcon;
}

/**
 * Lazily init the notification title
 * @return UILabel
 */
-(UILabel *)notifTitle {
    if (_notifTitle == nil) {
        _notifTitle = [[UILabel alloc] initWithFrame:CGRectMake(20 + NOTIFICATION_AVATAR_SIZE, NOTIFICATION_PADDING_TOP + 4, self.viewWidth - 40 - NOTIFICATION_AVATAR_SIZE, 20)];
        _notifTitle.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        _notifTitle.textColor = [FontColor titleColor];
    }
    return _notifTitle;
}

/**
 * Lazily init the notification description
 * @return UILabel
 */
-(UILabel *)notifDescription {
    if (_notifDescription == nil) {
        _notifDescription = [[UILabel alloc] initWithFrame:CGRectMake(20 + NOTIFICATION_AVATAR_SIZE, NOTIFICATION_PADDING_TOP + 24, self.viewWidth - 40 - NOTIFICATION_AVATAR_SIZE, 16)];
        _notifDescription.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _notifDescription.textColor = [FontColor titleColor];
    }
    return _notifDescription;
}

#pragma mark - public methods
-(id)init {
    self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, NOTIFICATION_VIEW_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.userInteractionEnabled = YES;
        [self addSubview:[self notifIcon]];
        [self addSubview:[self notifTitle]];
        [self addSubview:[self notifDescription]];
        
        self.hasCallback = NO;
        self.hit = NO;
    }
    return self;
}

/**
 * Set the avatar image
 * @return UIImage
 */
-(void)setImageAvatar:(UIImage *)image {
    self.notifIcon.image = image;
}

/**
 * Set the avatar image using the url
 * @return NSString
 */
-(void)setImageUrl:(NSString *)imageUrl {
    [self.notifIcon setProfileImageWithUrl:imageUrl];
}

/**
 * Set the title of the notification
 * @param NSString
 */
-(void)setTitle:(NSString *)title {
    self.notifTitle.text = title;
}

/**
 * set the notification description
 * @param NSString
 */
-(void)setDescription:(NSString *)description {
    self.notifDescription.text = description;
}

@end
