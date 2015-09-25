//
//  ParsingText.m
//  Magpie
//
//  Created by minh thao nguyen on 5/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ParsingText.h"

@implementation ParsingText
+(NSString *)getTrimmedPhotoDescriptionFromDescription:(NSString *)description {
    if (![description isEqual:[NSNull null]] && description.length > 0 ) {
        NSUInteger spaceCharIndex = [description rangeOfString:@" "].location;
        if (spaceCharIndex != NSNotFound) {
            NSString *firstWord = [description substringToIndex:spaceCharIndex];
            NSString *pageNumberRegex = @"[0-9]{1,3}/[0-9]{1,3}:";
            NSPredicate *pageNumberText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pageNumberRegex];
            if ([pageNumberText evaluateWithObject:firstWord]) return [description substringFromIndex:spaceCharIndex + 1];
            else return description;
        } else return description;
    }
    return @"";
}
@end
