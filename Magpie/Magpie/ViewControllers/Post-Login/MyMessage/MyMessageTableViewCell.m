//
//  MyMessageTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyMessageTableViewCell.h"
#import "SquircleProfileImage.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "UserManager.h"
#import "ChatMessages.h"
#import "PMCalendar.h"

static NSString * const BOOK_REQUEST_FROM_YOU = @"You requested a stay at %@'s place";
static NSString * const BOOK_REQUEST_FROM_OTHER = @"%@ requested a stay at your place";
static NSString * const CONFIRM_REQUEST_FROM_YOU = @"You have approved %@'s stay request";
static NSString * const CONFIRM_REQUEST_FROM_OTHER = @"%@ have approved your stay request";
static NSString * const CANCEL_REQUEST_FROM_YOU = @"You canceled your stay request at %@'s place";
static NSString * const CANCEL_REQUEST_FROM_OTHER = @"%@ canceled the stay request at your place";

@interface MyMessageTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) TTTAttributedLabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation MyMessageTableViewCell
#pragma mark - initiation
/**
 * Lazily init the profile image
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    }
    return _profileImage;
}

/**
 * Lazily init the name label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(90, 15, self.viewWidth - 180, 22)];
        _nameLabel.textColor = [FontColor titleColor];
        _nameLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    }
    return _nameLabel;
}

/**
 * Lazily initt the time label
 * @return UILabel
 */
-(UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.viewWidth - 80, 15, 65, 22)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _timeLabel.textColor = [FontColor descriptionColor];
    }
    return _timeLabel;
}

/**
 * Lazily init the description label
 * @return UILabel
 */
-(UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 42, self.viewWidth - 120, 20)];
        _descriptionLabel.textColor = [FontColor descriptionColor];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    }
    return _descriptionLabel;
}

/**
 * Lazily init the separator view
 * @return UIView
 */
-(UIView *)separatorView {
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.viewWidth, 1)];
        _separatorView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _separatorView;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:[self profileImage]];
        [self.contentView addSubview:[self nameLabel]];
        [self.contentView addSubview:[self timeLabel]];
        [self.contentView addSubview:[self descriptionLabel]];
        [self.contentView addSubview:[self separatorView]];
    }
    return self;
}

-(void)setMessageObj:(PFObject *)messageObj {
    self.profileImage.image = [FontColor imageWithColor:[UIColor whiteColor]];
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        NSDate *viewDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
        PFObject *recipient;
        
        //find the recipeint and last view date
        PFObject *user1 = messageObj[@"user1"];
        PFObject *user2 = messageObj[@"user2"];
        if ([user1.objectId isEqualToString:userObj.objectId]) {
            if (messageObj[@"user1LastSeen"]) viewDate = messageObj[@"user1LastSeen"];
            recipient = user2;
        } else {
            if (messageObj[@"user2LastSeen"]) viewDate = messageObj[@"user2LastSeen"];
            recipient = user1;
        }
        
        PFObject *snippet = messageObj[@"snippet"];
        [self updateSubviewsGivenLastTimeSeen:viewDate andLastUpdate:snippet.createdAt];
        [self.profileImage setProfileImageWithUrl:recipient[@"profilePic"]];
        self.descriptionLabel.text = [self getSnippetFromChatObj:snippet andCurrentUser:userObj];
        self.timeLabel.text = [self dateStringForDate:snippet.createdAt];
        self.nameLabel.text = [UserManager getUserNameFromUserObj:recipient];
    }];
}

#pragma mark - helper method
/**
 * Get the display date string for the given date
 * @param NSDate
 * @return NSString
 */
-(NSString *)dateStringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.doesRelativeDateFormatting = YES;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [formatter stringFromDate:date];
    NSUInteger index = [dateString rangeOfString:@"today" options:NSCaseInsensitiveSearch].location;
    if (index == NSNotFound) return [date dateStringWithFormat:@"MMM dd"];
    else {
        NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
        newFormatter.dateStyle = NSDateFormatterNoStyle;
        newFormatter.timeStyle = NSDateFormatterShortStyle;
        return [newFormatter stringFromDate:date];
    }
}

/**
 * Format the view provided the last seen time and the update time of this conversation
 * @param NSDate
 * @param NSDate
 */
-(void)updateSubviewsGivenLastTimeSeen:(NSDate *)lastSeen andLastUpdate:(NSDate *)lastUpdate {
    if ([lastSeen compare:lastUpdate] == NSOrderedAscending) {
        //is read
        self.nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.timeLabel.textColor = [FontColor themeColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        self.descriptionLabel.textColor = [FontColor titleColor];
    } else {
        self.nameLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
        self.timeLabel.textColor = [FontColor descriptionColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        self.descriptionLabel.textColor = [FontColor descriptionColor];
    }
}

/**
 * Get the snippet string from the chat object, and the current user
 * @param PFObject
 * @param PFObject
 */
-(NSString *)getSnippetFromChatObj:(PFObject *)chatObject andCurrentUser:(PFObject *)userObj {
    NSString *contentType = chatObject[@"contentType"];
    if ([contentType isEqualToString:MESSAGE_TYPE_TEXT]) return chatObject[@"content"];
    else {
        PFObject *sender = chatObject[@"sender"];
        PFObject *receiver = chatObject[@"receiver"];
        NSString *targetUserName = [UserManager getUserNameFromUserObj:receiver];
        NSString *senderName = [UserManager getUserNameFromUserObj:sender];
        if ([sender.objectId isEqualToString:userObj.objectId]) {
            if ([contentType isEqualToString:MESSAGE_TYPE_BOOK]) return [NSString stringWithFormat:BOOK_REQUEST_FROM_YOU, targetUserName];
            if ([contentType isEqualToString:MESSAGE_TYPE_CANCEL]) return [NSString stringWithFormat:CANCEL_REQUEST_FROM_YOU, targetUserName];
            if ([contentType isEqualToString:MESSAGE_TYPE_CONFIRM]) return [NSString stringWithFormat:CONFIRM_REQUEST_FROM_YOU, targetUserName];
        } else {
            if ([contentType isEqualToString:MESSAGE_TYPE_BOOK]) return [NSString stringWithFormat:BOOK_REQUEST_FROM_OTHER, senderName];
            if ([contentType isEqualToString:MESSAGE_TYPE_CANCEL]) return [NSString stringWithFormat:CANCEL_REQUEST_FROM_OTHER, senderName];
            if ([contentType isEqualToString:MESSAGE_TYPE_CONFIRM]) return [NSString stringWithFormat:CONFIRM_REQUEST_FROM_OTHER, senderName];
        }
        return [UserManager getUserNameFromUserObj:sender];
    }
}
@end
