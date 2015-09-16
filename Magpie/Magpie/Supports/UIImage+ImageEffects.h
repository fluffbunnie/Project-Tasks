//
//  UIImage +ImageEffects
//  Easyswap
//
//  Created by minh thao nguyen on 12/9/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

@import UIKit;

@interface UIImage (ImageEffects)

- (UIImage *)applyBlur:(CGFloat)radius tintColor:(UIColor *)tintColor;
- (UIImage *)colorizeImageWithColor:(UIColor *)color;
- (UIImage*)scaleToSizeKeepAspect:(CGSize)size;
@end
