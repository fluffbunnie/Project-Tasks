//
//  MessageObj.m
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MessageObj.h"

@implementation MessageObj
-(id)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text isFromPilo:(BOOL)fromPilo {
    self = [super initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    if (self) {
        self.isFromPilo = fromPilo;
    }
    return self;
}
@end
