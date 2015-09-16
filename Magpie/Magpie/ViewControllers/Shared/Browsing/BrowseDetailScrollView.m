//
//  BrowseDetailScrollView.m
//  Magpie
//
//  Created by minh thao nguyen on 6/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "BrowseDetailScrollView.h"

static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface BrowseDetailScrollView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) NSArray *propertiesArray;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) BrowseDetailView *prevDetailView;
@property (nonatomic, strong) BrowseDetailView *currentDetailView;
@property (nonatomic, strong) BrowseDetailView *nextDetailView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) NSInteger currentCardIndex;

@property (nonatomic, assign) BOOL loadPicture;
@end

@implementation BrowseDetailScrollView
#pragma mark - initiation
/**
 * Lazily init the content's scroll view
 * @return UIScrollView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.self.viewHeight)];
        _containerView.contentSize = CGSizeMake(3 * self.viewWidth, self.viewHeight);
        _containerView.contentOffset = CGPointMake(self.viewWidth, 0);
        _containerView.scrollEnabled = NO;
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.scrollsToTop = NO;
        _containerView.delegate = self;
    }
    return _containerView;
}

/**
 * Lazily init the prev detail view
 * @param BrowseDetailView
 */
-(BrowseDetailView *)prevDetailView {
    if (_prevDetailView == nil) {
        _prevDetailView = [[BrowseDetailView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _prevDetailView.detailDelegate = self;
    }
    return _prevDetailView;
}

/**
 * Lazily init the current detail view
 * @param BrowseDetailView
 */
-(BrowseDetailView *)currentDetailView {
    if (_currentDetailView == nil) {
        _currentDetailView = [[BrowseDetailView alloc] initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _currentDetailView.detailDelegate = self;
    }
    return _currentDetailView;
}

/**
 * Lazily init the next detail view
 * @param BrowseDetailView
 */
-(BrowseDetailView *)nextDetailView {
    if (_nextDetailView == nil) {
        _nextDetailView = [[BrowseDetailView alloc] initWithFrame:CGRectMake(2 * self.viewWidth, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _nextDetailView.detailDelegate = self;
    }
    return _nextDetailView;
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
        
        [_backButton addTarget:self action:@selector(hideDetailView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentController = parentController;
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self prevDetailView]];
        [self.containerView addSubview:[self currentDetailView]];
        [self.containerView addSubview:[self nextDetailView]];
        
        [self addSubview:[self backButton]];
    }
    return self;
}

-(void)dealloc {
    self.containerView.delegate = nil;
}

/**
 * Set the property objects. On setting, we init the cards view
 * @param NSArray
 */
-(void)setPropertyObjects:(NSArray *)propertyObjects {
    self.propertiesArray = propertyObjects;
    self.containerView.scrollEnabled = (propertyObjects.count > 1);
    
    [self.prevDetailView setPropertyObject:[self.propertiesArray lastObject]];
    [self.currentDetailView setPropertyObject:[self.propertiesArray firstObject]];
    [self.nextDetailView setPropertyObject:self.propertiesArray[1 % self.propertiesArray.count]];
    
    [self.parentController findLikeStatusForPropertyObj:[self.propertiesArray lastObject]];
    [self.parentController findLikeStatusForPropertyObj:[self.propertiesArray firstObject]];
    [self.parentController findLikeStatusForPropertyObj:self.propertiesArray[1 % self.propertiesArray.count]];
}

/**
 * Tell the scroll view to load more picture for the detail view
 * @param BOOL
 */
-(void)setShouldLoadPicture:(BOOL)shouldLoadPicture {
    self.loadPicture = shouldLoadPicture;
    if (self.loadPicture == YES) {
        [self.parentController requestGetPhotosForPropertyObj:self.propertiesArray[self.currentCardIndex]];
    }
}

/**
 * Set the photos to display
 * @param NSArray
 */
-(void)setPhotos:(NSArray *)photos forPropertyObj:(PFObject *)propertyObj {
    PFObject *currentPropertyObj = self.propertiesArray[self.currentCardIndex];
    if ([propertyObj.objectId isEqualToString:currentPropertyObj.objectId]) [self.currentDetailView setPropertyPhotos:photos];
}

/**
 * Set the like state for a property obj
 * @param BOOL
 * @param PFObject
 */
-(void)setLike:(BOOL)like forPropertyObj:(PFObject *)propertyObj {
    PFObject *currentPropertyObj = self.propertiesArray[self.currentCardIndex];
    
    NSInteger prevPropertyIndex = self.currentCardIndex - 1;
    if (prevPropertyIndex == -1) prevPropertyIndex = self.propertiesArray.count - 1;
    PFObject *previousPropertyObj = self.propertiesArray[prevPropertyIndex];
    
    NSInteger nextPropertyIndex = (self.currentCardIndex + 1) % self.propertiesArray.count;
    PFObject *nextPropertyObj = self.propertiesArray[nextPropertyIndex];
    
    if ([propertyObj.objectId isEqualToString:currentPropertyObj.objectId]) [self.currentDetailView setLike:like];
    if ([propertyObj.objectId isEqualToString:previousPropertyObj.objectId]) [self.prevDetailView setLike:like];
    if ([propertyObj.objectId isEqualToString:nextPropertyObj.objectId]) [self.nextDetailView setLike:like];
}

/**
 * View the next card in the list
 */
-(void)viewNextCard {
    if (self.propertiesArray.count > 1) {
        self.currentCardIndex = (self.currentCardIndex + 1) % self.propertiesArray.count;
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView setContentOffset:CGPointMake(2 * self.viewWidth, 0)];
        } completion:^(BOOL finished) {
            BrowseDetailView *tempDetailView = self.prevDetailView;
            
            self.prevDetailView = self.currentDetailView;
            self.prevDetailView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
            [self.prevDetailView scrollToTop];
            self.currentDetailView = self.nextDetailView;
            self.currentDetailView.frame = CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight);
            [self.containerView setContentOffset:CGPointMake(self.viewWidth, 0) animated:NO];
            
            self.nextDetailView = tempDetailView;
            self.nextDetailView.frame = CGRectMake(2 * self.viewWidth, 0, self.viewWidth, self.viewHeight);
            NSInteger nextPropertyIndex = (self.currentCardIndex + 1) % self.propertiesArray.count;
            [self.nextDetailView setPropertyObject:self.propertiesArray[nextPropertyIndex]];
            self.containerView.scrollEnabled = YES;
            [self.parentController findLikeStatusForPropertyObj:self.propertiesArray[nextPropertyIndex]];
            
            if (self.loadPicture == YES) {
                [self.parentController requestGetPhotosForPropertyObj:self.propertiesArray[self.currentCardIndex]];
            }
        }];
    }
}

/**
 * View the previous card in the list
 */
-(void)viewPreviousCard {
    if (self.propertiesArray.count > 1) {
        if (self.currentCardIndex == 0) self.currentCardIndex = self.propertiesArray.count - 1;
        else self.currentCardIndex = self.currentCardIndex - 1;
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            BrowseDetailView *tempDetailView = self.nextDetailView;
            
            self.nextDetailView = self.currentDetailView;
            self.nextDetailView.frame = CGRectMake(2 * self.viewWidth, 0, self.viewWidth, self.viewHeight);
            [self.nextDetailView scrollToTop];
            self.currentDetailView = self.prevDetailView;
            self.currentDetailView.frame = CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight);
            [self.containerView setContentOffset:CGPointMake(self.viewWidth, 0) animated:NO];
            
            self.prevDetailView = tempDetailView;
            self.prevDetailView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
            NSInteger prevPropertyIndex = self.currentCardIndex - 1;
            if (prevPropertyIndex == -1) prevPropertyIndex = self.propertiesArray.count - 1;
            [self.prevDetailView setPropertyObject:self.propertiesArray[prevPropertyIndex]];
            self.containerView.scrollEnabled = YES;
            
            [self.parentController findLikeStatusForPropertyObj:self.propertiesArray[prevPropertyIndex]];
            
            if (self.loadPicture == YES) {
                [self.parentController requestGetPhotosForPropertyObj:self.propertiesArray[self.currentCardIndex]];
            }
        }];
    }
}

#pragma mark - delegate
/**
 * Hide the detail view
 */
-(void)hideDetailView {
    [self.parentController hideCardDetail];
}

/**
 * BrowseDetailView delegate
 * hide the back button if necessary
 * @param BOOL
 */
-(void)setFloatingButtonHidden:(BOOL)hidden {
    self.backButton.hidden = hidden;
    self.containerView.scrollEnabled = !hidden;
}

/**
 * UIScrollView Delegate
 * Handle the behavior when the scroll view ended scrolling
 * @param UIScrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.containerView.scrollEnabled = NO;
    if ([self getCurrentPage] == 0) [self.parentController showPrevCard];
    else if ([self getCurrentPage] == 2) [self.parentController showNextCard];
    else self.containerView.scrollEnabled = YES;
}

/**
 * Get the current page of the scroll view
 */
-(NSInteger)getCurrentPage {
    return MIN(MAX(self.containerView.contentOffset.x/self.viewWidth, 0), 2);
}
@end
