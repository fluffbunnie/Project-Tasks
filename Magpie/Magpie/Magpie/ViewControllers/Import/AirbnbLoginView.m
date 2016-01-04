//
//  AirbnbLoginView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "AirbnbLoginView.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "AFHTTPRequestOperation.h"

static NSString * IMPORT_DIRECTION_LABEL = @"Please log in to your Airbnb account. All listings will be automatically imported.";

@interface AirbnbLoginView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) TTTAttributedLabel *importGuide;
@property (nonatomic, strong) UIWebView *airbnbLoginWebView;
@end

@implementation AirbnbLoginView
#pragma mark - initiation
/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)whiteBackgroundView {
    if (_whiteBackgroundView == nil) {
        _whiteBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.viewWidth, self.viewHeight - 64)];
        _whiteBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackgroundView;
}

/**
 * Lazily init the direction for importing
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)importGuide {
    if (_importGuide == nil) {
        _importGuide = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 80, self.viewWidth - 20, 95)];
        _importGuide.numberOfLines = 0;
        _importGuide.lineSpacing = 7;
        _importGuide.textAlignment = NSTextAlignmentCenter;
        _importGuide.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _importGuide.textColor = [FontColor descriptionColor];
        
        [_importGuide setText:IMPORT_DIRECTION_LABEL afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
    
            NSRange airbnbRange = [[mutableAttributedString string] rangeOfString:@"Airbnb"];
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[FontColor themeColor].CGColor range:airbnbRange];
            
            return mutableAttributedString;
        }];
    }
    return _importGuide;
}

/**
 * Init the web view
 * @return webview
 */
-(UIWebView *)airbnbLoginWebView {
    if (_airbnbLoginWebView == nil) {
        _airbnbLoginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64 + 115, self.viewWidth, self.viewHeight - 64 - 115)];
        _airbnbLoginWebView.scrollView.scrollEnabled = YES;
        _airbnbLoginWebView.scrollView.bounces = NO;
        _airbnbLoginWebView.delegate = self;
        [_airbnbLoginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://airbnb.com/login"]]];
    }
    return _airbnbLoginWebView;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self addSubview:[self whiteBackgroundView]];
        [self addSubview:[self importGuide]];
        [self addSubview:[self airbnbLoginWebView]];
        
        self.transform = CGAffineTransformMakeTranslation(0, self.viewHeight);
    }
    return self;
}

/**
 * Show the view. This happen when user click on the login with email
 */
-(void)showView {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

/**
 * Handle behavior when keyboard will show
 */
-(void)keyboardWillShow {
    [UIView animateWithDuration:0.3 animations:^{
        self.whiteBackgroundView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        self.importGuide.transform = CGAffineTransformMakeTranslation(0, -175);
        self.airbnbLoginWebView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    }];
}

/**
 * Handle the behavior when keyboard will hide
 */
-(void)keyboardWillHide {
    [UIView animateWithDuration:0.3 animations:^{
        self.whiteBackgroundView.frame = CGRectMake(0, 64, self.viewWidth, self.viewHeight - 64);
        self.importGuide.transform = CGAffineTransformIdentity;
        self.airbnbLoginWebView.frame = CGRectMake(0, 64 + 115, self.viewWidth, self.viewHeight - 64 - 115);
    }];
}

#pragma mark - view delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    @try {
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"smart-banner\")[0].style.display=\"none\";"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"airbnb-header\")[0].style.display=\"none\";"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"header\").style.display=\"none\";"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"footer\").style.display=\"none\";"];
        
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"body\")[0].style.background=\"#FFFFFF\";"];
    }
    @catch (NSException *exception) {
        //don't do anything
    }
    
    [self fetchUserAirbnbId];
}

#pragma mark - support functions
/**
 * Get the user air bnb id
 */
-(void)fetchUserAirbnbId {
    NSString *url = @"https://www.airbnb.com/users/header_userpic.json";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //get the property info
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer new];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            if (!responseObject[@"error"] && responseObject[@"url"]) {
                NSString *url = responseObject[@"url"];
            
                NSUInteger beginLocation = [url rangeOfString:@"/users/"].location;
                NSUInteger endLocation = [url rangeOfString:@"/profile_pic/"].location;
                
                if (beginLocation != NSNotFound && endLocation != NSNotFound) {
                    NSString *uid = [[url substringToIndex:endLocation] substringFromIndex:beginLocation + 7];
                    [self.webDelegate fetchedUid:uid];
                } else {
                    [self.webDelegate showPhotoRequireMessage];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

#pragma mark - UIAction



@end
