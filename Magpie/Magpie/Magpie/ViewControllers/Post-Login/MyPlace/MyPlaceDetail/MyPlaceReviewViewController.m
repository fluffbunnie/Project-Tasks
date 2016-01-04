//
//  MyPlaceReviewViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceReviewViewController.h"
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
#import "ErrorMessageDisplay.h"
#import "MyProfileViewController.h"
#import "MyPlaceListViewController.h"

static float SCALE = 0.8;

static NSString * APPROVAL_REQUIRE_IMAGE_ERROR_TITLE = @"Missing information";
static NSString * APPROVAL_REQUIRE_IMAGE_ERROR_DESCRIPTION = @"Your place needs at least 3 photos. Please try again.";

static NSString * APPROVAL_REQUIRE_NAME_ERROR_TITLE = @"Missing information";
static NSString * APPROVAL_REQUIRE_NAME_ERROR_DESCRIPTION = @"Your place needs to have a name. Please try again.";

static NSString * APPROVAL_REQUIRE_TYPE_ERROR_TITLE = @"Missing information";
static NSString * APPROVAL_REQUIRE_TYPE_ERROR_DESCRIPTION = @"Your place needs to have a type. Please try again.";

static NSString * APPROVAL_REQUIRE_LOCATION_TITLE = @"Missing information";
static NSString * APPROVAL_REQUIRE_LOCATION_DESCRIPTION = @"Your place needs to have a location. Please try again.";

static NSString * APPROVAL_REQUIRE_PLACE_DESCRIPTION_TITLE = @"Missing information";
static NSString * APPROVAL_REQUIRE_PLACE_DESCRIPTION_MESSAGE = @"Your place needs to have a description. Please try again.";

static NSString * APPROVAL_REQUIRE_USER_DESCRIPTION_TITLE = @"Missing infromation";
static NSString * APPROVAL_REQUIRE_USER_DESCRIPTION_MESSAGE = @"Your personal description required to publish your place. Please try again.";

static NSString *DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";
static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface MyPlaceReviewViewController ()
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *capturedBackgroundImage;

@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) PropertyDetailWithMiltipleListingView *detailView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, assign) BOOL didShowUpAnimation;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation MyPlaceReviewViewController
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
        _detailView = [[PropertyDetailWithMiltipleListingView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight) andCanGoToUserProfile:YES];
        [_detailView setPropertyObject:self.propertyObj];
        _detailView.detailDelegate = self;
    }
    return _detailView;
}

/**
 * Lazily init the publish button
 * @return UIButton
 */
-(UIButton *)publishButton {
    if (_publishButton == nil) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.screenHeight - 50, self.screenWidth, 50)];
        _publishButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if ([self.propertyObj[@"state"] isEqualToString:PROPERTY_APPROVAL_STATE_PRIVATE]) {
            [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
            [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
            [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        } else {
            [_publishButton setTitle:@"Unpublish" forState:UIControlStateNormal];
            [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
            [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        }
        [_publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
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
    [self.mainContainerView addSubview:[self publishButton]];
    
    [Property getPhotosFromPropertyObject:self.propertyObj withCompletionHandler:^(NSArray *photos) {
        self.photos = photos;
        if (photos.count > 0) [self.detailView setPropertyPhotos:photos];
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
 * Reload the view content
 */
-(void)reloadContent {
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        PFObject *currentUserObj = self.propertyObj[@"owner"];
        if ([currentUserObj.objectId isEqualToString:userObj.objectId]) {
            self.propertyObj[@"owner"] = userObj;
            [self.detailView setPropertyObject:self.propertyObj];
            [self.detailView setPropertyPhotos:self.photos];
        }
    }];
}

#pragma mark - Bar button click action
/**
 * Handle the back button clicked
 */
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainContainerView.frame = CGRectMake(0, self.screenHeight, self.screenWidth, self.screenHeight);
            self.capturedBackgroundImage.alpha = 1;
            self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } else {
        [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
            MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
            myPlaceListViewController.userObj = userObj;
            self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:myPlaceListViewController, self, nil];
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}

/**
 * Handle the behavior when user want to edit their user profile
 */
-(void)goToUserProfile {
    MyProfileViewController *myProfileViewController = [[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileViewController animated:YES];
}
             
/**
* Handle the behavior when user click on the public button
*/
 -(void)publishButtonClick {
     if ([self.propertyObj[@"state"] isEqualToString:PROPERTY_APPROVAL_STATE_PRIVATE]) {
         NSString *location = self.propertyObj[@"location"] ? self.propertyObj[@"location"] : @"";
         NSString *placeType = self.propertyObj[@"listingType"] ? self.propertyObj[@"listingType"] : @"";
         NSString *name = self.propertyObj[@"name"] ? self.propertyObj[@"name"] : @"";
         NSString *placeDescription = self.propertyObj[@"fullDescription"] ? self.propertyObj[@"fullDescription"] : @"";
         PFObject *userObj = self.propertyObj[@"owner"];
         NSString *userDescription = userObj[@"description"] ? userObj[@"description"] : @"";
         
         if (location.length == 0) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_LOCATION_TITLE andMessage:APPROVAL_REQUIRE_LOCATION_DESCRIPTION];
         } else if (self.photos.count < 3) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_IMAGE_ERROR_TITLE andMessage:APPROVAL_REQUIRE_IMAGE_ERROR_DESCRIPTION];
         } else if (placeType.length == 0) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_TYPE_ERROR_TITLE andMessage:APPROVAL_REQUIRE_TYPE_ERROR_DESCRIPTION];
         } else if (name.length == 0) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_NAME_ERROR_TITLE andMessage:APPROVAL_REQUIRE_NAME_ERROR_DESCRIPTION];
         } else if (placeDescription.length == 0) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_PLACE_DESCRIPTION_TITLE andMessage:APPROVAL_REQUIRE_PLACE_DESCRIPTION_MESSAGE];
         } else if (userDescription.length == 0) {
             [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_USER_DESCRIPTION_TITLE andMessage:APPROVAL_REQUIRE_USER_DESCRIPTION_MESSAGE];
         } else {
             self.propertyObj[@"state"] = PROPERTY_APPROVAL_STATE_PENDING;
             [self.propertyObj saveInBackground];
             [_publishButton setTitle:@"Unpublish" forState:UIControlStateNormal];
             [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
             [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
             [[UserManager sharedUserManager] incrementProperty];
         }
     } else {
         [self.propertyObj fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
             if (!error && object != nil) {
                 NSString *prevState = object[@"state"] ? object[@"state"] : @"";
                 NSString *location = self.propertyObj[@"location"] ? self.propertyObj[@"location"] : @"";
                 if ([prevState isEqualToString:PROPERTY_APPROVAL_STATE_ACCEPT] && location.length > 0) {
                     //in this case, we remove it from the location index
                     PFQuery *locationQuery = [PFQuery queryWithClassName:@"LocationIndex"];
                     [locationQuery whereKey:@"location" equalTo:location];
                     [locationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                         if (!error && object != nil) {
                             int currentCount = [object[@"count"] intValue];
                             if (currentCount == 1) [object deleteInBackground];
                             else {
                                 object[@"count"] = @(currentCount - 1);
                                 [object saveInBackground];
                             }
                         }
                     }];
                 }
                 
                 self.propertyObj[@"state"] = PROPERTY_APPROVAL_STATE_PRIVATE;
                 [self.propertyObj saveInBackground];
                 [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
                 [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
                 [_publishButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
                 [[UserManager sharedUserManager] decrementProperty];
             }
         }];
     }
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
 * PropertyDetailView Delegate
 * Hide the floating buttons depend on weather the picture is showing
 * @param BOOL
 */
-(void)setFloatingButtonHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.publishButton.alpha = 0;
            self.backButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.backButton.hidden = YES;
            self.publishButton.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.publishButton.alpha = 1;
            self.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            self.backButton.hidden = NO;
            self.publishButton.hidden = NO;
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

@end
