//
//  ImportPropertyListWebView.m
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "ImportPropertyListWebView.h"

@implementation ImportPropertyListWebView

#pragma mark - public method
-(id)init {
    self = [super initWithFrame:CGRectMake(-100, -100, 50, 50)];
    if (self) {
        self.delegate = self;
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3", @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

/**
 * Tell the webview to start loading the request
 */
-(void)requestLoad {
    NSURL *url = [NSURL URLWithString:@"https://www.airbnb.com/rooms"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}

#pragma mark - web delegate
/**
 * Webview delegate that signal that the webview has finished loading
 * @param webview
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        [self performSelector:@selector(getAirbnbPropertyIdsFromWebview:) withObject:webView afterDelay:0.2];
    }
}

/**
 * Get the airbnb property ids from the web view
 * @param UIWebView
 */
-(void)getAirbnbPropertyIdsFromWebview:(UIWebView *)webView {
    NSString *sourceCode = [[NSString alloc] init];
    @try {
        sourceCode = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    } @finally {
        
        [PythonParsingRequest getAirbnbPidsInSourceCode:sourceCode withCompletionHandler:^(NSArray *pids) {
            [self.webDelegate pidsRequestResult:pids];
            [self removeFromSuperview];
        }];
    }
}

@end
