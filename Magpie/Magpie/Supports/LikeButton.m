//
//  LikeButton.m
//  Magpie
//
//  Created by minh thao nguyen on 6/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LikeButton.h"

static NSString * const LIKE_BUTTON_NORMAL = @"LikeButtonNormal";
static NSString * const LIKE_BUTTON_SELECTED = @"LikeButtonSelected";

@interface LikeButton()
@property (nonatomic, strong) UIImage *nornalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImageView *buttonImageView;
@end

@implementation LikeButton
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nornalImage = [UIImage imageNamed:LIKE_BUTTON_NORMAL];
        self.selectedImage = [UIImage imageNamed:LIKE_BUTTON_SELECTED];
        self.buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:[self buttonImageView]];
    }
    return self;
}

/**
 * Set the like state of the button
 * @param BOOL
 */
-(void)setLike:(BOOL)like {
    if (like) self.buttonImageView.image = self.selectedImage;
    else self.buttonImageView.image = self.nornalImage;
    self.enabled = YES;
}


@end
