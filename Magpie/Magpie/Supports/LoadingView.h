//
//  LoadingView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
-(id)initWithMessage:(NSString *)message;
-(void)showInView:(UIView *)view;
-(void)dismiss;
@end
