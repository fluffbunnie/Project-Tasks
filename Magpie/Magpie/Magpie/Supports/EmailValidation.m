//
//  EmailValidation.m
//  Magpie
//
//  Created by minh thao nguyen on 5/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "EmailValidation.h"

@implementation EmailValidation
/**
 * Check if a email is valid
 * @param email
 * @return valid
 */
+(BOOL)validateEmail:(NSString *)emailStr {
    if (emailStr.length == 0) return NO;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
@end
