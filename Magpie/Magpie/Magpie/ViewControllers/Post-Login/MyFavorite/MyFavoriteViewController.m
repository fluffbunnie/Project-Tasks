//
//  MyFavoriteViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "FontColor.h"
#import "BrowsePropertyViewController.h"
#import "MyFavoriteCollectionViewCell.h"
#import "LikeRequest.h"
#import "PropertyDetailViewController.h"
#import "UserManager.h"
#import "Device.h"

static NSString * CELL_IDENTIFIER = @"favoriteCell";

static NSString * VIEW_TITLE = @"Favorites";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

static NSString * SEGMENTED_LIKED_TITLE = @"Places You Like";
static NSString * SEGMENTED_MUTUAL_TITLE = @"Mutual Interests";

@interface MyFavoriteViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) MyFavoriteEmptyView *emptyView;
//@property (nonatomic, strong) UIView *segmentControlContainer;
//@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *favoritePlaces;
//@property (nonatomic, strong) NSMutableArray *matchPlaces;
@property (nonatomic, assign) BOOL isLoadingFavoritePlaces;
//@property (nonatomic, assign) BOOL isLoadingMatchPlaces;

@property (nonatomic, assign) CGPoint lastOffsetFavoriteCollectionView;
//@property (nonatomic, assign) CGPoint lastOffsetMatchCollectionView;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation MyFavoriteViewController

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
 * Lazily init my favorite empty view
 * @return MyFavoriteEmptyView
 */
-(MyFavoriteEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[MyFavoriteEmptyView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
        _emptyView.emptyViewDelegate = self;
    }
    return _emptyView;
}

/**
 * Lazily init the segment controll container
 * @return UIView
 */
//-(UIView *)segmentControlContainer {
//    if (_segmentControlContainer == nil) {
//        _segmentControlContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 68, self.screenWidth, 50)];
//        _segmentControlContainer.backgroundColor = [UIColor whiteColor];
//    }
//    return _segmentControlContainer;
//}

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
//        if ([self.userObj[@"numMatches"] integerValue] > 0)
//            collectionViewFrame = CGRectMake(0, CGRectGetMaxY(self.segmentControlContainer.frame), self.screenWidth, self.screenHeight -  CGRectGetMaxY(self.segmentControlContainer.frame));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = true;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[MyFavoriteCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        _collectionView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _collectionView;
}

/**
 * Lazily init the segment control for the view
 * @return UISegmentedControll
 */
//-(UISegmentedControl *)segmentControl {
//    if (_segmentControl == nil) {
//        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[SEGMENTED_LIKED_TITLE, SEGMENTED_MUTUAL_TITLE]];
//        _segmentControl.frame = CGRectMake(15, 12, self.screenWidth - 30, 25);
//        _segmentControl.tintColor = [FontColor themeColor];
//        UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                               forKey:NSFontAttributeName];
//        [_segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
//        [_segmentControl setSelectedSegmentIndex:0];
//
//    }
//    return _segmentControl;
//}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        if ([self.userObj[@"numLikes"] integerValue] == 0) {// && [self.userObj[@"numMatches"] integerValue] == 0) {
            [self.view addSubview:[self emptyView]];
//        } else if ([self.userObj[@"numMatches"] integerValue] == 0) {
//            self.favoritePlaces = [[NSMutableArray alloc] init];
//            [self.view addSubview:[self collectionView]];
//            [self loadMore];
        } else {
            self.favoritePlaces = [[NSMutableArray alloc] init];
//            self.matchPlaces = [[NSMutableArray alloc] init];
            
//            [self.view addSubview:[self segmentControlContainer]];
//            [self.segmentControlContainer addSubview:[self segmentControl]];
            [self.view addSubview:[self collectionView]];
            [self loadMore];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if ([[self emptyView] superview]) {
        [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
            self.userObj = userObj;
            if ([userObj[@"numLikes"] intValue] > 0) {
                if ([[self emptyView] superview]) [self.emptyView removeFromSuperview];
                //if ([self.userObj[@"numMatches"] integerValue] == 0) {
                    self.favoritePlaces = [[NSMutableArray alloc] init];
                    [self.view addSubview:[self collectionView]];
                    [self loadMore];
//                } else {
//                    self.favoritePlaces = [[NSMutableArray alloc] init];
//                    self.matchPlaces = [[NSMutableArray alloc] init];
//                    
//                    [self.view addSubview:[self segmentControlContainer]];
//                    [self.segmentControlContainer addSubview:[self segmentControl]];
//                    [self loadMore];
//                }
            }
        }];
    };

}

-(void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

/**
 * Remove the selected item from favorite
 */
-(void)removeSelectedPropertyFromFavorite {
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) [self.favoritePlaces removeObjectAtIndex:self.selectedIndexPath.row];
//        else [self.matchPlaces removeObjectAtIndex:self.selectedIndexPath.row];
//    } else
        [self.favoritePlaces removeObjectAtIndex:self.selectedIndexPath.row];
    
    [self.collectionView reloadData];
}

/**
 * Load more properties and refresh the table if needed
 */
-(void)loadMore {
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) {
//            if (self.isLoadingFavoritePlaces == NO) {
//                self.isLoadingFavoritePlaces = YES;
//                NSDate *priorToDate = [[NSDate alloc] init];
//                if (self.favoritePlaces.count > 0) priorToDate = ((PFObject *)[self.favoritePlaces lastObject]).updatedAt;
//                [LikeRequest getUserFavoritesForUser:self.userObj priorToDate:priorToDate andLimit:20 withCompletionHandler:^(NSArray *favorites) {
//                    if (favorites.count > 0) {
//                        [self.favoritePlaces addObjectsFromArray:favorites];
//                        if (self.segmentControl.selectedSegmentIndex == 0) [self.collectionView reloadData];
//                        self.isLoadingFavoritePlaces = NO;
//                    }
//                }];
//            }
//        } else {
//            if (self.isLoadingMatchPlaces == NO) {
//                self.isLoadingMatchPlaces = YES;
//                NSDate *priorToDate = [[NSDate alloc] init];
//                if (self.matchPlaces.count > 0) priorToDate = ((PFObject *)[self.matchPlaces lastObject]).updatedAt;
//                [LikeRequest getUserMatchesForUser:self.userObj priorToDate:priorToDate andLimit:20 withCompletionHandler:^(NSArray *matches) {
//                    if (matches.count > 0) {
//                        [self.matchPlaces addObjectsFromArray:matches];
//                        if (self.segmentControl.selectedSegmentIndex == 1) [self.collectionView reloadData];
//                        self.isLoadingMatchPlaces = NO;
//                    }
//                }];
//            }
//        }
//    } else {
        if (self.isLoadingFavoritePlaces == NO) {
            self.isLoadingFavoritePlaces = YES;
            NSDate *priorToDate = [[NSDate alloc] init];
            if (self.favoritePlaces.count > 0) priorToDate = ((PFObject *)[self.favoritePlaces lastObject]).updatedAt;
            [LikeRequest getUserFavoritesForUser:self.userObj priorToDate:priorToDate andLimit:20 withCompletionHandler:^(NSArray *favorites) {
                if (favorites.count > 0) {
                    [self.favoritePlaces addObjectsFromArray:favorites];
                    //if (self.segmentControl.selectedSegmentIndex == 0)
                    [self.collectionView reloadData];
                    self.isLoadingFavoritePlaces = NO;
                }
            }];
        }
//    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) return self.favoritePlaces.count;
//        else return self.matchPlaces.count;
//    } else
        return self.favoritePlaces.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyFavoriteCollectionViewCell *cell = (MyFavoriteCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) {
//            PFObject *likeObj = self.favoritePlaces[indexPath.row];
//            [cell setLikeObj:likeObj];
//        } else {
//            PFObject *likeObj = self.matchPlaces[indexPath.row];
//            [cell setLikeObj:likeObj];
//        }
//    } else {
        PFObject *likeObj = self.favoritePlaces[indexPath.row];
        [cell setLikeObj:likeObj];
//    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.selectedIndexPath = indexPath;
    
    PFObject *likeObj;
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) likeObj = self.favoritePlaces[indexPath.row];
//        else likeObj = self.matchPlaces[indexPath.row];
//    } else
        likeObj = self.favoritePlaces[indexPath.row];

    PropertyDetailViewController *detailViewController = [[PropertyDetailViewController alloc] init];
    detailViewController.capturedBackground = [Device captureScreenshot];
    detailViewController.propertyObj = likeObj[@"targetHouse"];
    [self.navigationController pushViewController:detailViewController animated:NO];
}

/**
 * Load more if user scrolled to the bottom of the screen
 * @param UIScrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offSetY = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    if (offSetY > contentHeight - scrollView.frame.size.height) [self loadMore];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.userObj[@"numMatches"] > 0) {
//        if (self.segmentControl.selectedSegmentIndex == 0) return [MyFavoriteCollectionViewCell sizeForLikeObj:self.favoritePlaces[indexPath.row]];
//        else return [MyFavoriteCollectionViewCell sizeForLikeObj:self.matchPlaces[indexPath.row]];
//    } else
        return [MyFavoriteCollectionViewCell sizeForLikeObj:self.favoritePlaces[indexPath.row]];
}

#pragma mark - button click
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Empty view delegate
 * Go back to browsing to find more favorite places
 */
-(void)goToBrowsing {
    BrowsePropertyViewController *browsePropertyViewController = [[BrowsePropertyViewController alloc] init];
    browsePropertyViewController.capturedBackground = [Device captureScreenshot];
    [self.navigationController pushViewController:browsePropertyViewController animated:NO];
}
@end
