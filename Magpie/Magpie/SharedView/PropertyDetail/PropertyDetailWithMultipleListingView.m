//
//  PropertyDetailTableViewController.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/64/14.
//  Copyright (c) 6414 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailWithMultipleListingView.h"
#import <Parse/Parse.h>
#import "FontColor.h"
#import "PropertyDetailHeaderImagesView.h"
#import "PropertyDetailBasicInfoTableViewCell.h"
#import "PropertyDetailListingInfoTableViewCell.h"
#import "PropertyDetailLocationTableViewCell.h"
#import "PropertyDetailAboutUserTableViewCell.h"

static const NSInteger ROW_BASIC_INFO = 0;
static const NSInteger ROW_ABOUT_USER = 1;
static const NSInteger ROW_LISTING_INFO = 2;
static const NSInteger ROW_HOUSING_PLAN = 3;
static const NSInteger ROW_LOCATION = 4;

@interface PropertyDetailWithMiltipleListingView ()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) BOOL shouldMoveUp;
@property (nonatomic, assign) CGFloat cummulativeYOffset;

@property (nonatomic, strong) PFObject *propertyObj;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyHeaderView;

@property (nonatomic, strong) PropertyDetailHeaderImagesView *headerImagesView;
@property (nonatomic, strong) PropertyDetailBasicInfoTableViewCell *basicInfoTableViewCell;
@property (nonatomic, strong) PropertyDetailAboutUserTableViewCell *aboutUserTableViewCell;
@property (nonatomic, strong) PropertyDetailListingInfoTableViewCell *listingInfoTableViewCell;
@property (nonatomic, strong) PropertyDetailHousingPlanTableViewCell *housingPlanTableViewCell;
@property (nonatomic, strong) PropertyDetailLocationTableViewCell *locationInfoTableViewCell;

@property (nonatomic, assign) BOOL shouldAllowUserToEditProfile;

@end

@implementation PropertyDetailWithMiltipleListingView
#pragma mark - initiation
/**
 * Lazily init the table view
 * @return UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

/**
 * Lazily init the empty header view
 * @return UIView
 */
-(UIView *)emptyHeaderView {
    if (_emptyHeaderView == nil) {
        _emptyHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight - 64)];
        _emptyHeaderView.backgroundColor = [UIColor clearColor];
        _emptyHeaderView.userInteractionEnabled = NO;
    }
    return _emptyHeaderView;
}

/**
 * Lazily init the header image views
 * @return header images
 */
-(PropertyDetailHeaderImagesView *)headerImagesView {
    if (_headerImagesView == nil) {
        _headerImagesView = [[PropertyDetailHeaderImagesView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight)];
        _headerImagesView.clipsToBounds = YES;
        _headerImagesView.userInteractionEnabled = YES;
        _headerImagesView.headerDelegate = self;
    }
    return _headerImagesView;
}

/**
 * Lazily init the basic info table view cell
 * @return UITableViewCell
 */
-(PropertyDetailBasicInfoTableViewCell *)basicInfoTableViewCell {
    if (_basicInfoTableViewCell == nil) {
        _basicInfoTableViewCell = [[PropertyDetailBasicInfoTableViewCell alloc] init];
    }
    return _basicInfoTableViewCell;
}

/**
 * Lazily init the listing info table view cell
 * @return UITableViewCell
 */
-(PropertyDetailListingInfoTableViewCell *)listingInfoTableViewCell {
    if (_listingInfoTableViewCell == nil) _listingInfoTableViewCell = [[PropertyDetailListingInfoTableViewCell alloc] init];
    return _listingInfoTableViewCell;
}

/**
 * Lazily init about user table view cell
 * @return UITableViewCell
 */
-(PropertyDetailAboutUserTableViewCell *)aboutUserTableViewCell {
    if (_aboutUserTableViewCell == nil) {
        _aboutUserTableViewCell = [[PropertyDetailAboutUserTableViewCell alloc] init];
        _aboutUserTableViewCell.shouldAllowUserToEditProfile = self.shouldAllowUserToEditProfile;
        _aboutUserTableViewCell.delegate = self;
    }
    return _aboutUserTableViewCell;
}

/**
 * Lazily init the housing plan cell
 * @return UITableViewCell
 */
-(PropertyDetailHousingPlanTableViewCell *)housingPlanTableViewCell {
    if (_housingPlanTableViewCell == nil) {
        _housingPlanTableViewCell = [[PropertyDetailHousingPlanTableViewCell alloc] init];
        _housingPlanTableViewCell.housingPlanDelegate = self;
    }
    return _housingPlanTableViewCell;
}

/**
 * Lazily init the location info table view cell
 * @return UITableViewCell
 */
-(PropertyDetailLocationTableViewCell *)locationInfoTableViewCell {
    if (_locationInfoTableViewCell == nil) {
        _locationInfoTableViewCell = [[PropertyDetailLocationTableViewCell alloc] init];
    }
    return _locationInfoTableViewCell;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self headerImagesView]];
        [self addSubview:[self tableView]];
        self.tableView.tableHeaderView = [self emptyHeaderView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andCanGoToUserProfile:(BOOL)canGoToProfile {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.shouldAllowUserToEditProfile = canGoToProfile;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self headerImagesView]];
        [self addSubview:[self tableView]];
        self.tableView.tableHeaderView = [self emptyHeaderView];
    }
    return self;

}

/**
 * Set the property object to be display
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    self.propertyObj = propertyObj;
    [self.headerImagesView setCoverPhoto:self.propertyObj[@"coverPic"]];
    [self.basicInfoTableViewCell setPropertyObject:self.propertyObj];
    [self.aboutUserTableViewCell setUserObject:self.propertyObj[@"owner"]];
    [self.listingInfoTableViewCell setPropertyObject:self.propertyObj];
    [self.locationInfoTableViewCell setPropertyObject:self.propertyObj];
}

-(void)setPropertyPhotos:(NSArray *)photos {
    if (photos.count > 0) [self.headerImagesView setPropertyPhotos:photos];
}

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - cell's delegate
/**
 * Delegate that tell the table to be refresh
 */
-(void)refreshTable {
    [self.tableView reloadData];
}

/**
 * PropertyDetailAboutUserTableViewCell Delegate
 * Handle the case when user want to edit the user profile
 */
-(void)goToUserProfile {
    [self.detailDelegate goToUserProfile];
}

/**
 * Housing plan delegate. Handle the behavior when user pressed on any of the housing button
 * @param button index
 */
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index {
    [self.detailDelegate housingLayoutButtonClickAtIndex:index];
}

/**
 * Header delegate
 * action when the header is tapped
 */
-(void)propertyHeaderClicked {
    if (!self.tableView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, self.viewHeight - (0.5 * self.viewWidth + 64), self.viewWidth, self.viewHeight);
            self.headerImagesView.backgroundColor = [UIColor blackColor];
            [self.headerImagesView setViewFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
            [self.headerImagesView showPropertyDescription:YES];
        } completion:^(BOOL finished) {
            [self.detailDelegate setFloatingButtonHidden:YES];
            self.tableView.hidden = YES;
            self.headerImagesView.userInteractionEnabled = YES;
        }];
    } else {
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
            self.headerImagesView.backgroundColor = [UIColor whiteColor];
            [self.headerImagesView setViewFrame:CGRectMake(0, 0, self.viewWidth, 64 * 2 + 0.5 * self.viewWidth)];
            [self.headerImagesView showPropertyDescription:NO];
        } completion:^(BOOL finished) {
            [self.detailDelegate setFloatingButtonHidden:NO];
            self.headerImagesView.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case ROW_BASIC_INFO:
            return [self basicInfoTableViewCell];
            
        case ROW_ABOUT_USER:
            return [self aboutUserTableViewCell];
            
        case ROW_LISTING_INFO:
            return [self listingInfoTableViewCell];
            
        case ROW_HOUSING_PLAN:
            return [self housingPlanTableViewCell];
            
        case ROW_LOCATION:
            return [self locationInfoTableViewCell];
            
        default:
            return [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case ROW_BASIC_INFO:
            return [[self basicInfoTableViewCell] viewHeight];
            
        case ROW_ABOUT_USER:
            return [[self aboutUserTableViewCell] viewHeight];
            
        case ROW_LISTING_INFO:
            return [[self listingInfoTableViewCell] viewHeight];
            
        case ROW_HOUSING_PLAN:
            return [[self housingPlanTableViewCell] viewHeight];
            
        case ROW_LOCATION:
            return [[self locationInfoTableViewCell] viewHeight];
            
        default:
            return 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat scrollOffset = scrollView.contentOffset.y;
        if (scrollOffset <= 0) {
            if (self.shouldMoveUp) {
                self.cummulativeYOffset += scrollOffset;
                scrollView.contentOffset = CGPointMake(0, 0);
                [self.detailDelegate detailSwipeYOffset:self.cummulativeYOffset];
            } else {
                [self.headerImagesView setViewFrame:CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight - scrollOffset)];
            }
        } else {
            CGFloat trueOffset = self.cummulativeYOffset + scrollOffset;
            if (trueOffset < 0) {
                self.cummulativeYOffset = trueOffset;
                scrollView.contentOffset = CGPointMake(0, 0);
                [self.detailDelegate detailSwipeYOffset:self.cummulativeYOffset];
            } else {
                self.cummulativeYOffset = 0;
                [self.detailDelegate detailSwipeYOffset:0];
                [self.headerImagesView setViewFrame:CGRectMake(0, -scrollOffset, self.viewWidth, 0.5 * self.viewHeight)];
            }
        }
    }
}

/**
 * UIScrollView delegate
 * When the scroll view begin dragging
 * @param UIScrollView
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.cummulativeYOffset = 0;
    if ([scrollView isKindOfClass:[UITableView class]]) self.shouldMoveUp = YES;
}

/**
 * UIScrollView Delegate
 * Handle when user stop dragging
 */
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.shouldMoveUp = NO;
        if (self.cummulativeYOffset < -150) [self.detailDelegate goBack];
        else [UIView animateWithDuration:0.2 animations:^{
            [self.detailDelegate detailSwipeYOffset:0];
        }];
    }
}

#pragma mark - hit test
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.emptyHeaderView convertPoint:point fromView:self];
    if ([self.emptyHeaderView pointInside:buttonPoint withEvent:event]) return self.headerImagesView;
    return result;
}


@end
