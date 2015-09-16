//
//  ChatViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ChatViewController.h"
#import "JSQSystemSoundPlayer+JSQMessages.h"
#import "JSQMessage.h"
#import "JSQMessages.h"
#import "FontColor.h"
#import "SDWebImageManager.h"
#import "ImageUrl.h"
#import "GuidedQuestionsViewController.h"
#import "TWMessageBarManager.h"
#import "SuggestedQuestionHintView.h"
#import "UserManager.h"
#import "MessageObj.h"
#import "AppDelegate.h"
#import "MyMessageViewController.h"
#import "HomePageViewController.h"
#import "TripDetailViewController.h"
#import "PropertyDetailViewController.h"
#import "LoadingView.h"
#import "ParseConstant.h"
#import "ToastView.h"
#import "MyUpcomingTripViewController.h"
#import "MyPlaceListViewController.h"
#import "Device.h"
#import "Mixpanel.h"


static const float AVATAR_SIZE = 30.0f;
static NSString * AVATAR_DEFAULT_IMAGE_NAME = @"NoProfileImage";
static NSString * AVATAR_MAGPIE = @"MagpieIconWithPadding";

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * LOADING_VIEW_TEXT = @"Please wait";

static time_t TIME_GAP = 60 * 60; //1hr

@interface ChatViewController ()
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) GuestPopup *guestPopup;
@property (nonatomic, strong) HostPopup *hostPopup;

@property (nonatomic, strong) SuggestedQuestionHintView *suggestedQuestionsToolTipView;
@property (nonatomic, strong) ChatMessages *chatMessages;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIBarButtonItem *checkoutButton;
@property (nonatomic, strong) JSQMessagesAvatarImage *recipientAvatar;
@property (nonatomic, strong) JSQMessagesAvatarImage *magpieAvatar;

@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubblePast;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubble;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubblePiloPast;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubblePilo;

@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubblePast;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubblePiloPast;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubblePilo;

@end

@implementation ChatViewController
#pragma mark - initiation
/**
 * Lazily init the loading view
 * @return LoadingView
 */
-(LoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[LoadingView alloc] initWithMessage:LOADING_VIEW_TEXT];
    }
    return _loadingView;
}

/**
 * Lazily init the guest popup
 * @return GuestPopup
 */
-(GuestPopup *)guestPopup {
    if (_guestPopup == nil) {
        _guestPopup = [[GuestPopup alloc] init];
        _guestPopup.guestPopupDelegate = self;
    }
    return _guestPopup;
}

/**
 * Lazily init the host popup
 * @return HostPopup
 */
-(HostPopup *)hostPopup {
    if (_hostPopup == nil) {
        _hostPopup = [[HostPopup alloc] init];
        _hostPopup.hostPopupDelegate = self;
    }
    return _hostPopup;
}

/**
 * Lazily init the suggested question's tool tip view
 * @return SuggestedQuestionHintView
 */
-(SuggestedQuestionHintView *)suggestedQuestionsToolTipView {
    if (_suggestedQuestionsToolTipView == nil) {
        _suggestedQuestionsToolTipView = [[SuggestedQuestionHintView alloc] initWithXCoordinate:4 andYCoordinate:self.screenHeight - 80];
    }
    return _suggestedQuestionsToolTipView;
}

/**
 * Lazily init the chat messages object
 * @return ChatMessages
 */
-(ChatMessages *)chatMessages {
    if (_chatMessages == nil) {
        _chatMessages = [[ChatMessages alloc] init];
        _chatMessages.messagesDelegate = self;
    }
    return _chatMessages;
}

/**
 * Lazily init the back button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goBack)];
    }
    return _backButton;
}

/**
 * Lazily init the title button text
 * @return UIButton
 */
-(UIButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        [_titleButton setTitleColor:[FontColor appTitleColor] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(goToUserPlace) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

/**
 * Lazily init the booking button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)checkoutButton {
    if (_checkoutButton == nil) {
        UIButton * checkoutBt = [[UIButton alloc] init];
        checkoutBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [checkoutBt setTitle:@"Book" forState:UIControlStateNormal];
        [checkoutBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [checkoutBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [checkoutBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [checkoutBt sizeToFit];
        [checkoutBt addTarget:self action:@selector(goToCheckout) forControlEvents:UIControlEventTouchUpInside];
        
        _checkoutButton = [[UIBarButtonItem alloc] initWithCustomView:checkoutBt];
    }
    return _checkoutButton;
}

/**
 * Lazily init the past outgoing bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)outgoingBubblePast {
    if (_outgoingBubblePast == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initTailless];
        _outgoingBubblePast = [bubbleFactory outgoingMessagesBubbleImageWithColor:[FontColor messageOutgoingBackgroundColor]];
    }
    return _outgoingBubblePast;
}

/**
 * Lazily init the outgoing bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)outgoingBubble {
    if (_outgoingBubble == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _outgoingBubble = [bubbleFactory outgoingMessagesBubbleImageWithColor:[FontColor messageOutgoingBackgroundColor]];
    }
    return _outgoingBubble;
}

/**
 * Lazily init the outgoing bubble image data for pilo's past
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)outgoingBubblePiloPast {
    if (_outgoingBubblePiloPast == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initTailless];
        _outgoingBubblePiloPast = [bubbleFactory outgoingMessagesBubbleImageWithColor:[FontColor themeColor]];
    }
    return _outgoingBubblePiloPast;
}

/**
 * Lazily init the outgoing bubble image data for pilo
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)outgoingBubblePilo {
    if (_outgoingBubblePilo == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _outgoingBubblePilo = [bubbleFactory outgoingMessagesBubbleImageWithColor:[FontColor themeColor]];
    }
    return _outgoingBubblePilo;
}

/**
 * Lazily init the past incoming bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)incomingBubblePast {
    if (_incomingBubblePast == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initTailless];
        _incomingBubblePast = [bubbleFactory incomingMessagesBubbleImageWithColor:[FontColor messageIncomingBackgroundColor]];
    }
    return _incomingBubblePast;
}

/**
 * Lazily init the incoming bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)incomingBubble {
    if (_incomingBubble == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _incomingBubble = [bubbleFactory incomingMessagesBubbleImageWithColor:[FontColor messageIncomingBackgroundColor]];
    }
    return _incomingBubble;
}

/**
 * Lazily init the pilo's past incoming bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)incomingBubblePiloPast {
    if (_incomingBubblePiloPast == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initTailless];
        _incomingBubblePiloPast = [bubbleFactory incomingMessagesBubbleImageWithColor:[FontColor themeColor]];
    }
    return _incomingBubblePiloPast;
}


/**
 * Lazily init the pilo incoming bubble image data
 * @return JSQMessagesBubbleImage
 */
-(JSQMessagesBubbleImage *)incomingBubblePilo {
    if (_incomingBubblePilo == nil) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _incomingBubblePilo = [bubbleFactory incomingMessagesBubbleImageWithColor:[FontColor themeColor]];
    }
    return _incomingBubblePilo;
}

#pragma mark - initialize before view did load
/**
 * Load messages meta data, mandatory for JSQMessage
 */
-(void)loadMessagesMetaData {
    self.senderId = self.userObj.objectId;
    self.senderDisplayName = self.userObj.objectId;
    
    //init the message array
    if (self.conversationObj != nil) {
        PFObject *user1 = self.conversationObj[@"user1"];
        if ([user1.objectId isEqual:self.userObj.objectId]) {
            self.targetUserObj = self.conversationObj[@"user2"];
            self.targetPropertyObj = self.conversationObj[@"user2Property"];
        } else self.targetUserObj = self.conversationObj[@"user1"];
        [[self chatMessages] setCurrentConversationObj:self.conversationObj];
    } else {
        [self chatMessages].targetPlaceObj = self.targetPropertyObj;
        [[self chatMessages] setUserObj:self.userObj andRecipientObj:self.targetUserObj];
    }
    
    //init the avatar
    self.magpieAvatar = [JSQMessagesAvatarImage avatarWithImage:[UIImage imageNamed:AVATAR_MAGPIE]];
    self.recipientAvatar = [JSQMessagesAvatarImage avatarWithImage:[UIImage imageNamed:AVATAR_DEFAULT_IMAGE_NAME]];
    if (self.targetUserObj[@"profilePic"]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *profilePicUrl = [NSURL URLWithString:[ImageUrl inboxProfileImageUrlFromUrl:self.targetUserObj[@"profilePic"]]];
        [manager downloadImageWithURL:profilePicUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!error && image != nil) self.recipientAvatar = [JSQMessagesAvatarImage avatarWithImage:image];
        }];
    }
    
    //format the rest of view
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(AVATAR_SIZE, AVATAR_SIZE);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
}

/**
 * Init the other's view components when the view load
 */
-(void)loadInitialView {
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    self.navigationItem.titleView = [self titleButton];
    [self.titleButton setTitle:[UserManager getUserNameFromUserObj:self.targetUserObj] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self checkoutButton];

    //TODO add a loading view in here
    [self.view addSubview:[self suggestedQuestionsToolTipView]];
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMessagesMetaData];
    [self loadInitialView];
    
    self.view.userInteractionEnabled = NO;
    self.showLoadEarlierMessagesHeader = NO;
    self.keyboardController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).currentChattingRecipient = self.targetUserObj.objectId;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.suggestedQuestions.length > 0){
        [self.inputToolbar.contentView.textView setText:[NSString stringWithFormat:@"%@%@", self.inputToolbar.contentView.textView.text, self.suggestedQuestions]];
        self.suggestedQuestions = nil;
        [self.inputToolbar.contentView.rightBarButtonItem setEnabled:YES];
    }
    
    [self performSelector:@selector(showTripPopup) withObject:nil afterDelay:0.5];
}

-(void)showTripPopup {
    if (self.tripObj != nil) {
        PFObject *guestObj = self.tripObj[@"guest"];
        if ([self.userObj.objectId isEqualToString:guestObj.objectId]) {
            [[self guestPopup] showInView:self.windowView];
            [self.guestPopup setNewTripObj:self.tripObj];
        } else {
            [[self hostPopup] showInView:self.windowView];
            [self.hostPopup setNewTripObj:self.tripObj];
        }
        
        self.tripObj = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.chatMessages updateUserLastSeen];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).currentChattingRecipient = nil;
}

/**
 * add a new message when received from push notification
 * @param NSString
 * @param NSString
 */
-(void)receiveMessageWithContent:(NSString *)message andContentType:(NSString *)contentType {
    [self.chatMessages receiveMessageWithText:message andType:contentType];
}

/**
 * Book a trip with the given set of information
 * @param NSString
 * @param NSString
 * @param int
 * @param place
 */
-(void)bookTripWithWithStartDate:(NSString *)startDate endDate:(NSString *)endDate numberOfGuests:(int)numGuests andPlace:(PFObject *)propertyObj {
    [[self loadingView] showInView:self.windowView];
    PFObject *tripObj = [PFObject objectWithClassName:@"Trip"];
    tripObj[@"guest"] = self.userObj;
    tripObj[@"host"] = self.targetUserObj;
    tripObj[@"place"] = propertyObj;
    tripObj[@"startDate"] = startDate;
    tripObj[@"endDate"] = endDate;
    tripObj[@"numGuests"] = @(numGuests);
    tripObj[@"approval"] = @"NO";
    
    [tripObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.loadingView dismiss];
        if (!error && succeeded) [self.chatMessages sendMessageWithText:tripObj.objectId andType:MESSAGE_TYPE_BOOK];
        else [ToastView showToastInParentView:self.windowView withText:@"Fail to send the staying request. Please try again." withDuaration:3];
    }];
}

#pragma mark - popup delegate
/**
 * Host popup delegate
 * Delegate for host to say that the he/she has approved the trip
 * @param TripObj
 */
-(void)hostApprovedTripObj:(PFObject *)tripObj {
    tripObj[@"approval"] = @"YES";
    [tripObj saveInBackground];
    [self.chatMessages sendMessageWithText:tripObj.objectId andType:MESSAGE_TYPE_CONFIRM];
}

/**
 * Guest popup delegate
 * Delegate for guest to say that he/she canceled the trip
 * @param TripObj
 */
-(void)cancelTripObj:(PFObject *)tripObj {
    [[Mixpanel sharedInstance] track:@"Chat - Trip Cancel Click"];
    tripObj[@"approval"]= @"CANCEL";
    [tripObj saveInBackground];
    [self.chatMessages sendMessageWithText:tripObj.objectId andType:MESSAGE_TYPE_CANCEL];
}

/**
 * ImportNudgePopup delegate
 * Delegate for nudge popup to go back to my place screen
 */
-(void)goToMyPlace {
    [[Mixpanel sharedInstance] track:@"Message Floating - Your Place Click"];
    MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
    myPlaceListViewController.userObj = self.userObj;
    [self.navigationController pushViewController:myPlaceListViewController animated:YES];
}

/**
 * ImportNudgePopup delegate
 * Delegate for nudge popup to go back to prev screen
 */
-(void)goBackToPreviousScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - chat messages delegate
/**
 * ChatMessages Delegate
 * Reload the list of messages. 
 * If there are only 2 messages (ice breakers and call-to-action), then show the suggested question tool-tip
 */
-(void)messagesReloaded {
    self.view.userInteractionEnabled = YES;
    if (self.chatMessages.messages.count == 1) [self suggestedQuestionsToolTipView].hidden = NO;
    [self finishReceivingMessageAnimated:YES];
    self.showLoadEarlierMessagesHeader = self.chatMessages.hasMoreMessages;
}

/**
 * ChatMessages Delegate
 * Message sent.
 */
-(void)messageSent {
    [[Mixpanel sharedInstance] track:@"Chat - Message Sent"];
    [self finishSendingMessageAnimated:YES];
}

/**
 * ChatMessages delegate
 * Message received.
 */
-(void)messageReceived {
    [self finishReceivingMessageAnimated:YES];
}

/**
 * ChatMessages delegate
 * Conversation created
 */
-(void)conversationCreatedWithConversationObj:(PFObject *)conversationObj {
    self.conversationObj = conversationObj;
    PFObject *conversationUser1 = self.conversationObj[@"user1"];
    PFObject *conversationTargetPlace = self.conversationObj[@"user2Property"];
    if ([self.userObj.objectId isEqualToString:conversationUser1.objectId]) {
        self.targetPropertyObj = conversationTargetPlace ? conversationTargetPlace : nil;
    }
}

#pragma mark - message action
-(void)didPressAccessoryButton:(UIButton *)sender {
    [[Mixpanel sharedInstance] track:@"Chat - Suggested Question Click"];
    self.suggestedQuestionsToolTipView.hidden = YES;
    GuidedQuestionsViewController *guidedQuestionsViewController = [[GuidedQuestionsViewController alloc] init];
    guidedQuestionsViewController.chatController = self;
    [self.navigationController pushViewController:guidedQuestionsViewController animated:YES];
}

-(void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    self.inputToolbar.contentView.rightBarButtonItem.enabled = NO;
    [self.chatMessages sendMessageWithText:text andType:MESSAGE_TYPE_TEXT];
}

#pragma mark - JSQMessages CollectionView DataSource
// Messages item for the collection view
-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.chatMessages.messages[indexPath.row];
}

// Message bubble image
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    BOOL isOutgoing = [message.senderId isEqual:self.senderId];
    BOOL hasNextMessage = (indexPath.row + 1 < self.chatMessages.messages.count);
    
    if (!hasNextMessage) {
        if (isOutgoing) {
            if (message.isFromPilo) return [self outgoingBubblePilo];
            else return [self outgoingBubble];
        } else {
            if (message.isFromPilo) return [self incomingBubblePilo];
            else return [self incomingBubble];
        }
    } else {
        MessageObj *nextMessage = self.chatMessages.messages[indexPath.row + 1];
        BOOL nextMessageIsOutgoing = [nextMessage.senderId isEqual:self.senderId];
        
        if (isOutgoing != nextMessageIsOutgoing || message.isFromPilo != nextMessage.isFromPilo) {
            if (isOutgoing) {
                if (message.isFromPilo) return [self outgoingBubblePilo];
                else return [self outgoingBubble];
            } else {
                if (message.isFromPilo) return [self incomingBubblePilo];
                else return [self incomingBubble];
            }
        } else {
            if (isOutgoing) {
                if (message.isFromPilo) return [self outgoingBubblePiloPast];
                else return [self outgoingBubblePast];
            } else {
                if (message.isFromPilo) return [self incomingBubblePiloPast];
                else return [self incomingBubblePast];
            }
        }
    }
}

// Avatar image
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    BOOL isOutgoing = [message.senderId isEqual:self.senderId];
    BOOL hasNextMessage = (indexPath.row + 1 < self.chatMessages.messages.count);
    
    if (!isOutgoing) {
        if (!hasNextMessage) {
            if (message.isFromPilo) return self.magpieAvatar;
            else return self.recipientAvatar;
        } else {
            MessageObj *nextMessage = self.chatMessages.messages[indexPath.row + 1];
            BOOL nextMessageIsOutgoing = [nextMessage.senderId isEqual:self.senderId];
            if (nextMessageIsOutgoing) {
                if (message.isFromPilo) return self.magpieAvatar;
                else return self.recipientAvatar;
            } else {
                if (message.isFromPilo != nextMessage.isFromPilo) {
                    if (message.isFromPilo) return self.magpieAvatar;
                    else return self.recipientAvatar;
                }
            }
        }
    }
    return nil;
}

// Timestamp for every 3rd message
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    
    int firstMessageIndex = self.chatMessages.hasMoreMessages ? 0 : 1;
    if (indexPath.row < firstMessageIndex) return nil;
    else if (indexPath.row == firstMessageIndex) return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    else {
        MessageObj *prevMessage = self.chatMessages.messages[indexPath.row - 1];
        if ([message.date timeIntervalSince1970] - [prevMessage.date timeIntervalSince1970] > TIME_GAP) return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }

    return nil;
}

// the title label for the sender name. We don't want to display it
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// text for the bottom of the label
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.chatMessages.messages.count - 1) {
        MessageObj *message = self.chatMessages.messages[indexPath.row];
        if (!message.isFromPilo && message.senderId == self.userObj.objectId) {
            return  [[NSAttributedString alloc] initWithString:@"Delivered" attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:10.0]}];
        }
    }
    return nil;
}

#pragma mark - UICollectionView DataSource
// the number of message in the conversation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chatMessages.messages.count;
}

// collection view cell for
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    
    //Configure Text colors, label text, label colors, etc.
    if (message.isFromPilo && message.attributedText.length > 0) cell.textView.attributedText = message.attributedText;
    else if ([message.senderId isEqualToString:self.senderId] || message.isFromPilo) cell.textView.textColor = [UIColor whiteColor];
    else cell.textView.textColor = [FontColor titleColor];
    
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}

#pragma mark - Adjusting cell label heights
// height for the timestamp
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    int firstMessageIndex = self.chatMessages.hasMoreMessages ? 0 : 1;
    if (indexPath.row < firstMessageIndex) return 0;
    else if (indexPath.row == firstMessageIndex) return kJSQMessagesCollectionViewCellLabelHeightDefault;
    else {
        MessageObj *message = self.chatMessages.messages[indexPath.row];
        MessageObj *prevMessage = self.chatMessages.messages[indexPath.row - 1];
        if ([message.date timeIntervalSince1970] - [prevMessage.date timeIntervalSince1970] > TIME_GAP) return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

// height for sender name label
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

// height for the bottom label. we don't have nothing atm
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.chatMessages.messages.count - 1) {
        MessageObj *message = self.chatMessages.messages[indexPath.row];
        if (!message.isFromPilo && message.senderId == self.userObj.objectId) return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }

    return 0.0f;
}

#pragma mark - Responding to collection view tap events
- (void)collectionView:(JSQMessagesCollectionView *)collectionView header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    self.showLoadEarlierMessagesHeader = NO;
    [self.chatMessages getNextSetOfMessages];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    BOOL isOutgoing = [message.senderId isEqual:self.senderId];
    BOOL isFromMagpie = message.isFromPilo;
    if (!isOutgoing && !isFromMagpie) [self goToUserPlace];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    MessageObj *message = self.chatMessages.messages[indexPath.row];
    BOOL isFromMagpie = message.isFromPilo;
    if (isFromMagpie) {
        BOOL isFromUser = message.isFromUser;
        [self.inputToolbar.contentView.textView resignFirstResponder];
        if ([message.messageType isEqualToString:MESSAGE_TYPE_BOOK] || [message.messageType isEqualToString:MESSAGE_TYPE_CANCEL]) {
            PFQuery *tripQuery = [PFQuery queryWithClassName:@"Trip"];
            [tripQuery includeKey:@"guest"];
            [tripQuery includeKey:@"host"];
            [tripQuery includeKey:@"place"];
            if (isFromUser) {
                [[self guestPopup] showInView:self.windowView];
                [tripQuery getObjectInBackgroundWithId:message.tripObjId block:^(PFObject *object, NSError *error) {
                    if (!error && object != nil) [self.guestPopup setNewTripObj:object];
                    else [self.guestPopup dismiss];
                }];
            } else {
                [[self hostPopup] showInView:self.windowView];
                [tripQuery getObjectInBackgroundWithId:message.tripObjId block:^(PFObject *object, NSError *error) {
                    if (!error && object != nil) [self.hostPopup setNewTripObj:object];
                    else [self.hostPopup dismiss];
                }];
            }
        } else if ([message.messageType isEqualToString:MESSAGE_TYPE_CONFIRM]) {
            MyUpcomingTripViewController *myUpcomingTripViewController = [[MyUpcomingTripViewController alloc] init];
            [self.navigationController pushViewController:myUpcomingTripViewController animated:YES];
        }
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

#pragma mark - keyboard controller delegate
/**
 * When the keyboard change frame, we also need to check the behavior of accessory button
 */
- (void)keyboardController:(JSQMessagesKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
    self.suggestedQuestionsToolTipView.hidden = YES;
    
    if (![self.inputToolbar.contentView.textView isFirstResponder] &&
        self.toolbarBottomLayoutGuide.constant == 0.0f) return;
    
    CGFloat heightFromBottom = CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(keyboardFrame);
    
    heightFromBottom = MAX(0.0f, heightFromBottom);
    [self jsq_setToolbarBottomLayoutGuideConstant:heightFromBottom];
}

/**
 * Handle the behavior when the keyboard show
 */
-(void)keyboardDidHide {
    //do nothing for now
}

/**
 * Handle the behavior when the keyboard did show
 */
-(void)keyboardDidShow {
    //do nothing for now
}


#pragma mark - UIAction
/**
 * Go back to the prev screen. If there is no screen to go back, then go back to
 * the list of messages
 */
-(void)goBack {
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    if (currentViewControllerIndex == 0) {
        HomePageViewController *homeViewController = [[HomePageViewController alloc] init];
        MyMessageViewController *messageViewController = [[MyMessageViewController alloc] init];
        NSArray *newControllers = [NSArray arrayWithObjects:homeViewController, messageViewController, self, nil];
        self.navigationController.viewControllers = newControllers;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Go the check out screen
 */
-(void)goToCheckout {
    [[Mixpanel sharedInstance] track:@"Chat - Let's Exchange Click"];
    
    [self.inputToolbar.contentView.textView resignFirstResponder];
    TripDetailViewController *tripDetailViewController = [[TripDetailViewController alloc] init];
    tripDetailViewController.senderObj = self.userObj;
    tripDetailViewController.receiverObj = self.targetUserObj;
    tripDetailViewController.propertyObj = self.targetPropertyObj;
    [self.navigationController pushViewController:tripDetailViewController animated:YES];
}

/**
 * Go to user's place when tapped on the targeted user name, or his/her avatar
 */
-(void)goToUserPlace {
    [[Mixpanel sharedInstance] track:@"Chat - Detailed Page Screen"];
    if (self.conversationObj != nil) {
        PFObject *conversationUser1 = self.conversationObj[@"user1"];
        PFObject *conversationTargetPlace = self.conversationObj[@"user2Property"];
        if ([conversationUser1.objectId isEqualToString:self.userObj.objectId]) {
            PropertyDetailViewController *detailViewController = [[PropertyDetailViewController alloc] init];
            detailViewController.capturedBackground = [Device captureScreenshot];
            detailViewController.propertyObj = conversationTargetPlace;
            [self.navigationController pushViewController:detailViewController animated:NO];
        } else {
            [[self loadingView] showInView:self.windowView];
            PFQuery *propertyQuery = [PFQuery queryWithClassName:@"Property"];
            [propertyQuery whereKey:@"owner" equalTo:conversationUser1];
            [propertyQuery includeKey:@"owner"];
            [propertyQuery includeKey:@"amenity"];
            [propertyQuery orderByAscending:@"state"];
            [propertyQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [self.loadingView dismiss];
                if (!error && object != nil) {
                    PropertyDetailViewController *detailViewController = [[PropertyDetailViewController alloc] init];
                    detailViewController.propertyObj = object;
                    detailViewController.capturedBackground = [Device captureScreenshot];
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
            }];
        }
    } else if (self.targetPropertyObj != nil){
        PropertyDetailViewController *detailViewController = [[PropertyDetailViewController alloc] init];
        detailViewController.capturedBackground = [Device captureScreenshot];
        detailViewController.propertyObj = self.targetPropertyObj;
        [self.navigationController pushViewController:detailViewController animated:NO];
    }
}

@end
