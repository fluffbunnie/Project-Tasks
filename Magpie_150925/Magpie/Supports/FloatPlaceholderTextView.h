//
//  FloatPlaceholderTextView.h
//  GuidedCommunication
//
//  Created by Quynh Cao on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatPlaceholderTextView : UITextView

//for the placeholder, it is recommend to have it all in 1 line
-(id)initWithPlaceHolder:(NSString *)placeholder andFrame:(CGRect)frame;
-(NSString *)getText;

@end
