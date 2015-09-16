//
//  ToastView.m
//  Frenvent
//
//  Created by minh thao nguyen on 8/1/14.
//  Copyright (c) 2014 Frenvent. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

float const ToastHeight = 30;
float const ToastGap = 10.0f;

@synthesize textLabel;

/**
 * Show the text label on the bottom of the view
 * @param parent view
 * @param text
 * @param duration
 */
+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration {
    //we clean up any toast view still in the parent view
    for (UIView *subView in [parentView subviews]) {
        if ([subView isKindOfClass:[ToastView class]]) [subView removeFromSuperview];
    }
    
    CGRect parentFrame = parentView.frame;
    
    float yOrigin = parentFrame.size.height - 80;
    ToastView *toast = [[ToastView alloc] initWithFrame:CGRectMake(parentFrame.origin.x + 35, yOrigin, parentFrame.size.width - 70, ToastHeight)];
    toast.backgroundColor = [UIColor blackColor];
    toast.alpha = 0.0f;
    toast.layer.cornerRadius = 10.0f;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toast.frame.size.width - 20, toast.frame.size.height)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
    textLabel.text = text;
    
    [toast setTextLabel:textLabel];
    [parentView addSubview:toast];
    
    [UIView animateWithDuration:0.3 animations:^{
        toast.alpha = 0.3f;
        toast.textLabel.alpha = 0.9f;
    } completion:^(BOOL finished) {
        [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:duration];
    }];
}

/**
 * Show the text label on the top of the view
 * @param parent view
 * @param text
 * @param duration
 */
+ (void)showToastOnTopOfParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration {
    
    //we clean up any toast view still in the parent view
    for (UIView *subView in [parentView subviews]) {
        if ([subView isKindOfClass:[ToastView class]]) [subView removeFromSuperview];
    }
    
    CGRect parentFrame = parentView.frame;
    
    float yOrigin = 50;
    ToastView *toast = [[ToastView alloc] initWithFrame:CGRectMake(parentFrame.origin.x + 35, yOrigin, parentFrame.size.width - 70, ToastHeight)];
    toast.backgroundColor = [UIColor blackColor];
    toast.alpha = 0.0f;
    toast.layer.cornerRadius = 10.0f;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toast.frame.size.width - 20, toast.frame.size.height)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
    textLabel.text = text;
    
    [toast setTextLabel:textLabel];
    [parentView addSubview:toast];
    
    [UIView animateWithDuration:0.3 animations:^{
        toast.alpha = 0.5f;
        toast.textLabel.alpha = 0.9f;
    } completion:^(BOOL finished) {
        [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:duration];
    }];
}

/**
 * Show the text label at the center of the view
 * @param parent view
 * @param text
 * @param duration
 */
+(void)showToastAtCenterOfView:(UIView *)parentView withText:(NSString *)text withDuration:(float)duration {
    //we clean up any toast view still in the parent view
    for (UIView *subView in [parentView subviews]) {
        if ([subView isKindOfClass:[ToastView class]]) [subView removeFromSuperview];
    }
    
    CGRect parentFrame = parentView.frame;
    
    float yOrigin = parentFrame.size.height/2 - 15;
    ToastView *toast = [[ToastView alloc] initWithFrame:CGRectMake(parentFrame.origin.x + 35, yOrigin, parentFrame.size.width - 70, ToastHeight)];
    toast.backgroundColor = [UIColor blackColor];
    toast.alpha = 0.0f;
    toast.layer.cornerRadius = 10.0f;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toast.frame.size.width - 20, toast.frame.size.height)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
    textLabel.text = text;
    
    [toast setTextLabel:textLabel];
    [parentView addSubview:toast];
    
    [UIView animateWithDuration:0.3 animations:^{
        toast.alpha = 0.5f;
        toast.textLabel.alpha = 0.9f;
    } completion:^(BOOL finished) {
        [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:duration];
    }];
}

#pragma mark - nonstatic class
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTextLabel:(UILabel *)theTextLabel {
    textLabel = theTextLabel;
    [self addSubview:theTextLabel];
}

- (void)hideSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.textLabel.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
        }
    }];
}


@end
