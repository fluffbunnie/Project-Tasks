//
//  AboutViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/31/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "AboutViewController.h"

static NSString * VIEW_TITLE = @"About";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * URL = @"http://getmagpie.com/about";

@interface AboutViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIWebView *aboutWebView;
@end

@implementation AboutViewController
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
 * Lazily init about web view
 * @return UIWebView
 */
-(UIWebView *)aboutWebView {
    if (_aboutWebView == nil) {
        _aboutWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _aboutWebView.backgroundColor = [UIColor whiteColor];
        _aboutWebView.scrollView.bounces = NO;
        NSURL *url = [NSURL URLWithString:URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_aboutWebView loadRequest:request];
    }
    return _aboutWebView;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    [self.view addSubview:[self aboutWebView]];
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


@end
