//
//  BrowseDetailView.h
//  Magpie
//
//  Created by minh thao nguyen on 6/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PropertyDetailBasicInfoTableViewCell.h"
#import "PropertyDetailAboutUserTableViewCell.h"
#import "PropertyDetailHeaderImagesView.h"
#import "PropertyDetailHousingPlanTableViewCell.h"

@protocol BrowseDetailViewDelegate <NSObject>
-(void)setFloatingButtonHidden:(BOOL)hidden;
@end

#import "BrowsePropertyViewController.h"
@class BrowsePropertyViewController;

@interface BrowseDetailView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PropertyDetailAboutUserDelegate, PropertyDetailHeaderImagesViewDelegate, PropertyDetailHousingPlanDelegate>
@property (nonatomic, weak) BrowsePropertyViewController *parentController;
@property (nonatomic, weak) id<BrowseDetailViewDelegate> detailDelegate;

-(id)initWithFrame:(CGRect)frame andParentController:(BrowsePropertyViewController *)parentController;
-(void)setPropertyObject:(PFObject *)propertyObj;
-(void)setPropertyPhotos:(NSArray *)photos;
-(void)scrollToTop;
-(void)setLike:(BOOL)like;

@end
