//
//  ChatMessages.h
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString * const MESSAGE_TYPE_TEXT = @"text";
static NSString * const MESSAGE_TYPE_BOOK = @"book";
static NSString * const MESSAGE_TYPE_CONFIRM = @"confirm";
static NSString * const MESSAGE_TYPE_CANCEL = @"cancel";

static NSInteger const NUM_MESSAGES_PER_LOAD = 50;

@protocol ChatMessagesDelegate <NSObject>
@optional
-(void)messagesReloaded;
-(void)messageSent;
-(void)messageReceived;
-(void)conversationCreatedWithConversationObj:(PFObject *)conversationObj;
@end

@interface ChatMessages : NSObject
@property (nonatomic, weak) id<ChatMessagesDelegate> messagesDelegate;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, assign) BOOL hasMoreMessages; //this is to display
@property (nonatomic, strong) PFObject *targetPlaceObj;

-(void)getNextSetOfMessages;
-(void)setUserObj:(PFObject *)userObj andRecipientObj:(PFObject *)targetUserObj;
-(void)setCurrentConversationObj:(PFObject *)conversationObj;
-(void)sendMessageWithText:(NSString *)text andType:(NSString *)type;

-(void)receiveMessageWithText:(NSString *)text andType:(NSString *)type;
-(void)updateUserLastSeen;
@end
