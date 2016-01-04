//
//  PlaceSearchResultsViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PlaceSearchResultsViewController.h"
#import "FontColor.h"
#import "BrowsePropertyViewController.h"
#import "Device.h"
#import "PlaceSearchResultsCollectionViewCell.h"
#import "UserManager.h"
#import "ParseConstant.h"
#import "ErrorMessageDisplay.h"

static NSString * CELL_IDENTIFIER = @"searchCell";

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

@interface PlaceSearchResultsViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, assign) PFObject *userObj;
@property (nonatomic, strong) NSArray *searchedPlaces;
@property (nonatomic, strong) NSMutableDictionary *locationDistances;

@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation PlaceSearchResultsViewController
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
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.screenHeight/2 - 25, self.screenWidth, 50)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"LoadingDark" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the collection view
 * @return UICollectionView
 */
-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.minimumColumnSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        CGRect collectionViewFrame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = true;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[PlaceSearchResultsCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        _collectionView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.searchedAddress;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.locationDistances = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    [self.view addSubview:[self collectionView]];
    [self.view addSubview:[self loadingIcon]];
    self.collectionView.alpha = 0;
    
    NSDate *time  = [[NSDate alloc] init];
    self.startTime = [time timeIntervalSince1970];
    
    self.startLocation = [[CLLocation alloc] initWithLatitude:self.searchedLocation.latitude longitude:self.searchedLocation.longitude];
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        [self prepareBrowsingDeck];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - helper methods
/**
 * Prepare the deck to be display
 */
-(void)prepareBrowsingDeck {
    if (self.userObj != nil) {
        PFObject *searchObject = [PFObject objectWithClassName:@"Search"];
        searchObject[@"user"] = self.userObj;
        searchObject[@"location"] = self.searchedLocation;
        [searchObject saveInBackground];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Property"];
    [query whereKey:@"coordinate" nearGeoPoint:self.searchedLocation withinMiles:50];
    [query whereKeyExists:@"coverPic"];
    [query whereKey:@"state" notContainedIn:@[PROPERTY_APPROVAL_STATE_PENDING, PROPERTY_APPROVAL_STATE_PRIVATE]];
    [query includeKey:@"owner"];
    [query includeKey:@"amenity"];
    [query orderByDescending:@"state"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
            [self.navigationController popViewControllerAnimated:YES];
            
            [ErrorMessageDisplay displayErrorAlertOnViewController:previousViewController withTitle:DECK_LOAD_FAIL_TITLE andMessage:DECK_LOAD_FAIL_DESCRIPTION];
        } else if (objects.count > 0) {
            self.searchedPlaces = objects;
            NSDate *time  = [[NSDate alloc] init];
            NSTimeInterval endTime = [time timeIntervalSince1970];
            if (endTime - self.startTime > 1.5) [self reloadData];
            else [self performSelector:@selector(reloadData) withObject:nil afterDelay:1.5 - (endTime - self.startTime)];
        } else {
            NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
            [self.navigationController popViewControllerAnimated:YES];
            [ErrorMessageDisplay displayErrorAlertOnViewController:previousViewController withTitle:@"No available places" andMessage:@"No available places found within 50 miles of your search. Please try again."];
        }
    }];
}

/**
 * Reload the collection view data
 */
-(void)reloadData {
    [self.collectionView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.alpha = 1;
        self.loadingIcon.alpha = 0;
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchedPlaces.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaceSearchResultsCollectionViewCell *cell = (PlaceSearchResultsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
  
    PFObject *propertyObj = self.searchedPlaces[indexPath.row];
    
    NSNumber *distanceNumber = [self.locationDistances objectForKey:propertyObj.objectId];
    if (distanceNumber) [cell setPropertyObj:propertyObj withDistance:[distanceNumber doubleValue]];
    else {
        PFGeoPoint *coordinate = propertyObj[@"coordinate"];
        CLLocation *coordinateLoc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        double distance = [self.startLocation distanceFromLocation:coordinateLoc] / 1609.344;
        [cell setPropertyObj:propertyObj withDistance:distance];
        [self.locationDistances setObject:[NSNumber numberWithDouble:distance] forKey:propertyObj.objectId];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSMutableArray *sufflePlace = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.searchedPlaces.count; i++) {
        [sufflePlace addObject:self.searchedPlaces[(i + indexPath.row) % self.searchedPlaces.count]];
    }
    
    BrowsePropertyViewController *browsePropertyViewController = [[BrowsePropertyViewController alloc] init];
    browsePropertyViewController.capturedBackground = [Device captureScreenshot];
    browsePropertyViewController.locations = sufflePlace;
    [self.navigationController pushViewController:browsePropertyViewController animated:NO];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *propertyObj = self.searchedPlaces[indexPath.row];
    
    double distance = 0;
    NSNumber *distanceNumber = [self.locationDistances objectForKey:propertyObj.objectId];
    if (distanceNumber) distance = [distanceNumber doubleValue];
    else {
        PFGeoPoint *coordinate = propertyObj[@"coordinate"];
        CLLocation *coordinateLoc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        distance = [self.startLocation distanceFromLocation:coordinateLoc] / 1609.344;
    }

    return [PlaceSearchResultsCollectionViewCell sizeForPropertyObj:propertyObj withDistance:distance];
}

#pragma mark - button click
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
