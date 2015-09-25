//
//  ChatMessages.m
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ChatMessages.h"
#import "JSQMessage.h"
#import "UserManager.h"
#import "MessageObj.h"
#import "UserManager.h"

static NSString * const ICE_BREAKER_MESSAGE = @"Hey %@, wanna stay at %@’s place? Get to know him/her with our Suggested Questions in the lightbulb icon.";
static NSString * const SUGGEST_QUESTION_CALL_TO_ACTION = @"If you don't know what to tell %@, try click the Suggested Questions to get some ideas.";

static NSString * const USER_INITIATE_BOOKING_REQUEST = @"Your request has been sent. Click here to review it.";
static NSString * const USER_RECEIVE_BOOKING_REQUEST = @"%@ thinks your pad is awesome and has requested a stay. Check out the request.";

static NSString * const USER_INITIATE_APPROVE_BOOKING_REQUEST = @"Woohoo! You have approved %@'s stay request. Check out the details under your Upcoming Trips.";
static NSString * const USER_RECEIVE_APPROVE_BOOKING_REQUEST = @"Woohoo! %@ has approved your stay request. Check out the details under your Upcoming Trips.";

static NSString * const USER_INITIATE_CANCEL_BOOKING_REQUEST = @"You have canceled your stay request at %@'s place";
static NSString * const USER_RECEIVE_CANCEL_BOOKING_REQUEST = @"%@ has canceled the stay request at your place";

@interface ChatMessages()
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) PFObject *userObj;
@property (nonatomic, strong) PFObject *recipientUserObj;
@property (nonatomic, strong) PFObject *conversationObj;
@end

@implementation ChatMessages

#pragma mark - public method
-(id)init {
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
        self.startDate = [[NSDate alloc] init];
        self.hasMoreMessages = NO;
    }
    return self;
}

/**
 * Set the user(sender) obj and the recipient objects
 * @param PFObject
 * @param PFObject
 */
-(void)setUserObj:(PFObject *)userObj andRecipientObj:(PFObject *)targetUserObj {
    self.userObj = userObj;
    self.recipientUserObj = targetUserObj;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:self.userObj];
    [query1 whereKey:@"user2" equalTo:self.recipientUserObj];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user1" equalTo:self.recipientUserObj];
    [query2 whereKey:@"user2" equalTo:self.userObj];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query includeKey:@"user2Property"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            self.conversationObj = objects[0];
            [self.messagesDelegate conversationCreatedWithConversationObj:self.conversationObj];
            self.hasMoreMessages = YES;
            [self getNextSetOfMessages];
        } else {
            [self addIceBreakerMessage];
            [self.messagesDelegate messagesReloaded];
        }
    }];
}

/**
 * Set the conversation object
 * @param PFObject
 */
-(void)setCurrentConversationObj:(PFObject *)conversationObj {
    self.conversationObj = conversationObj;
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        PFObject *user1 = conversationObj[@"user1"];
        PFObject *user2 = conversationObj[@"user2"];
        if ([user1.objectId isEqual:userObj.objectId]) {
            self.userObj = user1;
            self.recipientUserObj = user2;
        } else {
            self.userObj = user2;
            self.recipientUserObj = user1;
        }
        
        self.hasMoreMessages = YES;
        [self getNextSetOfMessages];
    }];
}

/**
 * Get the next set of messages in the list
 */
-(void)getNextSetOfMessages {
    if (self.hasMoreMessages) {
        PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
        [query whereKey:@"conversation" equalTo:self.conversationObj];
        [query includeKey:@"sender"];
        [query includeKey:@"receiver"];
        [query whereKey:@"createdAt" lessThan:self.startDate];
        [query orderByDescending:@"createdAt"];
        [query setLimit:NUM_MESSAGES_PER_LOAD];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                self.startDate = ((PFObject *)[objects lastObject]).createdAt;
                for (int i = 0; i < objects.count; i++) {
                    [self.messages insertObject:[self getMessageObjFromPFObject:objects[i]] atIndex:0];
                }
            }
            
            if (objects.count < NUM_MESSAGES_PER_LOAD) {
                [self addIceBreakerMessage];
                self.hasMoreMessages = NO;
            }
            
            [self.messagesDelegate messagesReloaded];
        }];
    }
}

/**
 * Sent message with a text and type
 * @param NSString
 * @param NSString
 */
-(void)sendMessageWithText:(NSString *)text andType:(NSString *)type {
    void (^sendMessage)() = ^{
        PFObject *newMessage = [PFObject objectWithClassName:@"Chat"];
        newMessage[@"sender"] = self.userObj;
        newMessage[@"receiver"] = self.recipientUserObj;
        newMessage[@"content"] = text;
        newMessage[@"contentType"] = type;
        newMessage[@"conversation"] = self.conversationObj;
        
        [self.messages addObject:[self getMessageObjFromPFObject:newMessage]];
        [self.messagesDelegate messageSent];

        [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.conversationObj[@"snippet"] = newMessage;
            self.conversationObj[@"lastUpdate"] = newMessage.createdAt;
            [self.conversationObj saveInBackground];
        }];
    };
    
    if (self.conversationObj == nil) {
        self.conversationObj = [PFObject objectWithClassName:@"Conversation"];
        self.conversationObj[@"user1"] = self.userObj;
        self.conversationObj[@"user2"] = self.recipientUserObj;
        self.conversationObj[@"user2Property"] = self.targetPlaceObj;
        
        [self.conversationObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            sendMessage();
            [[UserManager sharedUserManager] incrementConversations];
            [self.messagesDelegate conversationCreatedWithConversationObj:self.conversationObj];
            self.recipientUserObj[@"numConversations"] = [NSNumber numberWithInteger:[self.recipientUserObj[@"numConversations"] integerValue] + 1];
            [self.recipientUserObj saveInBackground];
        }];
    } else sendMessage();
}

/**
 * Update the message list when user received a message
 * @param NSString
 * @param NSString
 */
-(void)receiveMessageWithText:(NSString *)text andType:(NSString *)type {
    BOOL isPiloSpeaking = ![type isEqualToString:MESSAGE_TYPE_TEXT];
    MessageObj *newMessage = [[MessageObj alloc] initWithSenderId:self.recipientUserObj.objectId
                       senderDisplayName:self.recipientUserObj.objectId
                                    date:[[NSDate alloc] init]
                                    text:text
                              isFromPilo:isPiloSpeaking];
    
    if (isPiloSpeaking) {
        newMessage.messageType = type;
        newMessage.tripObjId = text;
        newMessage.isFromUser = NO;
        if ([type isEqualToString:MESSAGE_TYPE_BOOK]) {
            newMessage.text = [NSString stringWithFormat:USER_RECEIVE_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:newMessage.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
            NSRange boldRange = [newMessage.text rangeOfString:@"Check out"];
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                   range:boldRange];
            newMessage.attributedText = attributedText;
        } else if ([type isEqualToString:MESSAGE_TYPE_CANCEL]) {
            newMessage.text = [NSString stringWithFormat:USER_RECEIVE_CANCEL_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:newMessage.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
            newMessage.attributedText = attributedText;
        } else if ([type isEqualToString:MESSAGE_TYPE_CONFIRM]) {
            newMessage.text = [NSString stringWithFormat:USER_RECEIVE_APPROVE_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:newMessage.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
            NSRange boldRange = [newMessage.text rangeOfString:@"Check out"];
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                   range:boldRange];
            newMessage.attributedText = attributedText;
        }
    }
    
    [self.messages addObject:newMessage];
    [self.messagesDelegate messageReceived];
}

/**
 * Update the time that user has last seen the message
 */
-(void)updateUserLastSeen {
    if (self.conversationObj != nil) {
        NSDate *date = [[NSDate alloc] init];
        PFObject *user1 = self.conversationObj[@"user1"];
        if ([user1.objectId isEqual:self.userObj.objectId]) self.conversationObj[@"user1LastSeen"] = date;
        else self.conversationObj[@"user2LastSeen"] = date;
        [self.conversationObj saveInBackground];
    }
}

#pragma mark - private methods
/**
 * Convert a PFObject to a MessageObj
 * @param PFObject
 * @return MessageObj
 */
-(MessageObj *)getMessageObjFromPFObject:(PFObject *)chatObj {
    PFObject *sender = chatObj[@"sender"];
    
    NSDate *date = chatObj.createdAt ? chatObj.createdAt : [[NSDate alloc] init];
    NSString *content = chatObj[@"content"];
    NSString *contentType = chatObj[@"contentType"];
    BOOL isPiloSpeaking = ![contentType isEqualToString:MESSAGE_TYPE_TEXT];
    
    MessageObj *messageObj = [[MessageObj alloc] initWithSenderId:sender.objectId
                                                senderDisplayName:sender.objectId
                                                             date:date
                                                             text:content
                                                       isFromPilo:isPiloSpeaking];
    
    if (isPiloSpeaking) {
        messageObj.messageType = contentType;
        messageObj.senderId = self.recipientUserObj.objectId;
        messageObj.tripObjId = content;
        
        if ([sender.objectId isEqualToString:self.userObj.objectId]) {
            messageObj.isFromUser = YES;
            if ([contentType isEqualToString:MESSAGE_TYPE_BOOK]) {
                //when the user book a request
                messageObj.text = USER_INITIATE_BOOKING_REQUEST;
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                NSRange boldRange = [messageObj.text rangeOfString:@"Click here"];
                [attributedText addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                       range:boldRange];
                messageObj.attributedText = attributedText;
            } else if ([contentType isEqualToString:MESSAGE_TYPE_CANCEL]) {
                //when user canceled the request
                messageObj.text = [NSString stringWithFormat:USER_INITIATE_CANCEL_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                messageObj.attributedText = attributedText;
            } else if ([contentType isEqualToString:MESSAGE_TYPE_CONFIRM]) {
                //when you confirm the request
                messageObj.text = [NSString stringWithFormat:USER_INITIATE_APPROVE_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                NSRange boldRange = [messageObj.text rangeOfString:@"Check out"];
                [attributedText addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                       range:boldRange];
                messageObj.attributedText = attributedText;
            }
        } else {
            messageObj.isFromUser = NO;
            if ([contentType isEqualToString:MESSAGE_TYPE_BOOK]) {
                messageObj.text = [NSString stringWithFormat:USER_RECEIVE_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                NSRange boldRange = [messageObj.text rangeOfString:@"Check out"];
                [attributedText addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                       range:boldRange];
                messageObj.attributedText = attributedText;
            } else if ([contentType isEqualToString:MESSAGE_TYPE_CANCEL]) {
                messageObj.text = [NSString stringWithFormat:USER_RECEIVE_CANCEL_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                messageObj.attributedText = attributedText;
            } else if ([contentType isEqualToString:MESSAGE_TYPE_CONFIRM]) {
                messageObj.text = [NSString stringWithFormat:USER_RECEIVE_APPROVE_BOOKING_REQUEST, [UserManager getUserNameFromUserObj:self.recipientUserObj]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:messageObj.text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]}];
                NSRange boldRange = [messageObj.text rangeOfString:@"Check out"];
                [attributedText addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]
                                       range:boldRange];
                messageObj.attributedText = attributedText;
            }
        }
    }
    
    return messageObj;
}


/**
 * Add the ice breaker message to the begining of the conversation
 */
-(void)addIceBreakerMessage {
    NSString *iceBreaker = [[NSString alloc] initWithFormat:ICE_BREAKER_MESSAGE,
                            [UserManager getUserNameFromUserObj:self.userObj],
                            [UserManager getUserNameFromUserObj:self.recipientUserObj]];
    
    MessageObj *message = [[MessageObj alloc] initWithSenderId:self.recipientUserObj.objectId
                                             senderDisplayName:self.recipientUserObj.objectId
                                                          date:self.startDate
                                                          text:iceBreaker
                                                    isFromPilo:YES];
    [self.messages insertObject:message atIndex:0];
}

@end
