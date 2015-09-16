//
//  HomePageTableView.h
//  Magpie
//
//  Created by minh thao nguyen on 4/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageViewDelegate <NSObject>
-(void)homePageHamburgerIconClick;
-(void)homePageHeaderViewClick;
-(void)homePageItemClickAtIndex:(NSIndexPath *)indexPath;
@end

@interface HomePageView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<HomePageViewDelegate> homePageDelegate;
-(void)reloadHamburger;

@end
