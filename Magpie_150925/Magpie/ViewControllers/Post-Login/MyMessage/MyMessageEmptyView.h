//
//  MyMessageEmptyView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MyMessageEmptyViewDelegate <NSObject>
-(void)goToFavorites;
@end

@interface MyMessageEmptyView : UIView
@property (nonatomic, weak) id<MyMessageEmptyViewDelegate> emptyViewDelegate;
@end
