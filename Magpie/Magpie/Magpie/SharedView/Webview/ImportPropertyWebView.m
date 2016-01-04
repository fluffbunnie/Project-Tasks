//
//  ImportPropertyWebView.m
//  Easyswap
//
//  Created by minh thao nguyen on 1/31/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "ImportPropertyWebView.h"
#import "PropertyRequest.h"
#import "Property.h"

@interface ImportPropertyWebView()
@property (nonatomic, strong) PropertyRequest *propertyRequest;
@property (nonatomic, strong) NSString *airbnbPid;
@property (nonatomic, assign) BOOL webLoaded;
@end

@implementation ImportPropertyWebView
#pragma mark - initiation
/**
 * Init the property request
 * @return property request
 */
-(PropertyRequest *)propertyRequest {
    if (_propertyRequest == nil) {
        _propertyRequest = [[PropertyRequest alloc] init];
        _propertyRequest.delegate = self;
    }
    return _propertyRequest;
}

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
        self.webLoaded = NO;
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
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    if (!self.webLoaded && readyState != nil && [readyState isEqualToString:@"complete"]) {
        self.webLoaded = YES;
        [self performSelector:@selector(getPropertyInfoFromWebView:) withObject:webView afterDelay:0.2];
    }
}

-(void)getPropertyInfoFromWebView:(UIWebView *)webView {
    NSString *sourceCode = [[NSString alloc] init];
    @try {
        sourceCode = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('room').innerHTML"];
    } @finally {
        [[self propertyRequest] requestPropertyInfoOfProperty:self.airbnbPid usingSourceCode:sourceCode];
    }
}

#pragma mark - request delegate
/**
 * Delegate result for the property
 * @param property
 */
-(void)propertyRequestResult:(Property *)property {
    [self.importWebDelegate propertyRequestResult:property];
    [self removeFromSuperview];
}

@end
