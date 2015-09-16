//
//  UIStaticScrollingImageView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "UIStaticScrollingImageView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const DEFAULT_Y_OFFSET = 100;
static CGFloat const DEFAULT_DURATION = 20;

@interface UIStaticScrollingImageView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) UIImageView *animatedImage;
@end

@implementation UIStaticScrollingImageView
#pragma mark - initiation
/**
 * Lazily init the animated view
 * @return UIImageView
 */
-(UIImageView *)animatedImage {
    if (_animatedImage == nil) {
        _animatedImage = [[UIImageView alloc] init];
        _animatedImage.contentMode = UIViewContentModeScaleAspectFill;
        _animatedImage.layer.masksToBounds = YES;
        _animatedImage.clipsToBounds = YES;
    }
    return _animatedImage;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        [self addSubview:[self animatedImage]];
        self.yOffset = DEFAULT_Y_OFFSET;
        self.duration = DEFAULT_DURATION;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self.viewWidth = frame.size.width;
    self.viewHeight = frame.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        [self addSubview:[self animatedImage]];
        self.yOffset = DEFAULT_Y_OFFSET;
        self.duration = DEFAULT_DURATION;
    }
    return self;
}

/**
 * Set the image and its panning parameters
 * @param UIImage
 * @param CGFloat
 * @param CGFloat
 */
-(void)setImage:(UIImage *)image yOffset:(CGFloat)yOffset andPanDuration:(CGFloat)duration {
    self.animatedImage.frame = CGRectMake(-yOffset, 0, self.viewWidth + 2 * yOffset, self.viewHeight);
    self.yOffset = yOffset;
    self.duration = duration;
    self.animatedImage.image = image;
    self.animatedImage.transform = CGAffineTransformIdentity;
}

/**
 * Set the image but using its existing panning parameters
 * @param UIImage
 */
-(void)setImage:(UIImage *)image {
    self.animatedImage.image = image;
    self.animatedImage.transform = CGAffineTransformIdentity;
}

/**
 * Perform the panning animation
 */
-(void)doAnimation {
    @try {
        [self.layer removeAllAnimations];
        for (CALayer *l in self.layer.sublayers) {
            [l removeAllAnimations];
        }
    } @finally {
        [UIView animateWithDuration:self.duration / 2
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.animatedImage.transform = CGAffineTransformMakeTranslation(-self.yOffset, 0);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:self.duration // twice as long!
                                                       delay:0.0
                                                     options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse
                                                  animations:^{
                                                      self.animatedImage.transform = CGAffineTransformMakeTranslation(self.yOffset, 0);
                                                  }
                                                  completion:nil
                                  ];
                             }
                         }
         ];
    }
}

/**
 * Remove all animations
 */
-(void)stopAnimation {
    [self.layer removeAllAnimations];
    for (CALayer *l in self.layer.sublayers) {
        [l removeAllAnimations];
    }
    self.animatedImage.transform = CGAffineTransformIdentity;
}

@end
