//
//  EmailValidation.h
//  Magpie
//
//  Created by minh thao nguyen on 5/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailValidation : NSObject
+(BOOL)validateEmail:(NSString *)emailStr;
@end
