//
//  MessageObj.h
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "JSQMessage.h"

@interface MessageObj : JSQMessage
@property (nonatomic, assign) BOOL isFromPilo;
@property (nonatomic, assign) BOOL isFromUser;
@property (nonatomic, strong) NSString *tripObjId;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSAttributedString *attributedText;
-(id)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text isFromPilo:(BOOL)fromPilo;
@end
