//
//  PropertyDetailTableViewController.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/20/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PropertyDetailBasicInfoTableViewCell.h"
#import "PropertyDetailAboutUserTableViewCell.h"
#import "PropertyDetailHeaderImagesView.h"
#import "PropertyDetailHousingPlanTableViewCell.h"
#import "PropertyDetailListingInfoTableViewCell.h"

@protocol PropertyDetailWithMiltipleListingViewDelegate <NSObject>
-(void)setFloatingButtonHidden:(BOOL)hidden;
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index;
-(void)goBack;
-(void)detailSwipeYOffset:(CGFloat)yOffset;
@optional
-(void)goToUserProfile;
@end

@interface PropertyDetailWithMiltipleListingView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, PropertyDetailAboutUserDelegate, PropertyDetailHeaderImagesViewDelegate, PropertyDetailHousingPlanDelegate, PropertyDetailListingInfoDelegate>

@property (nonatomic, weak) id<PropertyDetailWithMiltipleListingViewDelegate> detailDelegate;
-(id)initWithFrame:(CGRect)frame andCanGoToUserProfile:(BOOL)canGoToProfile;
-(void)setPropertyObject:(PFObject *)propertyObj;
-(void)setPropertyPhotos:(NSArray *)photos;
-(void)refreshTable;
@end
