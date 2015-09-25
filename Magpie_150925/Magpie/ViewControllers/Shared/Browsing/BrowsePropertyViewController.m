//
//  BrowsePropertyViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "BrowsePropertyViewController.h"
#import "Property.h"
#import "ParseConstant.h"
#import "ErrorMessageDisplay.h"
#import "UserManager.h"
#import "Device.h"
#import "HousingPlanViewController.h"
#import "ChatViewController.h"
#import "UserManager.h"
#import "ToastView.h"
#import "LikeRequest.h"
#import "Property.h"
#import "Mixpanel.h"
#import "TripDetailViewController.h"

static float CARD_SCALE = 0.8;

static NSString *DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";

@interface BrowsePropertyViewController ()
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) PFObject *userObj;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *capturedBackgroundImage;
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) BrowseCardAlbumView *cardAlbumView;
@property (nonatomic, strong) BrowseDetailScrollView *detailScrollView;

@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSMutableDictionary *photoDictionary;

@property (nonatomic, assign) BOOL didShowUpAnimation;
@end

@implementation BrowsePropertyViewController
#pragma mark - initation
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
 * Lazily init the card album view
 * @return BrowseCardAlbumView
 */
-(BrowseCardAlbumView *)cardAlbumView {
    if (_cardAlbumView == nil) {
        _cardAlbumView = [[BrowseCardAlbumView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight) andParentController:self];
    }
    return _cardAlbumView;
}

/**
 * Lazily init the detail scroll view
 * @return BrowseDetailScrollView
 */
-(BrowseDetailScrollView *)detailScrollView {
    if (_detailScrollView == nil) {
        _detailScrollView = [[BrowseDetailScrollView alloc] initWithFrame:CGRectMake(0, self.screenHeight, self.screenWidth, self.screenHeight) andParentController:self];
    }
    return _detailScrollView;
}

#pragma mark - view load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.photoDictionary = [[NSMutableDictionary alloc] init];
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self capturedBackgroundImage]];
    [self.view addSubview:[self mainContainerView]];
    [self.mainContainerView addSubview:[self cardAlbumView]];
    [self.mainContainerView addSubview:[self detailScrollView]];
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        if (self.locations) {
            self.properties = self.locations;
            [self.cardAlbumView setPropertyObjects:self.properties];
            [self.detailScrollView setPropertyObjects:self.properties];
            [self.cardAlbumView animateCardView];
        } else [self prepareBrowsingDeck];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [self.cardAlbumView animateCardView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (!self.didShowUpAnimation) {
        self.didShowUpAnimation = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.mainContainerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
            self.capturedBackgroundImage.alpha = 0;
            self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)applicationFinishedRestoringState {
    [self.cardAlbumView animateCardView];
}

-(void)applicationEnterForeground {
    [self.cardAlbumView animateCardView];
}

#pragma mark - public methods
/**
 * Go back
 */
-(void)goBack {
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
-(void)cardSwipeYOffset:(CGFloat)yFromCenter {
    if (yFromCenter < 0) {
        self.mainContainerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        
        self.capturedBackgroundImage.alpha = 0;
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        self.cardAlbumView.alpha = MIN(1, 1 - fabs(yFromCenter)/self.screenHeight);
        CGFloat currenCardScale = MIN(1, 1 - (1 - 0.8) * fabs(yFromCenter)/self.screenHeight);
        self.cardAlbumView.transform = CGAffineTransformMakeScale(currenCardScale, currenCardScale);
        self.detailScrollView.transform = CGAffineTransformMakeTranslation(0, MAX(yFromCenter, -self.screenHeight));
    } else {
        self.mainContainerView.frame = CGRectMake(0, yFromCenter, self.screenWidth, self.screenHeight);
        
        self.capturedBackgroundImage.alpha = MIN(1, fabs(yFromCenter)/self.screenHeight);
        CGFloat scale = MIN(1, 0.8 + (1 - 0.8) * fabs(yFromCenter)/self.screenHeight);
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(scale, scale);
        
        self.cardAlbumView.alpha = 1;
        self.cardAlbumView.transform = CGAffineTransformMakeScale(1, 1);
        self.detailScrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}

/**
 * Hide the card detail
 */
-(void)hideCardDetail {
    [self.detailScrollView setShouldLoadPicture:NO];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainContainerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        
        self.capturedBackgroundImage.alpha = 0;
        self.capturedBackgroundImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        self.cardAlbumView.transform = CGAffineTransformMakeScale(1, 1);
        self.cardAlbumView.alpha = 1;
        self.detailScrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

/**
 * Hide card detail
 */
-(void)showCardDetail {
    [self.detailScrollView setShouldLoadPicture:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.cardAlbumView.transform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
        self.cardAlbumView.alpha = 0;
        self.detailScrollView.transform = CGAffineTransformMakeTranslation(0, -self.screenHeight);
    }];
}

/**
 * Show next card
 */
-(void)showNextCard {
    [self.cardAlbumView viewNextCard];
    [self.detailScrollView viewNextCard];
}

/**
 * Show the previous card
 */
-(void)showPrevCard {
    [self.cardAlbumView viewPreviousCard];
    [self.detailScrollView viewPreviousCard];
}

/**
 * Set like of the given property obj
 * @param PFObject
 */
-(void)likeClickForPropertyObj:(PFObject *)propertyObj {
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
    [likeQuery whereKey:@"user" equalTo:self.userObj];
    [likeQuery whereKey:@"targetHouse" equalTo:propertyObj];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                [self.detailScrollView setLike:NO forPropertyObj:propertyObj];
                [self.cardAlbumView setLike:NO forPropertyObj:propertyObj];
                [ToastView showToastAtCenterOfView:self.windowView withText:@"Removed from Favorites" withDuration:1];
            }];
        } else {
            [LikeRequest saveUserFavoriteWithUser:self.userObj property:propertyObj withCompletionHander:^(PFObject *likeObj) {
                [self.detailScrollView setLike:YES forPropertyObj:propertyObj];
                [self.cardAlbumView setLike:YES forPropertyObj:propertyObj];
                [ToastView showToastAtCenterOfView:self.windowView withText:@"Added to Favorites" withDuration:1];
            }];
        }
    }];
}

/**
 * find the liking status of the given property obj
 * @param PFObject
 */
-(void)findLikeStatusForPropertyObj:(PFObject *)propertyObj {
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Favorite"];
    [likeQuery whereKey:@"user" equalTo:self.userObj];
    [likeQuery whereKey:@"targetHouse" equalTo:propertyObj];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.detailScrollView setLike:(objects.count > 0) forPropertyObj:propertyObj];
        [self.cardAlbumView setLike:(objects.count > 0) forPropertyObj:propertyObj];
    }];
}

/**
 * Handle the behavior when user click on the book button
 * @param PFObject
 */
-(void)bookButtonClickForPropertyObj:(PFObject *)propertyObj {
    [[Mixpanel sharedInstance] track:@"Book Button Click"];
    TripDetailViewController *tripDetailViewControll = [[TripDetailViewController alloc] init];
    tripDetailViewControll.senderObj = self.userObj;
    tripDetailViewControll.receiverObj = [propertyObj objectForKey:@"owner"];
    tripDetailViewControll.propertyObj = propertyObj;
    [self.navigationController pushViewController:tripDetailViewControll animated:YES];
}

/**
 * Handle the behavior when the user click on the message button
 * @param PFObject
 */
-(void)messageButtonClickForPropertyObj:(PFObject *)propertyObj {
    [[Mixpanel sharedInstance] track:@"Message Floating Click"];
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.userObj = self.userObj;
    chatViewController.targetUserObj = propertyObj[@"owner"];
    chatViewController.targetPropertyObj = propertyObj;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

/**
 * Request the photos of the given property obj
 * @param PFObject
 */
-(void)requestGetPhotosForPropertyObj:(PFObject *)propertyObj {
    NSMutableArray *photoArray = [self.photoDictionary objectForKey:propertyObj.objectId];
    if (photoArray != nil) [self.detailScrollView setPhotos:photoArray forPropertyObj:propertyObj];
    else {
        [Property getPhotosFromPropertyObject:propertyObj withCompletionHandler:^(NSArray *photos) {
            if (photos.count > 0) {
                [self.photoDictionary setObject:photos forKey:propertyObj.objectId];
                [self.detailScrollView setPhotos:photos forPropertyObj:propertyObj];
            } else if (propertyObj[@"airbnbPid"]) {
                ImportPropertyWebView *webview = [[ImportPropertyWebView alloc] initWithPid:propertyObj[@"airbnbPid"]];
                webview.importWebDelegate = self;
                [self.view addSubview:webview];
                [webview requestLoad];
            }
        }];
    }
}

/**
 * PropertyDetailView delegate
 * Show the housing plan at the given index
 * @param index
 */
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index forPropertyObj:(PFObject *)propertyObj {
    HousingPlanViewController *housingPlanViewController = [[HousingPlanViewController alloc] init];
    housingPlanViewController.amenityObj = propertyObj[@"amenity"];
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
        property.photoObjs = [[NSMutableArray alloc] init];
        PFObject *photoObj = [[PFObject alloc] initWithClassName:@"PropertyPhoto"];
        photoObj[@"photoUrl"] = property.propertyObj[@"coverPic"] ? property.propertyObj[@"coverPic"]:@"";
        photoObj[@"photoDescription"] = @"";
        [property.photoObjs addObject:photoObj];
    }
    
    PFObject *requestedPropertyObj;
    for (PFObject *obj in self.properties) {
        if ([property.propertyObj[@"airbnbPid"] isEqualToString:obj[@"airbnbPid"]]) {
            requestedPropertyObj = obj;
            break;
        }
    }
    
    if (requestedPropertyObj != nil) {
        [self.detailScrollView setPhotos:property.photoObjs forPropertyObj:requestedPropertyObj];
        [self.photoDictionary setObject:property.photoObjs forKey:requestedPropertyObj.objectId];
        
        [PFObject saveAllInBackground:property.photoObjs block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                PFRelation *relation = [requestedPropertyObj relationForKey:@"photos"];
                
                NSMutableSet *urlSet = [[NSMutableSet alloc] init];
                [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error && objects.count > 0) {
                        for (PFObject *obj in objects) {
                            [urlSet addObject:obj[@"photoUrl"]];
                        }
                    }
                    
                    for (PFObject *photo in property.photoObjs) {
                        if (![urlSet containsObject:photo[@"photoUrl"]]) [relation addObject:photo];
                    }
                    
                    [requestedPropertyObj saveInBackground];
                }];
            }
        }];
    } else [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:LISTING_NO_LONGER_EXIST_TITLE andMessage:LISTING_NO_LONGER_EXIST_DESCRIPTION];
}

#pragma mark - helper methods
/**
 * Prepare the deck to be display
 */
-(void)prepareBrowsingDeck {
    if (self.deckName.length > 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"EditorialDeck"];
        [query whereKey:@"deckName" equalTo:self.deckName];
        [query includeKey:@"property"];
        [query includeKey:@"property.owner"];
        [query includeKey:@"property.amenity"];
        query.limit = 100;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                NSMutableArray *propertyObjs = [[NSMutableArray alloc] init];
                for (PFObject *deckObject in objects) {
                    if (deckObject[@"property"]) [propertyObjs addObject:deckObject[@"property"]];
                }
                self.properties = propertyObjs;
                [self.cardAlbumView setPropertyObjects:propertyObjs];
                [self.detailScrollView setPropertyObjects:propertyObjs];
                [self.cardAlbumView animateCardView];
            } else [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:DECK_LOAD_FAIL_TITLE andMessage:DECK_LOAD_FAIL_DESCRIPTION];
        }];
    } else if (self.location != nil){
        if (self.userObj != nil) {
            PFObject *searchObject = [PFObject objectWithClassName:@"Search"];
            searchObject[@"user"] = self.userObj;
            searchObject[@"location"] = self.location;
            [searchObject saveInBackground];
        }
        
        PFQuery *query = [PFQuery queryWithClassName:@"Property"];
        [query whereKey:@"coordinate" nearGeoPoint:self.location withinMiles:50];
        [query whereKeyExists:@"coverPic"];
        [query whereKey:@"state" notContainedIn:@[PROPERTY_APPROVAL_STATE_PENDING, PROPERTY_APPROVAL_STATE_PRIVATE]];
        [query includeKey:@"owner"];
        [query includeKey:@"amenity"];
        query.limit = 1000;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:DECK_LOAD_FAIL_TITLE andMessage:DECK_LOAD_FAIL_DESCRIPTION];
            } else if (objects.count > 0) {
                self.properties = objects;
                [self.cardAlbumView setPropertyObjects:objects];
                [self.detailScrollView setPropertyObjects:objects];
                [self.cardAlbumView animateCardView];
            } else {
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"No available places" andMessage:@"No available places found within 50 miles of your search. Please try again."];
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Property"];
        [query whereKey:@"state" notContainedIn:@[PROPERTY_APPROVAL_STATE_PENDING, PROPERTY_APPROVAL_STATE_PRIVATE]];
        [query includeKey:@"owner"];
        [query includeKey:@"amenity"];
        [query orderByDescending:@"createdAt"];
        query.limit = 100;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                self.properties = objects;
                [self.cardAlbumView setPropertyObjects:objects];
                [self.detailScrollView setPropertyObjects:objects];
                [self.cardAlbumView animateCardView];
            } else [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:DECK_LOAD_FAIL_TITLE andMessage:DECK_LOAD_FAIL_DESCRIPTION];
        }];
    }
}

@end
