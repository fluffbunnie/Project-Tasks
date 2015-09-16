//
//  ImportNudgePopup.h
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImportNudgePopupDelegate <NSObject>
-(void)goToMyPlace;
-(void)goBackToPreviousScreen;
@end

@interface ImportNudgePopup : UIView
@property (nonatomic, weak) id<ImportNudgePopupDelegate> importNudgeDelegate;
-(void)showInParent;
-(void)dismiss;
@end
