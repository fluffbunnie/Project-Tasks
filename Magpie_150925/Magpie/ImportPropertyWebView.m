//
//  ImportPropertyWebView.m
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "ImportPropertyWebView.h"

@interface ImportPropertyWebView()
@property (nonatomic, strong) NSString *airbnbPid;
@end

@implementation ImportPropertyWebView
#pragma mark - public method
/**
 * Init the webview with a given pid
 * @param pid
 */
-(id)initWithPid:(NSString *)pid {
    self = [super initWithFrame:CGRectMake(-100, -100, 50, 50)];
    if (self) {
        self.delegate = self;
        self.airbnbPid = pid;
    }
    return self;
}

/**
 * Tell to web view to start loading request
 */
-(void)requestLoad {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.airbnb.com/rooms/%@", self.airbnbPid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

#pragma mark - web view delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        [self performSelector:@selector(getPropertyInfoFromWebView:) withObject:webView afterDelay:0.2];
    }
}

-(void)getPropertyInfoFromWebView:(UIWebView *)webView {
    NSString *sourceCode = [[NSString alloc] init];
    @try {
        sourceCode = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('room').innerHTML"];
    } @finally {
        [PythonParsingRequest getAirbnbPropertyInfoForPropertyWithPid:self.airbnbPid andSourceCode:sourceCode withCompletionHandler:^(Property *property) {
            [self.importWebDelegate propertyRequestResult:property];
            [self removeFromSuperview];
        }];
    }
}

@end
