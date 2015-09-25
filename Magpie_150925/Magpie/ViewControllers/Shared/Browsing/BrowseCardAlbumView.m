//
//  BrowseCardAlbumView.m
//  Magpie
//
//  Created by minh thao nguyen on 6/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "BrowseCardAlbumView.h"

static float CARD_SCALE = 0.8;
static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface BrowseCardAlbumView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) NSArray *propertiesArray;
@property (nonatomic, strong) BrowseCardView *previousCardView;
@property (nonatomic, strong) BrowseCardView *currentCardView;
@property (nonatomic, strong) BrowseCardView *nextCardView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) NSInteger currentCardIndex;
@end

@implementation BrowseCardAlbumView
#pragma mark - initiation
/**
 * Lazily init the previous card view
 * @return BrowseCardView
 */
-(BrowseCardView *)previousCardView {
    if (_previousCardView == nil) {
        _previousCardView = [[BrowseCardView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _previousCardView.alpha = 0.6;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
        CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(-self.viewWidth, 0);
        _previousCardView.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
    }
    return _previousCardView;
}

/**
 * Lazily init the current card view
 * @return BrowseCardView
 */
-(BrowseCardView *)currentCardView {
    if (_currentCardView == nil) {
        _currentCardView = [[BrowseCardView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _currentCardView.hidden = 0;
        _currentCardView.cardDelegate = self;
    }
    return _currentCardView;
}

/**
 * Lazily init the next card view
 * @return BrowseCardView
 */
-(BrowseCardView *)nextCardView {
    if (_nextCardView == nil) {
        _nextCardView = [[BrowseCardView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) andParentController:self.parentController];
        _nextCardView.alpha = 0.6;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
        CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
        _nextCardView.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
    }
    return _nextCardView;
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

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentController = parentController;
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.currentCardIndex = 0;
        
        [self addSubview:[self previousCardView]];
        [self addSubview:[self currentCardView]];
        [self addSubview:[self nextCardView]];
        [self addSubview:[self backButton]];
    }
    return self;
}

/**
 * Set the property objects. On setting, we init the cards view
 * @param NSArray
 */
-(void)setPropertyObjects:(NSArray *)propertyObjects {
    self.propertiesArray = propertyObjects;
    self.currentCardView.hidden = NO;
    
    [self.previousCardView setPropertyObject:[self.propertiesArray lastObject]];
    [self.currentCardView setPropertyObject:[self.propertiesArray firstObject]];
    [self.nextCardView setPropertyObject:self.propertiesArray[1 % self.propertiesArray.count]];
}

/**
 * Animate the card so the image is sliding on the view
 */
-(void)animateCardView {
    if (self.previousCardView != nil) [self.previousCardView animateView];
    if (self.currentCardView != nil) [self.currentCardView animateView];
    if (self.nextCardView != nil) [self.nextCardView animateView];
}

/**
 * Set the like state
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
    
    if ([propertyObj.objectId isEqualToString:currentPropertyObj.objectId]) [self.currentCardView setLike:like];
    if ([propertyObj.objectId isEqualToString:previousPropertyObj.objectId]) [self.previousCardView setLike:like];
    if ([propertyObj.objectId isEqualToString:nextPropertyObj.objectId]) [self.nextCardView setLike:like];
}

/**
 * View the next card in the deck
 */
-(void)viewNextCard {
    if (self.propertiesArray.count > 1) {
        self.currentCardIndex = (self.currentCardIndex + 1) % self.propertiesArray.count;
        
        [UIView animateWithDuration:0.15 animations:^{
            //current card
            self.currentCardView.alpha = 0.6;
            CGAffineTransform currentCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform currentCardTranslationTransform = CGAffineTransformMakeTranslation(-self.viewWidth, 0);
            self.currentCardView.transform = CGAffineTransformConcat(currentCardScaleTransform, currentCardTranslationTransform);
            
            //next card
            self.nextCardView.alpha = 1;
            CGAffineTransform nextCardScaleTransform = CGAffineTransformMakeScale(1, 1);
            CGAffineTransform nextCardTranslationTransform = CGAffineTransformMakeTranslation(0, 0);
            self.nextCardView.transform = CGAffineTransformConcat(nextCardScaleTransform, nextCardTranslationTransform);
        } completion:^(BOOL finished) {
            //next card
            self.previousCardView.alpha = 0.6;
            CGAffineTransform prevCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform prevCardTranslationTransform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
            self.previousCardView.transform = CGAffineTransformConcat(prevCardScaleTransform, prevCardTranslationTransform);
            
            self.currentCardView.cardDelegate = nil;
            
            //now we reorder the cards to make sure it is the right order
            BrowseCardView *tempCardView = self.currentCardView;
            self.currentCardView = self.nextCardView;
            self.nextCardView = self.previousCardView;
            self.previousCardView = tempCardView;
            self.currentCardView.cardDelegate = self;
            
            //finally load the new information for the prev card view
            if (self.currentCardIndex == (self.propertiesArray.count - 1)) [self.nextCardView setPropertyObject:[self.propertiesArray firstObject]];
            else [self.nextCardView setPropertyObject:self.propertiesArray[self.currentCardIndex + 1]];
        }];
    }
}

/**
 * View the previous card in the deck
 */
-(void)viewPreviousCard {
    if (self.propertiesArray.count > 1) {
        if (self.currentCardIndex == 0) self.currentCardIndex = self.propertiesArray.count - 1;
        else self.currentCardIndex = self.currentCardIndex - 1;
        
        [UIView animateWithDuration:0.15 animations:^{
            //previous card
            self.previousCardView.alpha = 1;
            CGAffineTransform prevCardScaleTransform = CGAffineTransformMakeScale(1, 1);
            CGAffineTransform prevCardTranslationTransform = CGAffineTransformMakeTranslation(0, 0);
            self.previousCardView.transform = CGAffineTransformConcat(prevCardScaleTransform, prevCardTranslationTransform);
            
            //current card
            self.currentCardView.alpha = 0.6;
            CGAffineTransform currentCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform currentCardTranslationTransform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
            self.currentCardView.transform = CGAffineTransformConcat(currentCardScaleTransform, currentCardTranslationTransform);
        } completion:^(BOOL finished) {
            //next card
            self.nextCardView.alpha = 0.6;
            CGAffineTransform nextCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform nextCardTranslationTransform = CGAffineTransformMakeTranslation(-self.viewWidth, 0);
            self.nextCardView.transform = CGAffineTransformConcat(nextCardScaleTransform, nextCardTranslationTransform);
            
            self.currentCardView.cardDelegate = nil;
            
            //now we reorder the cards to make sure it is the right order
            BrowseCardView *tempCardView = self.currentCardView;
            self.currentCardView = self.previousCardView;
            self.previousCardView = self.nextCardView;
            self.nextCardView = tempCardView;
            self.currentCardView.cardDelegate = self;
            
            //finally load the new information for the prev card view
            if (self.currentCardIndex == 0) [self.previousCardView setPropertyObject:[self.propertiesArray lastObject]];
            else [self.previousCardView setPropertyObject:self.propertiesArray[self.currentCardIndex - 1]];
        }];
    }
}


#pragma mark - property card delegate and actions
/**
 * Go back to the previous screen
 */
-(void)goBack {
    [self.parentController goBack];
}

/**
 * Delegate when user swipe the card an x-value from the center
 * @param CGFloat
 */
-(void)cardSwipingXOffset:(CGFloat)xFromCenter {
    if (self.propertiesArray.count > 1) {
        self.currentCardView.alpha = MIN(1, 1 - 0.8 * fabs(xFromCenter)/self.viewWidth);
        CGFloat currenCardScale = MIN(1, 1 - (1 - CARD_SCALE) * fabs(xFromCenter)/self.viewWidth);
        CGAffineTransform currentCardScaleTransform = CGAffineTransformMakeScale(currenCardScale, currenCardScale);
        CGAffineTransform currentCardTranslationTranform = CGAffineTransformMakeTranslation(xFromCenter, 0);
        self.currentCardView.transform = CGAffineTransformConcat(currentCardScaleTransform, currentCardTranslationTranform);
        
        if (xFromCenter < 0) {
            //next card
            self.nextCardView.alpha = MIN(1, 0.6 + 0.4 * fabs(xFromCenter)/self.viewWidth);
            CGFloat nextCardScale = MIN(1, CARD_SCALE + (1 - CARD_SCALE) * fabs(xFromCenter)/self.viewWidth);
            CGAffineTransform nextCardScaleTransform = CGAffineTransformMakeScale(nextCardScale, nextCardScale);
            CGAffineTransform nextCardTranslationTransform = CGAffineTransformMakeTranslation(self.viewWidth + xFromCenter, 0);
            self.nextCardView.transform = CGAffineTransformConcat(nextCardScaleTransform, nextCardTranslationTransform);
            
            //prev card
            self.previousCardView.alpha = 0.6;
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.8, 0.8);
            CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(-self.viewWidth, 0);
            self.previousCardView.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
        } else {
            //prev card
            self.previousCardView.alpha = MIN(1, 0.6 + 0.4 * fabs(xFromCenter)/self.viewWidth);
            CGFloat prevCardScale = MIN(1, CARD_SCALE + (1- CARD_SCALE) * fabs(xFromCenter)/self.viewWidth);
            CGAffineTransform prevCardScaleTransform = CGAffineTransformMakeScale(prevCardScale, prevCardScale);
            CGAffineTransform prevCardTranslationTransform = CGAffineTransformMakeTranslation(xFromCenter - self.viewWidth, 0);
            self.previousCardView.transform = CGAffineTransformConcat(prevCardScaleTransform, prevCardTranslationTransform);
            
            //next card
            self.nextCardView.alpha = 0.6;
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
            self.nextCardView.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
        }
    }
}

/**
 * Delegate when user fail to complete the swiping (left/right) action
 */
-(void)cardHorizontalSwipingStopped {
    if (self.propertiesArray.count > 1) {
        [UIView animateWithDuration:0.2 animations:^{
            //prev card
            self.previousCardView.alpha = 0.6;
            CGAffineTransform prevCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform prevCardTranslationTransform = CGAffineTransformMakeTranslation(-self.viewWidth, 0);
            self.previousCardView.transform = CGAffineTransformConcat(prevCardScaleTransform, prevCardTranslationTransform);
            
            //current card
            self.currentCardView.alpha = 1;
            CGAffineTransform currentCardScaleTransform = CGAffineTransformMakeScale(1, 1);
            CGAffineTransform currentCardTranslationTransform = CGAffineTransformMakeTranslation(0, 0);
            self.currentCardView.transform = CGAffineTransformConcat(currentCardScaleTransform , currentCardTranslationTransform);
            
            //next card
            self.nextCardView.alpha = 0.6;
            CGAffineTransform nextCardScaleTransform = CGAffineTransformMakeScale(CARD_SCALE, CARD_SCALE);
            CGAffineTransform nextCardTranslationTransform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
            self.nextCardView.transform = CGAffineTransformConcat(nextCardScaleTransform, nextCardTranslationTransform);
        }];
    }
}

@end