//
//  TWMessageBarManager.h
//
//  Created by Terry Worona on 5/13/13.
//  Copyright (c) 2013 Terry Worona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TWMessageView.h"

@interface TWMessageBarManager : NSObject 
+ (TWMessageBarManager *)sharedInstance;
-(void)showMessageWithTitle:(NSString *)title description:(NSString *)description icon:(UIImage *)iconImage duration:(CGFloat)duration callback:(void(^)())callback;
-(void)showMessageWithTitle:(NSString *)title description:(NSString *)description iconUrl:(NSString *)iconUrl duration:(CGFloat)duration callback:(void(^)())callback;

- (void)hideAllAnimated:(BOOL)animated;
- (void)hideAll; // non-animated

@end

