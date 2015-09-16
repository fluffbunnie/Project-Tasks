//
//  GuidedInteractionCompletedOverlayView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuidedInteractionCompletedOverlayViewDelegate <NSObject>

-(void)completeGuidedInteractionButtonClick;

@end

@interface GuidedInteractionCompletedOverlayView : UIView
@property (nonatomic, weak) id<GuidedInteractionCompletedOverlayViewDelegate> delegate;
-(void)setViewAlpha:(CGFloat)alpha;
@end
