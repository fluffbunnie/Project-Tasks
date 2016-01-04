//
//  BrowseCardAlbumView.h
//  Magpie
//
//  Created by minh thao nguyen on 6/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseCardView.h"
#import "BrowsePropertyViewController.h"

@class BrowsePropertyViewController;

@interface BrowseCardAlbumView : UIView <BrowseCardViewDelegate>
@property (nonatomic, weak) BrowsePropertyViewController *parentController;
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController;
-(void)setPropertyObjects:(NSArray *)propertyObjs;
-(void)animateCardView;
-(void)setLike:(BOOL)like forPropertyObj:(PFObject *)propertyObj;

-(void)viewNextCard;
-(void)viewPreviousCard;
@end
