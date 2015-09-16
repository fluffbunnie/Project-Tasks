//
//  MyFavoriteEmptyView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyFavoriteEmptyViewDelegate <NSObject>
-(void)goToBrowsing;
@end

@interface MyFavoriteEmptyView : UIView
@property (nonatomic, weak) id<MyFavoriteEmptyViewDelegate> emptyViewDelegate;
@end
