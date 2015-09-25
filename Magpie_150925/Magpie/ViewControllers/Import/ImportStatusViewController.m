//
//  ImportStatusViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportStatusViewController.h"
#import "UserManager.h"
#import "ImportStatusView.h"
#import "ParseConstant.h"
#import "MyPlaceListViewController.h"
#import "AFHTTPRequestOperation.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "Device.h"
#import "ImportAirbnbViewController.h"
#import "ImportSelectionViewController.h"
#import "MyPlaceDetailViewController.h"
#import "MyPlaceListViewController.h"

static NSString *DEFAULT_BACKGROUND_IMAGE_LIGHT = @"DefaultBackgroundImageLightWithIcon";
static NSString *LOADING_TEXT = @"Importing";
static NSString *PLEASE_WAIT = @"Please wait while we import your airbnb listings.";

static NSString *PROGRESS_IMPORT_BEGIN_TEXT = @"Start importing %@ airbnb listings";
static NSString *PROGRESS_IMPORT_TEXT = @"Importing %d out of %d listing(s)";

static NSString *NO_LISTING_ERROR_TITLE = @"No listing found";
static NSString *NO_LISTING_ERROR_MESSAGE = @"Oops, looks like something went wrong. Please try again.";

@interface ImportStatusViewController ()
@property (nonatomic, strong) PFObject *userObj;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) ImportStatusView *importStatusView;
@property (nonatomic, strong) ImportCompleteView *importCompleteView;

@property (nonatomic, assign) int currentPropertyImportIndex;
@property (nonatomic, strong) NSArray *pids;
@property (nonatomic, strong) NSMutableArray *importProperties;
@end

@implementation ImportStatusViewController
#pragma mark - initiation
/**
 * Lazily init the background image view
 * @return UIImageView
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_LIGHT];
    }
    return _backgroundImageView;
}

/**
 * Lazily init the import status view
 * @return ImportStatusView
 */
-(ImportStatusView *)importStatusView {
    if (_importStatusView == nil) {
        _importStatusView = [[ImportStatusView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        
        NSString *userName = [UserManager getUserNameFromUserObj:self.userObj];
        if (userName.length > 0) {
            NSString *fillInName = [NSString stringWithFormat:@"%@'s", userName];
            [_importStatusView setProgressText:[NSString stringWithFormat:PROGRESS_IMPORT_BEGIN_TEXT, fillInName]];
        } else [_importStatusView setProgressText:[NSString stringWithFormat:PROGRESS_IMPORT_BEGIN_TEXT, @"your"]];
    }
    return _importStatusView;
}

/**
 * Lazily init the import complete view
 * @return ImportCompleteView
 */
-(ImportCompleteView *)importCompleteView {
    if (_importCompleteView == nil) {
        _importCompleteView = [[ImportCompleteView alloc] initWithFrame:CGRectMake(self.screenWidth, 0, self.screenWidth, self.screenHeight)];
        _importCompleteView.importCompleteViewDelegate = self;
    }
    return _importCompleteView;
}

#pragma mark - public/private method
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        self.userObj[@"airbnbUid"] = self.airbnbUid;
        [self.userObj saveInBackground];
    }];
    
    self.screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.importProperties = [[NSMutableArray alloc] init];
    
    [self.view addSubview:[self backgroundImageView]];
    [self.view addSubview:[self importStatusView]];
    [self.view addSubview:[self importCompleteView]];
    
    ImportPropertyListWebView *importPropertyListWebView = [[ImportPropertyListWebView alloc] init];
    importPropertyListWebView.webDelegate = self;
    [self.view addSubview:importPropertyListWebView];
    [importPropertyListWebView requestLoad];
}

/***
 * Get the info of the next property on the list
 */
-(void)getNextPropertyInfo {
    if (self.currentPropertyImportIndex < self.pids.count) {
        NSString *pid = self.pids[self.currentPropertyImportIndex];
        
        self.currentPropertyImportIndex++;
        [self.importStatusView setProgressText:[NSString stringWithFormat:PROGRESS_IMPORT_TEXT, self.currentPropertyImportIndex, (int)self.pids.count]];
        
        //first we check if a property with a given pid already exist
        PFQuery *existingPropertyQuery = [[PFQuery alloc] initWithClassName:@"Property"];
        [existingPropertyQuery whereKey:@"airbnbPid" equalTo:pid];
        [existingPropertyQuery fromLocalDatastore];
        [existingPropertyQuery fromPinWithName:@"places"];
        [existingPropertyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0 && !error) {
                [self getNextPropertyInfo];
            } else {
                NSString *url = [NSString stringWithFormat:@"https://airbnb.com/rooms/%@/personalization.json", pid];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                
                //get the property info
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                operation.responseSerializer = [AFJSONResponseSerializer new];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (responseObject != nil) {
                        [PythonParsingRequest getUserImportPropertyWithJson:responseObject andPid:pid withCompletionHandler:^(Property *property) {
                            [self propertyRequestResult:property];
                        }];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showErrorMessage];
                }];
                [operation start];
            }
        }];
    } else {
        [PFObject saveAllInBackground:self.importProperties block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [PFObject pinAllInBackground:self.importProperties withName:@"places"];
                [UIView animateWithDuration:0.3 animations:^{
                    self.importStatusView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                    self.importCompleteView.transform = CGAffineTransformMakeTranslation(-self.screenWidth, 0);
                }];
            }
        }];
    }
}

#pragma mark - subview delegate
/**
 * UIAlertView delegate
 * Go back when there is no listing to import
 */
-(void)alertViewCancel:(UIAlertView *)alertView {
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex - 2] animated:NO];
}

/**
 * ImportPropertyListWebView delegate
 * Fetch the detail information for each listing when all the listing ids has been fetched
 */
-(void)pidsRequestResult:(NSArray *)pids {
    if (pids.count > 0) {
        self.pids = pids;
        [self.importCompleteView setNumPlacesImported:(int)pids.count];
        self.currentPropertyImportIndex = 0;
        [self getNextPropertyInfo];
    } else [self showErrorMessage];
}

/**
 * ImportPropertyWebView delegate
 * On the property detail return, simply grab the object asscociated with it, then get the next place until ran out
 */
-(void)propertyRequestResult:(Property *)property {
    if (property == nil) [self showErrorMessage];
    else {
        PFObject *propertyObj = property.propertyObj;
        propertyObj[@"owner"] = self.userObj;
        propertyObj[@"state"] = PROPERTY_APPROVAL_STATE_PRIVATE;
        
        void (^saveAndGetNextPropertyBlock)() = ^{
            PFRelation *relation = [propertyObj relationForKey:@"photos"];
            [PFObject saveAllInBackground:property.photoObjs block:^(BOOL succeeded, NSError *error) {
                for (PFObject *photoObj in property.photoObjs) [relation addObject:photoObj];
                [self.importProperties addObject:propertyObj];
                [self getNextPropertyInfo];
            }];
        };
        
        SPGooglePlacesAutocompleteQuery *query = [SPGooglePlacesAutocompleteQuery query];
        query.input = propertyObj[@"location"];
        query.language = @"en";
        query.types = SPPlaceTypeGeocode;
        [query fetchPlaces:^(NSArray *places, NSError *error) {
            if (!error && places.count > 0) {
                SPGooglePlacesAutocompletePlace *place = places[0];
                
                [place resolveToPlacemark:^(CLPlacemark *location, NSString *addressString, NSError *error) {
                    if (location && !error) {
                        NSDictionary *locationDictionary = location.addressDictionary;
                        NSString *street = locationDictionary[@"Street"] ? locationDictionary[@"Street"] : nil;
                        if (street == nil) street = locationDictionary[@"Name"] ? locationDictionary[@"Name"] : nil;
                        
                        NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
                        if (locationDictionary[@"City"]) [descriptionArray addObject:locationDictionary[@"City"]];
                        if (locationDictionary[@"State"]) [descriptionArray addObject:locationDictionary[@"State"]];
                        if (locationDictionary[@"Country"]) [descriptionArray addObject:locationDictionary[@"Country"]];
                        NSString *shortLocation = [descriptionArray componentsJoinedByString:@", "];
                        
                        if (shortLocation.length > 0) propertyObj[@"location"] = shortLocation;
                        else if (street.length > 0) propertyObj[@"location"] = street;
                        
                        if (street.length > 0 && shortLocation.length > 0)
                            propertyObj[@"fullLocation"] = [NSString stringWithFormat:@"%@, %@", street, shortLocation];
                        else if (shortLocation.length > 0) propertyObj[@"fullLocation"] = shortLocation;
                        propertyObj[@"coordinate"] = [PFGeoPoint geoPointWithLocation:location.location];
                        
                        //finally we save and fetch a new set of info
                        saveAndGetNextPropertyBlock();
                    } else saveAndGetNextPropertyBlock();
                }];
            } else saveAndGetNextPropertyBlock();
        }];
    }
}

/**
 * ImportCompleteView delegate
 * Delegate when user click on the completed button. When this happen, take them back
 * to previous view
 */
-(void)completeButtonClicked {
    [[Mixpanel sharedInstance] track:@"Import Completed" properties:@{@"NumPlaces": [NSString stringWithFormat:@"%d", (int)self.importProperties.count]}];
    [[UserManager sharedUserManager] setUserProperties:self.importProperties];
    
    //we remove all the past view controller that associated with import
    NSMutableArray *desiredViewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if (![viewController isKindOfClass:ImportAirbnbViewController.class] && ![viewController isKindOfClass:ImportSelectionViewController.class] && ![viewController isKindOfClass:MyPlaceListViewController.class] && ![viewController isKindOfClass:MyPlaceDetailViewController.class] && ![viewController isKindOfClass:ImportStatusViewController.class])
            [desiredViewControllers addObject:viewController];
    }
    
    MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
    myPlaceListViewController.userObj = self.userObj;
    [desiredViewControllers addObject:myPlaceListViewController];
    [desiredViewControllers addObject:self];
    
    self.navigationController.viewControllers = desiredViewControllers;
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 * Show the error message and quit
 */
-(void)showErrorMessage {
    //first update a new feedback to let us know that is is an error
    PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
    if (self.userObj) feedback[@"user"] = self.userObj;
    feedback[@"feeling"] = @"default";
    feedback[@"content"] = @"THIS IS APP GENERATED FEEDBACK - NOT A USER'S FEEDBACK. User fail to import from airbnb. Action taken needed immediately to check this";
    
    feedback[@"appVersion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    feedback[@"device"] = [Device getDeviceName];
    feedback[@"iosVersion"] = [[UIDevice currentDevice] systemVersion];
    
    [feedback saveInBackground];

    
    if ([UIAlertController class]) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:NO_LISTING_ERROR_TITLE message:NO_LISTING_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex - 2] animated:NO];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:NO_LISTING_ERROR_TITLE message:NO_LISTING_ERROR_MESSAGE delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        dialog.delegate = self;
        [dialog show];
    }
}


@end
