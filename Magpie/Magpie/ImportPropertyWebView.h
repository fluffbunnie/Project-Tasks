//
//  ImportPropertyWebView.h
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"
#import "PythonParsingRequest.h"

@protocol ImportPropertyWebViewDelegate <NSObject>
-(void)propertyRequestResult:(Property *)property;
@end

@interface ImportPropertyWebView : UIWebView <UIWebViewDelegate>

@property (nonatomic, weak) id<ImportPropertyWebViewDelegate> importWebDelegate;
-(id)initWithPid:(NSString *)pid;
-(void)requestLoad;

@end
