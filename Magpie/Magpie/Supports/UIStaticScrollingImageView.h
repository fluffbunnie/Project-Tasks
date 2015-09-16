//
//  UIStaticScrollingImageView.h
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStaticScrollingImageView : UIView
-(void)setImage:(UIImage *)image yOffset:(CGFloat)yOffset andPanDuration:(CGFloat)duration;
-(void)setImage:(UIImage *)image;
-(void)doAnimation;
-(void)stopAnimation;
@end
