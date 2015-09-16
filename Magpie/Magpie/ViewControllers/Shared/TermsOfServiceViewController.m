//
//  TermsOfServiceViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "FontColor.h"

static NSString * VIEW_TITLE = @"Terms of Service";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * URL = @"http://getmagpie.com/terms";

@interface TermsOfServiceViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIWebView *termsWebView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation TermsOfServiceViewController
#pragma mark - initiation
/**
 * Lazily init the back button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goBack)];
    }
    return _backButton;
}

/**
 * Lazily init terms web view
 * @return UIWebView
 */
-(UIWebView *)termsWebView {
    if (_termsWebView == nil) {
        _termsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _termsWebView.backgroundColor = [UIColor whiteColor];
        _termsWebView.scrollView.bounces = NO;
        _termsWebView.delegate = self;
        NSURL *url = [NSURL URLWithString:URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_termsWebView loadRequest:request];
    }
    return _termsWebView;
}

/**
 * Lazily init the spinner
 * @return UIActivityIndicatorView
 */
-(UIActivityIndicatorView *)spinner {
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 25, self.screenHeight/2, 50, 50)];
        _spinner.color = [FontColor titleColor];
        _spinner.hidesWhenStopped = YES;
    }
    return _spinner;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    [self.view addSubview:[self termsWebView]];
    [self.view addSubview:[self spinner]];
    [self.spinner startAnimating];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - UIGesture
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - web delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];
}



@end