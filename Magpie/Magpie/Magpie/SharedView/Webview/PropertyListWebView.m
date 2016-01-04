//
//  PropertyListWebView.m
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "PropertyListWebView.h"
#import "UserRequest.h"

@interface PropertyListWebView()
@property (nonatomic, strong) UserRequest *userRequest;
@property (nonatomic, assign) BOOL webLoaded;
@end

@implementation PropertyListWebView
#pragma mark - initiation
/**
 * Init the user request
 * @return user request
 */
-(UserRequest *)userRequest {
    if (_userRequest == nil) {
        _userRequest = [[UserRequest alloc] init];
        _userRequest.delegate = self;
    }
    return _userRequest;
}

#pragma mark - public method
-(id)init {
    self = [super initWithFrame:CGRectMake(-100, -100, 50, 50)];
    if (self) {
        self.webLoaded = NO;
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
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    if (!self.webLoaded && readyState != nil && [readyState isEqualToString:@"complete"]) {
        self.webLoaded = YES;
        NSString *sourceCode = [[NSString alloc] init];
        @try {
            sourceCode = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        } @finally {
            [[self userRequest] requestPidsUsingSourceCode:sourceCode];
        }
    }
}

#pragma mark - user request delegate
/**
 * Get the list of pids of a given user
 * @param pid
 */
-(void)userPropertyRequestResult:(NSMutableArray *)pids {
    [self.propertyListDelegate pidsRequestResult:pids];
    [self removeFromSuperview];
}

@end
