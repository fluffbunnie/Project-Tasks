//
//  PhotoButton.h
//  Magpie
//
//  Created by minh thao nguyen on 4/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoButton : UIButton
-(id)initWithNormalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage andSelectedImage:(UIImage *)selectedImage andFrame:(CGRect)frame;
@end
