//
//  BrowseCardView.h
//  Magpie
//
//  Created by minh thao nguyen on 6/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol BrowseCardViewDelegate <NSObject>
-(void)cardSwipingXOffset:(CGFloat)xFromCenter;
-(void)cardHorizontalSwipingStopped;
@end

#import "BrowsePropertyViewController.h"

@class BrowsePropertyViewController;

@interface BrowseCardView : UIView
@property (nonatomic, weak) BrowsePropertyViewController *parentController;
@property (nonatomic, weak) id<BrowseCardViewDelegate> cardDelegate;

-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController;
-(void)setPropertyObject:(PFObject *)propertyObj;
-(void)animateView;
-(void)setLike:(BOOL)like;
@end
