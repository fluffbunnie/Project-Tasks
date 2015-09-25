//
//  BrowseDetailScrollView.h
//  Magpie
//
//  Created by minh thao nguyen on 6/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseDetailView.h"
#import "BrowsePropertyViewController.h"

@class BrowsePropertyViewController;

@interface BrowseDetailScrollView : UIView <UIScrollViewDelegate, BrowseDetailViewDelegate>
@property (nonatomic, weak) BrowsePropertyViewController *parentController;
-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController;
-(void)setPropertyObjects:(NSArray *)propertyObjs;
-(void)setPhotos:(NSArray *)photos forPropertyObj:(PFObject *)propertyObj;

-(void)setLike:(BOOL)like forPropertyObj:(PFObject *)propertyObj;
-(void)viewNextCard;
-(void)viewPreviousCard;

-(void)setShouldLoadPicture:(BOOL)shouldLoadPicture;
@end
