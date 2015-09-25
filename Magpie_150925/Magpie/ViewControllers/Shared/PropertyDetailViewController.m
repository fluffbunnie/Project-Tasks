//
//  PropertyDetailViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 2/18/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailViewController.h"
#import "FontColor.h"
#import "PhotoButton.h"
#import "UserManager.h"
#import "LikeRequest.h"
#import "ToastView.h"
#import "BrowsePropertyViewController.h"
#import "MyFavoriteViewController.h"
#import "ChatViewController.h"
#import "HousingPlanViewController.h"
#import "Mixpanel.h"
#import "TripDetailViewController.h"

static float SCALE = 0.8;

static NSString *DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";
static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface PropertyDetailViewController()

@property (nonatomic, strong) PFObject *userObj;
@property (nonatomic, strong) PFObject *likeObj;
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) ImportPropertyWebView *webview;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *capturedBackgroundImage;

@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) PropertyDetailWithMiltipleListingView *detailView;

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, assign) BOOL shouldRemoveFromFavorite;
@property (nonatomic, assign) BOOL didShowUpAnimation;
@end

@implementation PropertyDetailViewController
#pragma mark - initiation
/**
 * Lazily init the background image
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.backgroundColor = [UIColor whiteColor];
        _backgroundImage.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_DARK];
    }
    return _backgroundImage;
}

/**
 * Lazily init the captured background image
 * @return UIImageView
 */
-(UIImageView *)capturedBackgroundImage {
    if (_capturedBackgroundImage == nil) {
        _capturedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackgroundImage.image = self.capturedBackground;
    }
    return _capturedBackgroundImage;
}

/**
 * Lazily init the back button
 * @return UIButton
 */
-(UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

/**
 * Lazily init the webview
 * @return UIWebView
 */
-(ImportPropertyWebView *)webview {
    if (_webview == nil) {
        _webview = [[ImportPropertyWebView alloc] initWithPid:self.propertyObj[@"airbnbPid"]];
        _webview.importWebDelegate = self;
    }
    return _webview;
}

/**
 * Lazily init the main container view
 * @return UIView
 */
-(UIView *)mainContainerView {
    if (_mainContainerView == nil) {
        _mainContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenHeight, self.screenWidth, self.screenHeight)];
    }
    return _mainContainerView;
}

/**
 * Lazily init the detail view
 * @return UIView
 */
-(PropertyDetailWithMiltipleListingView *)detailView {
    if (_detailView == nil) {
        _detailView = [[PropertyDetailWithMiltipleListingView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        [_detailView setPropertyObject:self.propertyObj];
        _detailView.detailDelegate = self;
    }
    return _detailView;
}

/**
 * Lazily init the button's container view
 * @return UIView
 */
-(UIView *)buttonContainerView {
    if (_buttonContainerView == nil) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenHeight - 50, self.screenWidth, 50)];
        _buttonContainerView.backgroundColor = [FontColor greenThemeColor];
    }
    return _buttonContainerView;
}

/**
 * Lazily init the message button
 * @return UIButton
 */
-(UIButton *)messageButton {
    if (_messageButton == nil) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_messageButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_messageButton setImage:[UIImage imageNamed:@"MessageButtonNormal"] forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"MessageButtonNormal"] forState:UIControlStateHighlighted];
        
        [_messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

/**
 * Lazily init the book button
 * @return UIButton
 */
-(UIButton *)bookButton {
    if (_bookButton == nil) {
        _bookButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, self.screenWidth - 100, 50)];
        [_bookButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_bookButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        _bookButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_bookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookButton setTitle:@"Request free stay" forState:UIControlStateNormal];
        
        [_bookButton addTarget:self action:@selector(bookButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookButton;
}

/**
 * Lazily init the like button
 * @return UIButton
 */
-(UIButton *)likeButton {
    if (_likeButton == nil) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 50, 0, 50, 50)];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        _likeButton.hidden = YES;
        [_likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

#pragma mark - public methods
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self capturedBackgroundImage]];
    [self.view addSubview:[self mainContainerView]];
    
    [self.mainContainerView addSubview:[self detailView]];
    [self.mainContainerView addSubview:[self backButton]];
    [self.mainContainerView addSubview:[self buttonContainerView]];
    [self.buttonContainerView addSubview:[self messageButton]];
    [self.buttonContainerView addSubview:[self bookButton]];
    [self.buttonContainerView addSubview:[self likeButton]];
    
    [Property getPhotosFromPropertyObject:self.propertyObj withCompletionHandler:^(NSArray *photos) {
        if (photos.count > 0) [self.detailView setPropertyPhotos:photos];
        else [self queryPhotoData];
    }];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        if (self.userObj == nil) {
            PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
            [likeQuery whereKey:@"targetHouse" equalTo:self.propertyObj];
            [likeQuery fromLocalDatastore];
            [likeQuery fromPinWithName:@"favorite"];
            [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self setLike:(objects.count > 0)];
            }];
        } else {
            PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
            [likeQuery whereKey:@"user" equalTo:self.userObj];
            [likeQuery whereKey:@"targetHouse" equalTo:self.propertyObj];
            [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self setLike:(objects.count > 0)];
            }];
        }

    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.didShowUpAnimation) {
        self.didShowUpAnimation = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.mainContainerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
            self.capturedBackgroundImage.alpha = 0;
            self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
    }
}

/**
 * Helper function to help load the new data
 */
-(void)queryPhotoData {
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.view addSubview:[self webview]];
    [self.webview requestLoad];
}

#pragma mark - Bar button click action
/**
 * Handle the back button clicked
 */
- (void)goBack {
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
    if ([previousViewController isKindOfClass:MyFavoriteViewController.class] && self.shouldRemoveFromFavorite) {
        [(MyFavoriteViewController *)previousViewController removeSelectedPropertyFromFavorite];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainContainerView.frame = CGRectMake(0, self.screenHeight, self.screenWidth, self.screenHeight);
        self.capturedBackgroundImage.alpha = 1;
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

/**
 * Delegate when user swipe the card an y-value from the center
 * @param CGFloat
 */
-(void)detailSwipeYOffset:(CGFloat)yOffset {
    if (yOffset < 0) {
        self.mainContainerView.frame = CGRectMake(0, -yOffset, self.screenWidth, self.screenHeight);
        self.capturedBackgroundImage.alpha = MIN(1, fabs(yOffset)/self.screenHeight);
        CGFloat scale = MIN(1, 0.8 + (1 - 0.8) * fabs(yOffset)/self.screenHeight);
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(scale, scale);
    } else {
        self.mainContainerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        self.capturedBackgroundImage.alpha = 0;
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(SCALE, SCALE);
    }
}

/**
 * Handle the action when user click on the like button
 */
-(void)likeButtonClick {
    self.likeButton.enabled = NO;
    if (self.userObj == nil) {
        PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
        [likeQuery whereKey:@"targetHouse" equalTo:self.propertyObj];
        [likeQuery fromLocalDatastore];
        [likeQuery fromPinWithName:@"favorite"];
        [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                [PFObject unpinAllInBackground:objects withName:@"favorite" block:^(BOOL succeeded, NSError *error) {
                    [self setLike:NO];
                    [ToastView showToastAtCenterOfView:self.windowView withText:@"Removed from Favorites" withDuration:1];
                }];
            } else {
                [LikeRequest pinPropertyToFavorite:self.propertyObj withCompletionHandler:^(PFObject *likeObj) {
                    [self setLike:YES];
                    [ToastView showToastAtCenterOfView:self.windowView withText:@"Added to Favorites" withDuration:1];
                }];
            }
        }];
    } else {
        PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
        [likeQuery whereKey:@"user" equalTo:self.userObj];
        [likeQuery whereKey:@"targetHouse" equalTo:self.propertyObj];
        [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                    [self setLike:NO];
                    self.shouldRemoveFromFavorite = YES;
                    [ToastView showToastAtCenterOfView:self.windowView withText:@"Removed from Favorites" withDuration:1];
                }];
            } else {
                [LikeRequest saveUserFavoriteWithUser:self.userObj property:self.propertyObj withCompletionHander:^(PFObject *likeObj) {
                    [self setLike:YES];
                    self.shouldRemoveFromFavorite = NO;
                    [ToastView showToastAtCenterOfView:self.windowView withText:@"Added to Favorites" withDuration:1];
                }];
            }
        }];
    }
}

/**
 * Set the like state of the browsing view
 * @param BOOL
 */
-(void)setLike:(BOOL)like {
    self.likeButton.hidden = NO;
    self.likeButton.enabled = YES;
    if (like) {
        [self.likeButton setImage:[UIImage imageNamed:@"LikeBarButtonSelected"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"LikeBarButtonSelected"] forState:UIControlStateHighlighted];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"LikeBarButtonNormal"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"LikeBarButtonNormal"] forState:UIControlStateHighlighted];
    }
}

/**
 * Handle the behavior when user pressed on the book button
 */
-(void)bookButtonClick {
    [[Mixpanel sharedInstance] track:@"Book Button Click"];
    TripDetailViewController *tripDetailViewControll = [[TripDetailViewController alloc] init];
    tripDetailViewControll.senderObj = self.userObj;
    tripDetailViewControll.receiverObj = [self.propertyObj objectForKey:@"owner"];
    tripDetailViewControll.propertyObj = self.propertyObj;
    [self.navigationController pushViewController:tripDetailViewControll animated:YES];
}

/**
 * Handle the action when user pressed the message button
 */
-(void)messageButtonClick {
    [[Mixpanel sharedInstance] track:@"Message Floating Click"];
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.userObj = self.userObj;
    chatViewController.targetUserObj = self.propertyObj[@"owner"];
    chatViewController.targetPropertyObj = self.propertyObj;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

/**
 * PropertyDetailView Delegate
 * Hide the floating buttons depend on weather the picture is showing
 * @param BOOL
 */
-(void)setFloatingButtonHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.buttonContainerView.alpha = 0;
            self.backButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.backButton.hidden = YES;
            self.buttonContainerView.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.buttonContainerView.alpha = 1;
            self.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            self.backButton.hidden = NO;
            self.buttonContainerView.hidden = NO;
        }];
    }
}

/**
 * PropertyDetailView delegate
 * Show the housing plan at the given index
 * @param index
 */
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index {
    HousingPlanViewController *housingPlanViewController = [[HousingPlanViewController alloc] init];
    housingPlanViewController.amenityObj = self.propertyObj[@"amenity"];
    housingPlanViewController.currentPageIndex = index;
    [self.navigationController pushViewController:housingPlanViewController animated:YES];
}

#pragma mark - web view delegate
/**
 * get the request results of the property information
 * @param property
 */
-(void)propertyRequestResult:(Property *)property {
    if (property.photoObjs.count == 0) {
        //if the count equal to 0 (i.e the listing profile no longer available)
        //then we take cover picture as the property photo
        property.photoObjs = [[NSMutableArray alloc] init];
        PFObject *photoObj = [[PFObject alloc] initWithClassName:@"PropertyPhoto"];
        photoObj[@"photoUrl"] = self.propertyObj[@"coverPic"];
        photoObj[@"photoDescription"] = @"";
        [property.photoObjs addObject:photoObj];
    }
    
    [self.detailView setPropertyPhotos:property.photoObjs];
    [PFObject saveAllInBackground:property.photoObjs block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFRelation *relation = [self.propertyObj relationForKey:@"photos"];
            for (PFObject *photo in property.photoObjs) {
                [relation addObject:photo];
            }
            [self.propertyObj saveInBackground];
        }
    }];
}

@end
