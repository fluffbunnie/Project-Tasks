//
//  PropertyListWebView.h
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRequest.h"

@protocol PropertyListWebViewDelegate <NSObject>
-(void)pidsRequestResult:(NSMutableArray *)pids;
@end

@interface PropertyListWebView : UIWebView <UIWebViewDelegate, UserRequestDelegate>

@property (nonatomic, weak) id<PropertyListWebViewDelegate> propertyListDelegate;
-(void)requestLoad;

@end
