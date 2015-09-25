//
//  UIScrollWebImageView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/24/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollWebImageView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, assign) BOOL didLoadFullImage;
-(void)setImageUrl:(NSString *)imageUrl;
-(void)setImage:(UIImage *)image;
-(void)enableZooming:(BOOL)enable;
-(void)setViewFrame:(CGRect)frame;
-(void)removeView;
@end
