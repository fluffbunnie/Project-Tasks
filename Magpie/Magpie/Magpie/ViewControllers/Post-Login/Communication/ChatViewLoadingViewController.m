//
//  ChatViewLoadingViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ChatViewLoadingViewController.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MyMessageViewController.h"
#import "ErrorMessageDisplay.h"
#import "UserManager.h"
#import "ChatViewController.h"
#import "HomePageViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";
static NSString * const LOADING_TEXT = @"Checking your trip status";

@interface ChatViewLoadingViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *blurredBackgroundImage;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation ChatViewLoadingViewController

#pragma mark - initiation
/**
 * Lazily init the blurred background image
 * @return UIImageView
 */
-(UIImageView *)blurredBackgroundImage {
    if (_blurredBackgroundImage == nil) {
        _blurredBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _blurredBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *normalImage = [UIImage imageNamed:SIGNUP_BACKGROUND_IMAGE_BLURRED];
        UIImage *blurredImage = [normalImage applyBlur:10 tintColor:[UIColor colorWithWhite:0 alpha:0.2]];
        _blurredBackgroundImage.image = blurredImage;
    }
    return _blurredBackgroundImage;
}

/**
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.screenHeight/2 - 60, self.screenWidth, 100)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"Loading" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the loading text
 * @return UILabel
 */
-(UILabel *)loadingText {
    if (_loadingText == nil) {
        _loadingText = [[UILabel alloc] init];
        _loadingText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _loadingText.text = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
        _loadingText.textColor = [UIColor whiteColor];
        CGSize size = [_loadingText sizeThatFits:CGSizeMake(self.screenWidth, self.screenHeight)];
        _loadingText.frame = CGRectMake((self.screenWidth - size.width)/2 - 1, self.screenHeight/2 + 60, size.width + 10, size.height);
    }
    return _loadingText;
}

#pragma mark - public methods
-(void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self blurredBackgroundImage]];
    [self.view addSubview:[self loadingIcon]];
    [self.view addSubview:[self loadingText]];
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.startTime = [[[NSDate alloc] init] timeIntervalSince1970];
    [self checkTripStatus];
}

#pragma mark - helper methods
/**
 * Check the trip status
 */
-(void)checkTripStatus {
    if (self.tripId.length > 0) {
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Trip"];
        [query whereKey:@"objectId" equalTo:self.tripId];
        [query includeKey:@"guest"];
        [query includeKey:@"host"];
        [query includeKey:@"place"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                    if (userObj) {
                        PFObject *tripObj = objects[0];
                        PFObject *guestObj = tripObj[@"guest"];
                        PFObject *hostObj = tripObj[@"host"];
                        PFObject *placeObj = tripObj[@"place"];
                        
                        ChatViewController *chatViewController = [[ChatViewController alloc] init];
                        chatViewController.userObj = userObj;
                        if ([guestObj.objectId isEqualToString:userObj.objectId]) {
                            chatViewController.targetUserObj = hostObj;
                            chatViewController.targetPropertyObj = placeObj;
                        } else chatViewController.targetUserObj = guestObj;
                        chatViewController.tripObj = tripObj;
                        
                        NSTimeInterval currentTime = [[[NSDate alloc] init] timeIntervalSince1970];
                        if (currentTime - self.startTime > 1) [self goToChatView:chatViewController];
                        else [self performSelector:@selector(goToChatView:) withObject:chatViewController afterDelay:1 - (currentTime - self.startTime)];
                    } else [self goBackWithErrorTitle:@"Unknown error"];
                }];
            } else [self goBackWithErrorTitle:@"Network error"];
        }];
    } else [self goBackWithErrorTitle:@"Unknown error"];
}

/**
 * Helper method to go into the chat view controller
 * @param ChatViewController
 */
-(void)goToChatView:(ChatViewController *)viewController {
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers insertObject:viewController atIndex:viewControllers.count - 1];
    self.navigationController.viewControllers = viewControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Animate the loading text
 */
-(void)animateLoadingText {
    NSString *oneDot = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
    NSString *twoDots = [NSString stringWithFormat:@"%@ ..", LOADING_TEXT];
    NSString *threeDots = [NSString stringWithFormat:@"%@ ...", LOADING_TEXT];
    if ([self.loadingText.text isEqualToString:oneDot]) self.loadingText.text = twoDots;
    else if ([self.loadingText.text isEqualToString:twoDots]) self.loadingText.text = threeDots;
    else self.loadingText.text = oneDot;
    
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}
        
/**
 * Something goest wrong, so go back
 */
-(void)goBackWithErrorTitle:(NSString *)title {
    if ([UIAlertController class]) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:title message:STANDARD_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self goBack];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:title message:STANDARD_ERROR_MESSAGE delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        dialog.delegate = self;
        [dialog show];
    }
}


/**
 * UIAlertView delegate
 * Go back when there is no listing to import
 */
-(void)alertViewCancel:(UIAlertView *)alertView {
    [self goBack];
}


/**
 * Go back when unable to recover the data
 */
-(void)goBack {
    if (self.navigationController.viewControllers.count <= 1) {
        HomePageViewController *homeViewController = [[HomePageViewController alloc] init];
        MyMessageViewController *messagesViewController = [[MyMessageViewController alloc] init];
        NSArray *stack = [NSArray arrayWithObjects:homeViewController, messagesViewController, self, nil];
        self.navigationController.viewControllers = stack;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
