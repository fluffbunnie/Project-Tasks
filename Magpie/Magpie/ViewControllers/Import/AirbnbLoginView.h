//
//  AirbnbLoginView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AirbnbLoginViewDelegate <NSObject>
-(void)fetchedUid:(NSString *)uid;
-(void)showPhotoRequireMessage;
@end

@interface AirbnbLoginView : UIView <UIWebViewDelegate>
@property (nonatomic, weak) id<AirbnbLoginViewDelegate> webDelegate;
-(void)showView;
-(void)keyboardWillShow;
-(void)keyboardWillHide;
@end
