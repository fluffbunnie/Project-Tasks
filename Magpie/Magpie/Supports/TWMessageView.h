//
//  TWMessageView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquircleProfileImage.h"

static CGFloat NOTIFICATION_VIEW_HEIGHT = 64;
static CGFloat NOTIFICATION_PADDING_TOP = 20;
static CGFloat NOTIFICATION_AVATAR_SIZE = 34;

@interface TWMessageView : UIView
@property (nonatomic, assign) BOOL hasCallback;
@property (nonatomic, strong) NSArray *callbacks;
@property (nonatomic, assign, getter = isHit) BOOL hit;
@property (nonatomic, assign) CGFloat duration;

-(void)setImageAvatar:(UIImage *)image;
-(void)setImageUrl:(NSString *)imageUrl;
-(void)setTitle:(NSString *)title;
-(void)setDescription:(NSString *)description;
@end
