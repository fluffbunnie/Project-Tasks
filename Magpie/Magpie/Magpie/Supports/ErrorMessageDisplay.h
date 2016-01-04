//
//  ErrorMessageDisplay.h
//  Magpie
//
//  Created by minh thao nguyen on 5/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const STANDARD_ERROR_MESSAGE;

extern NSString * const FB_SIGN_UP_ERROR_TITLE;
extern NSString * const FB_SIGN_UP_ERROR_MESSAGE;
extern NSString * const FB_SIGN_UP_CANCEL_TITLE;
extern NSString * const FB_SIGN_UP_CANCEL_MESSAGE;
extern NSString * const FB_SIGN_UP_ACCOUNT_USED_TITLE;
extern NSString * const FB_SIGN_UP_ACCOUNT_USED_DESCRIPTION;
extern NSString * const FB_SIGN_UP_EMAIL_USED_TITLE;
extern NSString * const FB_SIGN_UP_EMAIL_USED_MESSAGE;

extern NSString * const CODE_REQUEST_ERROR_TITLE;
extern NSString * const CODE_REQUEST_ERROR_MESSAGE;


extern NSString * const EMAIL_SIGN_UP_ERROR_TITLE;
extern NSString * const EMAIL_SIGN_UP_ERROR_MESSAGE;
extern NSString * const EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_TITLE;
extern NSString * const EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_MESSAGE;
extern NSString * const EMAIL_SIGN_UP_WRONG_CODE_TITLE;
extern NSString * const EMAIL_SIGN_UP_WRONG_CODE_MESSAGE;
extern NSString * const EMAIL_SIGN_UP_EMAIL_USED_TITLE;
extern NSString * const EMAIL_SIGN_UP_EMAIL_USED_MESSAGE;

extern NSString * const FB_LOGIN_ERROR_TITLE;
extern NSString * const FB_LOGIN_ERROR_MESSAGE;
extern NSString * const FB_LOGIN_CANCEL_TITLE;
extern NSString * const FB_LOGIN_CANCEL_MESSAGE;
extern NSString * const FB_LOGIN_EMAIL_USED_TITLE;
extern NSString * const FB_LOGIN_EMAIL_USED_DESCRIPTION;
extern NSString * const FB_LOGIN_USER_DID_NOT_SIGN_UP_TITLE;
extern NSString * const FB_LOGIN_USER_DID_NOT_SIGN_UP_DESCRIPTION;

extern NSString * const EMAIL_SIGNIN_ERROR_TITLE;
extern NSString * const EMAIL_SIGNIN_ERROR_DESCRIPTION;
extern NSString * const EMAIL_SIGNIN_EMAIL_NOT_FOUND_TITLE;
extern NSString * const EMAIL_SIGNIN_EMAIL_NOT_FOUND_DESCRIPTION;
extern NSString * const EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_TITLE;
extern NSString * const EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_DESCRIPTION;
extern NSString * const EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_TITLE;
extern NSString * const EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_DESCRIPTION;

extern NSString * const MESSAGE_SEND_FAIL_TITLE;
extern NSString * const MESSAGE_SEND_FAIL_DESCRIPTION;

extern NSString * const DECK_LOAD_FAIL_TITLE;
extern NSString * const DECK_LOAD_FAIL_DESCRIPTION;

extern NSString * const LISTING_NO_LONGER_EXIST_TITLE;
extern NSString * const LISTING_NO_LONGER_EXIST_DESCRIPTION;

extern NSString * const FAVORITE_AND_MATCHES_LOAD_FAIL_TITLE;
extern NSString * const FAVORITE_AND_MATCHES_LOAD_FAIL_DESCRIPTION;

extern NSString * const PHOTO_UPLOAD_FAIL_TITLE;
extern NSString * const PHOTO_UPLOAD_FAIL_DESCRIPTION;

@interface ErrorMessageDisplay : UIView
+(void)displayErrorAlertOnViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message;
@end
