//
//  PreviewMenuSignupView.h
//  Magpie
//
//  Created by minh thao nguyen on 4/24/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewMenuSignupViewDelegate <NSObject>

-(void)previewSignupClick;
-(void)previewLoginClick;

@end

@interface PreviewMenuSignupView : UIView

@property (nonatomic, weak) id<PreviewMenuSignupViewDelegate> signupPreviewDelegate;

-(void)setBackGroundImage:(UIImage *)backgroundImage
                iconImage:(UIImage *)iconImage
                    title:(NSString *)title
           andDescription:(NSString *)description;
@end
