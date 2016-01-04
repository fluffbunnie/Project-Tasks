//
//  ValuePropViewController.h
//  Magpie
//
//  Created by kakalot on 5/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    None,
    Running,
    Done,
} AnimationStausType;

@protocol HowItWorkViewDelegate <NSObject>
@optional
-(void) gotoNextPage;
-(void) closeHowItWorks;
@end

@interface HowItWorksViewController : UIViewController <UIScrollViewDelegate, HowItWorkViewDelegate>
@property (nonatomic, strong) UIImage *capturedBackground;
@end
