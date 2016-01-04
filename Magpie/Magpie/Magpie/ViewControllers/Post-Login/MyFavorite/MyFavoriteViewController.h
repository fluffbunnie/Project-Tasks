//
//  MyFavoriteViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyFavoriteEmptyView.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface MyFavoriteViewController : UIViewController <MyFavoriteEmptyViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
-(void)removeSelectedPropertyFromFavorite;
@end
