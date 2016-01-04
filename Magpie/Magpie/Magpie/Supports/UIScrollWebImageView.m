//
//  UIScrollWebImageView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/24/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "UIScrollWebImageView.h"
#import "FontColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIScrollWebImageView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation UIScrollWebImageView
#pragma mark - initiation
/**
 * lazily init the image view
 * @return UIImageView
 */
-(UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds =YES;
        _imageView.backgroundColor = [FontColor defaultBackgroundColor];
    }
    return _imageView;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.delegate = self;
        self.backgroundColor = [FontColor tableSeparatorColor];
        self.scrollsToTop = NO;
        self.clipsToBounds = YES;
        self.scrollEnabled = YES;
       
        self.minimumZoomScale = 1;
        self.bounces = NO;
        self.bouncesZoom = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self addSubview:[self imageView]];
    }
    return self;
}

-(void)dealloc {
    self.delegate = nil;
}

-(void)removeView {
    [self.imageView removeFromSuperview];
    self.delegate = nil;
    [self removeFromSuperview];
}

/**
 * Enable/disable zooming
 * @param BOOL
 */
-(void)enableZooming:(BOOL)enable{
    if (enable) {
        self.maximumZoomScale = 3;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.maximumZoomScale = 1;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

/**
 * Set the image url to be display
 * @param NSString
 */
-(void)setImageUrl:(NSString *)imageUrl {
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
}

/**
 * Set the image to be display
 * @param UIImage
 */
-(void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

/**
 * Set the frame of the view
 * @param CGRect
 */
-(void)setViewFrame:(CGRect)frame {
    [self setZoomScale:1];
    self.frame = frame;
    self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

#pragma mark - inherit and delegate methods
/**
 * UIScrollView delegate
 * View for zooming in/out of the scroll view
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    scrollView.contentSize = CGSizeMake(scale * self.frame.size.width, scale * self.frame.size.height);
}


@end
