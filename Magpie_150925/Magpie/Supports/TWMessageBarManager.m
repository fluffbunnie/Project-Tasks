//
//  TWMessageBarManager.m
//
//  Created by Terry Worona on 5/13/13.
//  Copyright (c) 2013 Terry Worona. All rights reserved.
//

#import "TWMessageBarManager.h"
#import <QuartzCore/QuartzCore.h>

// Numerics (TWMessageBarManager)
CGFloat const kTWMessageBarManagerDismissAnimationDuration = 0.25f;

#pragma mark - message window
@interface TWMessageWindow : UIWindow
@end
@implementation TWMessageWindow
#pragma mark - Touches
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if ([hitView isEqual: self.rootViewController.view]) hitView = nil;
    return hitView;
}
@end

@interface TWMessageBarManager ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) UIViewController *notifViewController;
@property (nonatomic, strong) TWMessageWindow *messageWindow;
@property (nonatomic, strong) UIView *messageWindowView;

@property (nonatomic, strong) NSMutableArray *messageBarQueue;
@property (nonatomic, assign, getter=isMessageVisible) BOOL messageVisible;

@end

@implementation TWMessageBarManager

#pragma mark - initiation
/**
 * Lazily init the notif view controller
 * @return UIViewController 
 */
-(UIViewController *)notifViewController {
    if (_notifViewController == nil) _notifViewController = [[UIViewController alloc] init];
    return _notifViewController;
}

/**
 * Lazily init the message window
 * @return TWMessageWindow 
 */
-(TWMessageWindow *)messageWindow {
    if (_messageWindow == nil) {
        _messageWindow = [[TWMessageWindow alloc] init];
        _messageWindow.frame = [UIApplication sharedApplication].keyWindow.frame;
        _messageWindow.hidden = NO;
        _messageWindow.windowLevel = UIWindowLevelNormal;
        _messageWindow.backgroundColor = [UIColor clearColor];
        _messageWindow.rootViewController = [self notifViewController];
    }
    return _messageWindow;
}

/**
 * Lazily init the message window view
 * @return UIView
 */
-(UIView *)messageWindowView {
    if (_messageWindowView == nil) {
        [self messageWindow];
        _messageWindowView = [self notifViewController].view;
    }
    return _messageWindowView;
}

#pragma mark - instantiate
+ (TWMessageBarManager *)sharedInstance {
    static dispatch_once_t pred;
    static TWMessageBarManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
	return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.messageBarQueue = [[NSMutableArray alloc] init];
        self.messageVisible = NO;
    }
    return self;
}

/**
 * Show a message with a title, description, icon, duration, and callback
 * @param NSString
 * @param NSString
 * @param UIImage
 * @param CGFloat
 * @param Call back
 */
-(void)showMessageWithTitle:(NSString *)title description:(NSString *)description icon:(UIImage *)iconImage duration:(CGFloat)duration callback:(void(^)())callback {
    TWMessageView *messageView = [[TWMessageView alloc] init];
    messageView.callbacks = callback ? [NSArray arrayWithObject:callback] : [NSArray array];
    messageView.hasCallback = callback ? YES : NO;
    messageView.duration = duration;
    messageView.hidden = YES;
    
    [messageView setTitle:title];
    [messageView setDescription:description];
    [messageView setImageAvatar:iconImage];
    
    [[self messageWindowView] addSubview:messageView];
    [[self messageWindowView] bringSubviewToFront:messageView];
    [self.messageBarQueue addObject:messageView];
    if (!self.messageVisible) [self showNextMessage];
}

/**
 * Show a message with a title, description, icon, duration, and callback
 * @param NSString
 * @param NSString
 * @param NSString
 * @param CGFloat
 * @param Call back
 */
-(void)showMessageWithTitle:(NSString *)title description:(NSString *)description iconUrl:(NSString *)iconUrl duration:(CGFloat)duration callback:(void(^)())callback {
    TWMessageView *messageView = [[TWMessageView alloc] init];
    messageView.callbacks = callback ? [NSArray arrayWithObject:callback] : [NSArray array];
    messageView.hasCallback = callback ? YES : NO;
    messageView.duration = duration;
    messageView.hidden = YES;
    
    [messageView setTitle:title];
    [messageView setDescription:description];
    [messageView setImageUrl:iconUrl];
    
    [[self messageWindowView] addSubview:messageView];
    [[self messageWindowView] bringSubviewToFront:messageView];
    [self.messageBarQueue addObject:messageView];
    if (!self.messageVisible) [self showNextMessage];
}

/**
 * Hide all the messages with animation
 * @param BOOL
 */
- (void)hideAllAnimated:(BOOL)animated {
    for (UIView *subview in [[self messageWindowView] subviews]) {
        if ([subview isKindOfClass:[TWMessageView class]]) {
            TWMessageView *currentMessageView = (TWMessageView *)subview;
            if (animated) {
                [UIView animateWithDuration:kTWMessageBarManagerDismissAnimationDuration animations:^{
                    currentMessageView.frame = CGRectMake(currentMessageView.frame.origin.x, -currentMessageView.frame.size.height, currentMessageView.frame.size.width, currentMessageView.frame.size.height);
                } completion:^(BOOL finished) {
                    [currentMessageView removeFromSuperview];
                }];
            } else [currentMessageView removeFromSuperview];
        }
    }
    
    self.messageVisible = NO;
    [self.messageBarQueue removeAllObjects];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/**
 * Hide all without any animation
 */
- (void)hideAll {
    [self hideAllAnimated:NO];
}

#pragma mark - Helpers
/**
 * Show the next notification message
 */
- (void)showNextMessage {
    if (self.messageBarQueue.count > 0) {
        self.messageVisible = YES;
        
        TWMessageView *messageView = self.messageBarQueue[0];
        messageView.frame = CGRectMake(0, - NOTIFICATION_VIEW_HEIGHT, self.screenWidth, NOTIFICATION_VIEW_HEIGHT);
        messageView.hidden = NO;
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelected:)];
        [messageView addGestureRecognizer:gest];
        
        if (messageView) {
            [self.messageBarQueue removeObject:messageView];

            [UIView animateWithDuration:kTWMessageBarManagerDismissAnimationDuration animations:^{
                messageView.frame = CGRectMake(0, 0, self.screenWidth, NOTIFICATION_VIEW_HEIGHT);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(itemSelected:) withObject:messageView afterDelay:messageView.duration];
            }];
        }
    }
}


#pragma mark - Gestures
/**
 * Handle the behavior when user tap on the notification item
 * @param sender
 */
- (void)itemSelected:(id)sender {
    TWMessageView *messageView = nil;
    BOOL itemHit = NO;
    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        messageView = (TWMessageView *)((UIGestureRecognizer *)sender).view;
        itemHit = YES;
    } else if ([sender isKindOfClass:TWMessageView.class]) {
        messageView = (TWMessageView *)sender;
    }
    
    if (messageView && ![messageView isHit]) {
        messageView.hit = YES;
        
        [UIView animateWithDuration:kTWMessageBarManagerDismissAnimationDuration animations:^{
            [messageView setFrame:CGRectMake(0, - NOTIFICATION_VIEW_HEIGHT, self.screenWidth, NOTIFICATION_VIEW_HEIGHT)];
        } completion:^(BOOL finished) {
            self.messageVisible = NO;
            [messageView removeFromSuperview];
            
            if (itemHit) {
                if ([messageView.callbacks count] > 0) {
                    id obj = [messageView.callbacks objectAtIndex:0];
                    if (![obj isEqual:[NSNull null]]) {
                        ((void (^)())obj)();
                    }
                }
            }
            
            if([self.messageBarQueue count] > 0) [self showNextMessage];
        }];
    }
}

@end
