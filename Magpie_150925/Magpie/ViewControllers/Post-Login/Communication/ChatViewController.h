//
//  ChatViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import <Parse/Parse.h>
#import "ChatMessages.h"

@interface ChatViewController : JSQMessagesViewController <JSQMessagesKeyboardControllerDelegate, ChatMessagesDelegate>

@property (nonatomic, strong) PFObject *userObj;
@property (nonatomic, strong) PFObject *targetUserObj;
@property (nonatomic, strong) PFObject *targetPropertyObj;
@property (nonatomic, strong) PFObject *conversationObj;
@property (nonatomic, strong) PFObject *tripObj;

@property (nonatomic, strong) NSString *suggestedQuestions;

-(void)receiveMessageWithContent:(NSString *)message andContentType:(NSString *)contentType;
-(void)bookTripWithWithStartDate:(NSString *)startDate endDate:(NSString *)endDate numberOfGuests:(int)numGuests reason:(NSString *)reason andPlace:(PFObject *)propertyObj;
-(void)sendMessage:(NSString *)message withType:(NSString *)type;
@end
