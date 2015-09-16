//
//  MyUpcomingTripEmptyView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyUpcomingTripEmptyViewDelegate <NSObject>
-(void)goToMessages;
@end

@interface MyUpcomingTripEmptyView : UIView
@property (nonatomic, weak) id<MyUpcomingTripEmptyViewDelegate> emptyViewDelegate;
@end
