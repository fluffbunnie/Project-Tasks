//
//  BrowseDetailView.m
//  Magpie
//
//  Created by minh thao nguyen on 6/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "BrowseDetailView.h"
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

@interface BrowseDetailView ()

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

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *bookButton;
@property (nonatomic, strong) UIButton *likeButton;
@end

@implementation BrowseDetailView
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

/**
 * Lazily init the button's container view
 * @return UIView
 */
-(UIView *)buttonContainerView {
    if (_buttonContainerView == nil) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 50, self.viewWidth, 50)];
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
        _bookButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, self.viewWidth - 100, 50)];
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
        _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth - 50, 0, 50, 50)];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        _likeButton.hidden = YES;
        [_likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentController = parentController;
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.cummulativeYOffset = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self headerImagesView]];
        [self addSubview:[self tableView]];
        self.tableView.tableHeaderView = [self emptyHeaderView];
        
        [self addSubview:[self buttonContainerView]];
        [self.buttonContainerView addSubview:[self messageButton]];
        [self.buttonContainerView addSubview:[self bookButton]];
        [self.buttonContainerView addSubview:[self likeButton]];
    }
    return self;
}

/**
 * Set the property object to be display
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    self.propertyObj = propertyObj;
    self.likeButton.hidden = YES;
    [self.headerImagesView setCoverPhoto:self.propertyObj[@"coverPic"]];
    [self.basicInfoTableViewCell setPropertyObject:self.propertyObj];
    [self.aboutUserTableViewCell setUserObject:self.propertyObj[@"owner"]];
    [self.listingInfoTableViewCell setPropertyObject:self.propertyObj];
    [self.locationInfoTableViewCell setPropertyObject:self.propertyObj];
    [self.tableView reloadData];
}

/**
 * Scroll the view to top
 */
-(void)scrollToTop {
    [self.tableView setContentOffset:CGPointZero];
}

/**
 * Set the property photos
 * @param NSArray
 */
-(void)setPropertyPhotos:(NSArray *)photos {
    if (photos.count > 0) [self.headerImagesView setPropertyPhotos:photos];
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
 * Housing plan delegate. Handle the behavior when user pressed on any of the housing button
 * @param button index
 */
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index {
    [self.parentController housingLayoutButtonClickAtIndex:index forPropertyObj:self.propertyObj];
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
            self.buttonContainerView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.detailDelegate setFloatingButtonHidden:YES];
            self.tableView.hidden = YES;
            self.buttonContainerView.hidden = YES;
            self.headerImagesView.userInteractionEnabled = YES;
        }];
    } else {
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
            self.headerImagesView.backgroundColor = [UIColor whiteColor];
            [self.headerImagesView setViewFrame:CGRectMake(0, 0, self.viewWidth, 64 * 2 + 0.5 * self.viewWidth)];
            [self.headerImagesView showPropertyDescription:NO];
            self.buttonContainerView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.detailDelegate setFloatingButtonHidden:NO];
            self.buttonContainerView.hidden = NO;
            self.headerImagesView.userInteractionEnabled = YES;
        }];
    }
}

/**
 * Handle the action when the user click on the like button
 */
-(void)likeButtonClick {
    self.likeButton.enabled = NO;
    [self.parentController likeClickForPropertyObj:self.propertyObj];
}

/**
 * Handle the action when user click on the book button
 */
-(void)bookButtonClick {
    [self.parentController bookButtonClickForPropertyObj:self.propertyObj];
}

/**
 * Handle the action when user click on the message button
 */
-(void)messageButtonClick {
    [self.parentController messageButtonClickForPropertyObj:self.propertyObj];
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
/**
 * UIScrollView delegate
 * When the scroll view is scrolling
 * @param UIScrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat scrollOffset = scrollView.contentOffset.y;
        if (scrollOffset <= 0) {
            if (self.shouldMoveUp) {
                self.cummulativeYOffset += scrollOffset;
                scrollView.contentOffset = CGPointMake(0, 0);
                [self.parentController cardSwipeYOffset:-self.viewHeight - self.cummulativeYOffset];
            } else {
                [self.headerImagesView setViewFrame:CGRectMake(0, 0, self.viewWidth, 0.5 * self.viewHeight - scrollOffset)];
            }
        } else {
            CGFloat trueOffset = self.cummulativeYOffset + scrollOffset;
            if (trueOffset < 0) {
                self.cummulativeYOffset = trueOffset;
                scrollView.contentOffset = CGPointMake(0, 0);
                [self.parentController cardSwipeYOffset:-self.viewHeight - self.cummulativeYOffset];
            } else {
                self.cummulativeYOffset = 0;
                [self.parentController cardSwipeYOffset:-self.viewHeight];
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
        if (self.cummulativeYOffset < -150) [self.parentController hideCardDetail];
        else [self.parentController showCardDetail];
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
