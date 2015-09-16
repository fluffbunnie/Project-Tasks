//
//  ErrorMessageDisplay.m
//  Magpie
//
//  Created by minh thao nguyen on 5/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ErrorMessageDisplay.h"

@implementation ErrorMessageDisplay

NSString * const STANDARD_ERROR_MESSAGE = @"Oops, looks like something went wrong! Please try again.";

NSString * const FB_SIGN_UP_ERROR_TITLE = @"Unable to sign up with Facebook";
NSString * const FB_SIGN_UP_ERROR_MESSAGE = @"Oops, looks like something went wrong! Please try again.";
NSString * const FB_SIGN_UP_CANCEL_TITLE = @"Sign up was cancelled";
NSString * const FB_SIGN_UP_CANCEL_MESSAGE = @"Oops, looks like something went wrong! Please try again.";
NSString * const FB_SIGN_UP_ACCOUNT_USED_TITLE = @"Account In Use";
NSString * const FB_SIGN_UP_ACCOUNT_USED_DESCRIPTION = @"The Facebook account is already in use. Please log in.";
NSString * const FB_SIGN_UP_EMAIL_USED_TITLE = @"Email is already in use";
NSString * const FB_SIGN_UP_EMAIL_USED_MESSAGE = @"Oops, looks like this email is already being used by a Facebook account. Please try again.";

NSString * const CODE_REQUEST_ERROR_TITLE = @"Unable to request the code";
NSString * const CODE_REQUEST_ERROR_MESSAGE = @"Oops, looks like something went wrong! Please try again.";

NSString * const EMAIL_SIGN_UP_ERROR_TITLE = @"Unable to sign up";
NSString * const EMAIL_SIGN_UP_ERROR_MESSAGE = @"Oops, looks like something went wrong! Please try again.";
NSString * const EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_TITLE = @"Unable to sign up";
NSString * const EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_MESSAGE = @"Password must be at least 6 characters. Please try again.";
NSString * const EMAIL_SIGN_UP_WRONG_CODE_TITLE = @"Unable to sign up";
NSString * const EMAIL_SIGN_UP_WRONG_CODE_MESSAGE =  @"Oops, looks like the email and the invitation code you provided do not match. Please try again.";
NSString * const EMAIL_SIGN_UP_EMAIL_USED_TITLE = @"Email is already in use";
NSString * const EMAIL_SIGN_UP_EMAIL_USED_MESSAGE = @"Oops, looks like an account already exists for this email. Please try again.";

NSString * const FB_LOGIN_ERROR_TITLE = @"Unable to log in with Facebook";
NSString * const FB_LOGIN_ERROR_MESSAGE = @"Oops, looks like something went wrong! Please try again.";
NSString * const FB_LOGIN_CANCEL_TITLE = @"Login was cancelled";
NSString * const FB_LOGIN_CANCEL_MESSAGE = @"Oops, looks like something went wrong! Please try again.";
NSString * const FB_LOGIN_EMAIL_USED_TITLE = @"Email is already in use";
NSString * const FB_LOGIN_EMAIL_USED_DESCRIPTION = @"Oops, looks like this email is already being used. Please try again.";
NSString * const FB_LOGIN_USER_DID_NOT_SIGN_UP_TITLE = @"Please sign up";
NSString * const FB_LOGIN_USER_DID_NOT_SIGN_UP_DESCRIPTION = @"Oops, looks like you'll need to create a Magpie account to log in. Please try again.";

NSString * const EMAIL_SIGNIN_ERROR_TITLE = @"Unable to login";
NSString * const EMAIL_SIGNIN_ERROR_DESCRIPTION = @"Oops, looks like something went wrong! Please try again.";
NSString * const EMAIL_SIGNIN_EMAIL_NOT_FOUND_TITLE = @"Email not found.";
NSString * const EMAIL_SIGNIN_EMAIL_NOT_FOUND_DESCRIPTION = @"Oops, looks like this email isn’t in our system. Please create a Magpie account and try again.";
NSString * const EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_TITLE = @"Wrong email or password";
NSString * const EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_DESCRIPTION = @"Oops, looks like either your password or email is wrong. Please try again.";
NSString * const EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_TITLE = @"Login with Facebook required";
NSString * const EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_DESCRIPTION = @"Oops, looks like you'll need to log in with your Facebook account. Please try again.";

NSString * const MESSAGE_SEND_FAIL_TITLE = @"Failed to send the message";
NSString * const MESSAGE_SEND_FAIL_DESCRIPTION = @"Oops, looks like something went wrong. Please try again.";

NSString * const DECK_LOAD_FAIL_TITLE = @"Failed to load deck";
NSString * const DECK_LOAD_FAIL_DESCRIPTION = @"Oops, looks like you need to close Magpie and check your internet connection. Please try again.";

NSString * const LISTING_NO_LONGER_EXIST_TITLE = @"Listing no longer exist";
NSString * const LISTING_NO_LONGER_EXIST_DESCRIPTION = @"Oops, looks like something went wrong! Please try again.";;

NSString * const FAVORITE_AND_MATCHES_LOAD_FAIL_TITLE = @"Failed to load favorites";
NSString * const FAVORITE_AND_MATCHES_LOAD_FAIL_DESCRIPTION = @"Oops, looks like you need to close Magpie and check your internet connection. Please try again.";

NSString * const PHOTO_UPLOAD_FAIL_TITLE = @"Fail to upload photo";
NSString * const PHOTO_UPLOAD_FAIL_DESCRIPTION = @"Oops, looks like something went wrong! Please try again.";

/**
 * show the error alert on top of a given view controller
 * @param UIViewController
 * @param NSString
 * @param NSString
 */
+(void)displayErrorAlertOnViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message {
    if ([UIAlertController class]) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:ok];
        [viewController presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [dialog show];
    }
}

@end
