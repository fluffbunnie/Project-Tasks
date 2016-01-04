//
//  ImportPropertyListWebView.h
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PythonParsingRequest.h"

@protocol ImportPropertyListWebViewDelegate <NSObject>
-(void)pidsRequestResult:(NSArray *)pids;
@end

@interface ImportPropertyListWebView : UIWebView <UIWebViewDelegate>
@property (nonatomic, weak) id<ImportPropertyListWebViewDelegate> webDelegate;
-(void)requestLoad;
@end
