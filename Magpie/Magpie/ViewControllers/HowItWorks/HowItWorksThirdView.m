//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksThirdView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"

static NSString * VALUE_LABEL_TEXT_1 = @"She searched on Magpie for free accommendations";
static NSString * VALUE_LABEL_TEXT_2 = @"She checked out details of each place and the host";
static NSString * VALUE_LABEL_TEXT_3 = @"She sent a stay request to Kat’s house";
static NSString * VALUE_LABEL_TEXT_4 = @"Meanwhile, Kat received Dani’s request";
static NSString * VALUE_LABEL_TEXT_5 = @"They communicated on Magpie to get more details straightened out";
static NSString * VALUE_LABEL_TEXT_6 = @"That’s how Dani stayed at Kat’s lovely victorian house for free, and met a good friend";

static NSString * VALUE_OPTION_REQUEST_1 = @"Huong's";
static NSString * VALUE_OPTION_REQUEST_2 = @"Huong's_2";
static NSString * VALUE_OPTION_REQUEST_3 = @"Huong's_3";
static NSString * VALUE_OPTION_REQUEST_4 = @"Huong's_4";

static NSString * VALUE_CHAT_ROW_1 = @"Chat_Row_1";
static NSString * VALUE_CHAT_ROW_2 = @"Chat_Row_2";
static NSString * VALUE_CHAT_ROW_3 = @"Chat_Row_3";

static NSString * VALUE_BACKGROUND_SCREEN = @"Background_Screen_2";
static NSString * VALUE_STAY_REQ_IMAGE = @"Dani_stay_request";
static NSString * VALUE_HUONG_CHECK_OUT = @"Huong's_checkout";
static NSString * VALUE_DANI_AVATAR_IMAGE = @"Dani_Avatar_291";
static NSString * VALUE_HOUSE_IMAGE = @"House_layer";
static NSString * VALUE_DANIREQUEST_IMAGE = @"DaniRequestToKat";
static NSString * VALUE_KAT_AVATAR_IMAGE = @"Kat_Avatar_221";

@interface HowItWorksThirdView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;

@property (nonatomic, strong) UIImageView *valueOptionRequest1;
@property (nonatomic, strong) UIImageView *valueOptionRequest2;
@property (nonatomic, strong) UIImageView *valueOptionRequest3;
@property (nonatomic, strong) UIImageView *valueOptionRequest4;

@property (nonatomic, strong) UIImageView *valueStayRequestImage;
@property (nonatomic, strong) UIImageView *valueHuongCheckOut;
@property (nonatomic, strong) UIImageView *valueHouseImage;
@property (nonatomic, strong) UIImageView *valueDaniAvatar;
@property (nonatomic, strong) UIImageView *valueDaniRequest;
@property (nonatomic, strong) UIImageView *valueKatAvatar;

@property (nonatomic, strong) UIImageView *chatRow1Image;
@property (nonatomic, strong) UIImageView *chatRow2Image;
@property (nonatomic, strong) UIImageView *chatRow3Image;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText1;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText2;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText3;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText4;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText5;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText6;

@end

@implementation HowItWorksThirdView

#pragma mark - initiation screen 1
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueBackgroundImageView {
    if (_valueBackgroundScreen == nil) {
        _valueBackgroundScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _valueBackgroundScreen.contentMode = UIViewContentModeScaleAspectFill;
        _valueBackgroundScreen.backgroundColor = [UIColor whiteColor];
        _valueBackgroundScreen.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN];
    }
    return _valueBackgroundScreen;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage1 {
    if (_valueOptionRequest1 == nil) {
        CGRect frame =CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.14, 160, 265);
        
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.13, 180, 285);
        }
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.14, 135, 225);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.11, 132, 202);
        }

        _valueOptionRequest1 = [[UIImageView alloc] initWithFrame:frame];
        _valueOptionRequest1.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest1.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_1];
        _valueOptionRequest1.backgroundColor = [UIColor clearColor];
        _valueOptionRequest1.alpha = 0;
    }
    return _valueOptionRequest1;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage2 {
    if (_valueOptionRequest2 == nil) {
        CGRect frame =CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.14, 160, 251);
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.13, 180, 271);
        }
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.14, 135, 211);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.128, 132, 171);
        }
        _valueOptionRequest2 = [[UIImageView alloc] initWithFrame:frame];
        _valueOptionRequest2.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest2.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_2];
        _valueOptionRequest2.backgroundColor = [UIColor clearColor];
        _valueOptionRequest2.alpha = 0;
    }
    return _valueOptionRequest2;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage3 {
    if (_valueOptionRequest3 == nil) {
        CGRect frame =CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.56, 160, 251);
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.568, 180, 271);
        }
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.554, 135, 211);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.6, 132, 171);
        }
        _valueOptionRequest3 = [[UIImageView alloc] initWithFrame:frame];
        _valueOptionRequest3.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest3.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_3];
        _valueOptionRequest3.backgroundColor = [UIColor clearColor];
        _valueOptionRequest3.alpha = 0;
    }
    return _valueOptionRequest3;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage4 {
    if (_valueOptionRequest4 == nil) {
        CGRect frame =CGRectMake(self.viewWidth * 0.52, self.viewHeight * 0.56, 160, 265);
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.568, 180, 285);
        }
        if ([Device isIphone5] )  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight * 0.554, 135, 225);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight * 0.57, 132, 185);
        }
        _valueOptionRequest4 = [[UIImageView alloc] initWithFrame:frame];
        _valueOptionRequest4.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest4.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_4];
        _valueOptionRequest4.backgroundColor = [UIColor clearColor];
        _valueOptionRequest4.alpha = 0;
    }
    return _valueOptionRequest4;
    
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText1 {
    if (_valueLabelText1 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
        int fontSize = 15;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
            fontSize = 13;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.001, self.viewWidth*0.5, self.viewHeight*0.08);
            fontSize = 11;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];

        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_1 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText1 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText1.lineSpacing = 10;
        _valueLabelText1.numberOfLines = 2;
        _valueLabelText1.lineHeightMultiple = 20;
        _valueLabelText1.shadowRadius = 1;
        _valueLabelText1.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText1.text = attStr;
        _valueLabelText1.alpha = 0;
    }
    return _valueLabelText1;
}

#pragma mark Init all screens
/**
 * Inititialize all screen
 */


-(void) initScreen1 {
//    [self addSubview:[self valueBackgroundImageView]];
    
    [self addSubview:[self valueTitleText1]];
    [self addSubview:[self valueOptionRequestImage1]];
    [self addSubview:[self valueOptionRequestImage2]];
    [self addSubview:[self valueOptionRequestImage3]];
    [self addSubview:[self valueOptionRequestImage4]];
    
}

#pragma mark - initiation screen 2

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText2 {
    if (_valueLabelText2 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
        int fontSize = 15;
        
        if ([Device isIphone6Plus]) {
            frame = CGRectMake(self.viewWidth *0.24, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
            fontSize = 16;
        }
        else if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
            fontSize = 13;
        }
        
        else if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.001, self.viewWidth*0.5, self.viewHeight*0.08);
            fontSize = 11;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_2 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText2 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText2.lineSpacing = 10;
        _valueLabelText2.numberOfLines = 2;
        _valueLabelText2.lineHeightMultiple = 20;
        _valueLabelText2.shadowRadius = 1;
        _valueLabelText2.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText2.text = attStr;
        _valueLabelText2.alpha = 0.0f;
    }
    return _valueLabelText2;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueCheckOutDetails{
    if (_valueHuongCheckOut == nil) {

        _valueHuongCheckOut = [[UIImageView alloc] init];
        
        if ([Device isIphone5])  {
            _valueHuongCheckOut.frame = CGRectMake(self.viewWidth * 0.1, self.viewHeight *0.14, 150, 255);
        }
        else  {
            if ([Device isIphone4])
                _valueHuongCheckOut.frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.06, 150, 255);
            
            else if ([Device isIphone6])
                _valueHuongCheckOut.frame = CGRectMake(self.viewWidth * 0.07, self.viewHeight *0.14, 150, 255);
            else
                _valueHuongCheckOut.frame = CGRectMake(self.viewWidth * 0.1, self.viewHeight *0.14, 150, 255);
        }
        
        _valueHuongCheckOut.contentMode = UIViewContentModeScaleAspectFill;
        _valueHuongCheckOut.backgroundColor = [UIColor clearColor];
        _valueHuongCheckOut.image = [UIImage imageNamed:VALUE_HUONG_CHECK_OUT];
        _valueHuongCheckOut.alpha = 0.0f;
    }
    return _valueHuongCheckOut;
}

-(void) initScreen2 {

    [self addSubview:[self valueTitleText2]];
    [self addSubview:[self valueCheckOutDetails]];

}

#pragma mark - initiation screen 3

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText3 {
    if (_valueLabelText3 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
        int fontSize = 15;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
            fontSize = 13;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.003, self.viewWidth*0.4, self.viewHeight*0.09);
            fontSize = 11;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_3 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText3 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText3.lineSpacing = 10;
        _valueLabelText3.numberOfLines = 2;
        _valueLabelText3.lineHeightMultiple = 20;
        _valueLabelText3.shadowRadius = 1;
        _valueLabelText3.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText3.text = attStr;
        _valueLabelText3.alpha = 0.0f;
    }
    return _valueLabelText3;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueStayRequest{
    if (_valueStayRequestImage == nil) {
        _valueStayRequestImage = [[UIImageView alloc] init];
        _valueStayRequestImage.contentMode = UIViewContentModeScaleAspectFill;
        _valueStayRequestImage.backgroundColor = [UIColor clearColor];
        _valueStayRequestImage.image = [UIImage imageNamed:VALUE_STAY_REQ_IMAGE];
        _valueStayRequestImage.alpha = 0.0f;
    }
    return _valueStayRequestImage;
}

-(void) initScreen3 {
   
    [self addSubview:[self valueTitleText3]];
    [self addSubview:[self valueStayRequest]];

}


#pragma mark - initiation screen 4

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText4 {
    if (_valueLabelText4 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
        int fontSize = 15;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.01, self.viewWidth*0.5, self.viewHeight*0.12);
            fontSize = 13;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.28, self.viewHeight*0.003, self.viewWidth*0.4, self.viewHeight*0.09);
            fontSize = 11;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_4 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText4 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText4.lineSpacing = 10;
        _valueLabelText4.numberOfLines = 2;
        _valueLabelText4.lineHeightMultiple = 20;
        _valueLabelText4.shadowRadius = 1;
        _valueLabelText4.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText4.text = attStr;
        _valueLabelText4.alpha = 0.0f;
    }
    return _valueLabelText4;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueDaniStayRequest{
    if (_valueDaniRequest == nil) {
        CGRect frame =CGRectMake(self.viewWidth *0.185, self.viewHeight * 0.26, self.viewWidth *0.63, self.viewHeight *0.54);
        if ([Device isIphone5] )  {
            frame = CGRectMake(self.viewWidth *0.19, self.viewHeight * 0.26, self.viewWidth *0.63, self.viewHeight *0.54);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth *0.185, self.viewHeight * 0.26, self.viewWidth *0.63, self.viewHeight *0.54);
        }
        _valueDaniRequest = [[UIImageView alloc] initWithFrame:frame];
        _valueDaniRequest.contentMode = UIViewContentModeScaleAspectFill;
        _valueDaniRequest.backgroundColor = [UIColor clearColor];
        _valueDaniRequest.image = [UIImage imageNamed:VALUE_DANIREQUEST_IMAGE];
        _valueDaniRequest.alpha = 0.0f;
    }
    return _valueDaniRequest;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueAvatarDaniStayRequest{
    if (_valueKatAvatar == nil) {
        CGRect frame =CGRectMake(self.viewWidth *0.05, self.viewHeight*0.13, 110, 110);
        if ([Device isIphone5] )  {
            frame = CGRectMake(self.viewWidth *0.08, self.viewHeight * 0.15, 90, 90);
        }
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth *0.15, self.viewHeight * 0.18, 60, 60);
        }
        _valueKatAvatar = [[UIImageView alloc] initWithFrame:frame];
        _valueKatAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _valueKatAvatar.backgroundColor = [UIColor clearColor];
        _valueKatAvatar.image = [UIImage imageNamed:VALUE_KAT_AVATAR_IMAGE];//VALUE_KAT_AVATR];
        _valueKatAvatar.alpha = 0.0f;
    }
    return _valueKatAvatar;
}

-(void) initScreen4 {
 
    [self addSubview:[self valueTitleText4]];

    [self addSubview:[self valueDaniStayRequest]];
    
    [self addSubview:[self valueAvatarDaniStayRequest]];
}

#pragma mark - initiation screen 5

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText5 {
    if (_valueLabelText5 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.15, self.viewHeight*0.01, self.viewWidth*0.69, self.viewHeight*0.12);
        int fontSize = 15;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.15, self.viewHeight*0.01, self.viewWidth*0.69, self.viewHeight*0.12);
            fontSize = 14;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.15, self.viewHeight*0.01, self.viewWidth*0.69, self.viewHeight*0.12);
            fontSize = 13;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_5 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText5 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText5.lineSpacing = 10;
        _valueLabelText5.numberOfLines = 2;
        _valueLabelText5.lineHeightMultiple = 20;
        _valueLabelText5.shadowRadius = 1;
        _valueLabelText5.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText5.text = attStr;
        _valueLabelText5.alpha = 0;
    }
    return _valueLabelText5;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow1Image {
    if (_chatRow1Image == nil) {
        CGRect frame;// =CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.22, self.viewWidth *0.876, self.viewHeight * 0.1);
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.218, self.viewWidth *0.876, self.viewHeight * 0.1);
        }
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.2, self.viewWidth *0.876, self.viewHeight * 0.11);
        }
        else frame =CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.2, self.viewWidth * 0.876, self.viewHeight * 0.1);
        
        _chatRow1Image = [[UIImageView alloc] initWithFrame:frame];
        _valueOptionRequest1.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow1Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_1];
        _chatRow1Image.backgroundColor = [UIColor clearColor];
        _chatRow1Image.alpha = 0;
    }
    return _chatRow1Image;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow2Image {
    if (_chatRow2Image == nil) {
        CGRect frame ;//=CGRectMake(self.viewWidth * 0.253, self.viewHeight *0.34, self.viewWidth * 0.725, self.viewHeight * 0.127);
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.253, self.viewHeight *0.375, self.viewWidth * 0.725, self.viewHeight * 0.127);
        }
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.253, self.viewHeight *0.37, self.viewWidth * 0.725, self.viewHeight * 0.127);
        }
        else frame =CGRectMake(self.viewWidth * 0.253, self.viewHeight *0.352, self.viewWidth * 0.725, self.viewHeight * 0.127);
        
        _chatRow2Image = [[UIImageView alloc] initWithFrame:frame];
        _chatRow2Image.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow2Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_2];
        _chatRow2Image.backgroundColor = [UIColor clearColor];
        _chatRow2Image.alpha = 0;
    }
    return _chatRow2Image;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow3Image {
    if (_chatRow3Image == nil) {
        CGRect frame ;//=CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.488, self.viewWidth *0.876, self.viewHeight * 0.1);
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.55, self.viewWidth *0.884, self.viewHeight * 0.1);
        }
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.02, self.viewHeight *0.56, self.viewWidth *0.876, self.viewHeight * 0.11);
        }
        else frame =CGRectMake(self.viewWidth * 0.05, self.viewHeight *0.52, self.viewWidth *0.876, self.viewHeight * 0.1);
        
        _chatRow3Image = [[UIImageView alloc] initWithFrame:frame];
        _chatRow3Image.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow3Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_3];
        _chatRow3Image.backgroundColor = [UIColor clearColor];
        _chatRow3Image.alpha = 0;
    }
    return _chatRow3Image;
    
}

// initialize screen 5

-(void) initScreen5 {
    
    [self addSubview:[self valueTitleText5]];
    [self addSubview:[self valueChatRow1Image]];
    [self addSubview:[self valueChatRow2Image]];
    [self addSubview:[self valueChatRow3Image]];
}

#pragma mark - initiation screen 6

/**
* Lazily init the value prop text
* @return TTTAttributedLabel
*/

-(TTTAttributedLabel *)valueTitleText6 {
    if (_valueLabelText6 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.22, self.viewHeight*0.008, self.viewWidth*0.6, self.viewHeight*0.15);
        int fontSize = 15;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.2, self.viewHeight*0.008, self.viewWidth*0.6, self.viewHeight*0.2);
            fontSize = 13;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.2, self.viewHeight*0.008, self.viewWidth*0.6, self.viewHeight*0.16);
            fontSize = 11;
        }
        
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_6 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText6 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText6.lineSpacing = 10;
        _valueLabelText6.numberOfLines = 3;
        _valueLabelText6.lineHeightMultiple = 20;
        _valueLabelText6.shadowRadius = 1;
        _valueLabelText6.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText6.text = attStr;
        _valueLabelText6.alpha = 0.0f;
    }
    return _valueLabelText6;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(void) addValueAvatarKat{
    
    CGRect frame =CGRectMake(self.viewWidth * 0.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);
    
    if ([Device isIphone5] )  {
        frame = CGRectMake(self.viewWidth *0.12, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
    }
    if ([Device isIphone4])  {
        frame = CGRectMake(self.viewWidth *0.15, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
    }
    
    _valueKatAvatar.frame = frame;
    _valueKatAvatar.alpha = 1.0f;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueDaniAvatarImage{
    if (_valueDaniAvatar == nil) {
        
        if ([Device isIphone5] )  {
            _valueDaniAvatar.frame = CGRectMake( self.viewWidth * 1.8, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
        }
        if ([Device isIphone4])  {
            _valueDaniAvatar.frame = CGRectMake( self.viewWidth * 1.8, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
        }
        else {
            _valueDaniAvatar.frame = CGRectMake( self.viewWidth * 1.8, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);
        }
        
        _valueDaniAvatar = [[UIImageView alloc] init];
        _valueDaniAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _valueDaniAvatar.backgroundColor = [UIColor clearColor];
        _valueDaniAvatar.image = [UIImage imageNamed:VALUE_DANI_AVATAR_IMAGE];
        _valueDaniAvatar.alpha = 0.0f;

    }
    return _valueDaniAvatar;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueHouseKatImage{
    if (_valueHouseImage == nil) {
        
        CGRect frame4 =CGRectMake(self.viewWidth * 0.4, self.viewHeight*0.7, self.viewWidth * 0.2, self.viewHeight * 0.3);// 150, 225);
        
        if ([Device isIphone4]) frame4 = CGRectMake(self.viewWidth * 0.4, self.viewHeight*0.7, self.viewWidth * 0.2 , self.viewHeight * 0.3);
        if ([Device isIphone5]) frame4 = CGRectMake(self.viewWidth * 0.4, self.viewHeight*0.7, self.viewWidth * 0.2 , self.viewHeight * 0.3);

        _valueHouseImage = [[UIImageView alloc] initWithFrame:frame4];
        _valueHouseImage.contentMode = UIViewContentModeScaleAspectFill;
        _valueHouseImage.backgroundColor = [UIColor clearColor];
        _valueHouseImage.image = [UIImage imageNamed:VALUE_HOUSE_IMAGE];
        _valueHouseImage.alpha = 0.0f;
    }
    return _valueHouseImage;
}

-(void) initScreen6 {
 
    [self addSubview:[self valueTitleText6]];
    
    [self addSubview:[self valueDaniAvatarImage]];
    
    [self addSubview:[self valueHouseKatImage]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(2 * self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self initScreen1];
        [self initScreen2];
        [self initScreen3];
        [self initScreen4];
        [self initScreen5];
        [self initScreen6];
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {

    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _valueLabelText1.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                _valueOptionRequest1.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                        _valueOptionRequest2.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                                _valueOptionRequest3.alpha = 1;
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                                        _valueOptionRequest4.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        if (finished) {
                                            [self animatedScreen2];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

/**
 * show the view2 in animation
 */

-(void) animatedScreen2 {
    
    _valueLabelText1.alpha = 0;
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.valueOptionRequest2.alpha = 0;
        self.valueOptionRequest3.alpha = 0;
        self.valueOptionRequest4.alpha = 0;
        _valueLabelText2.alpha = 1;
    
    } completion:^(BOOL finished) {
        if (finished) {
//                self.valueOptionRequest1.alpha = 0;
                _valueHuongCheckOut.frame = _valueOptionRequest1.frame;
            [UIView animateWithDuration:2.0f delay:0.5f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
                
                self.valueOptionRequest1.alpha = 0;
               
                if ([Device isIphone5] )  {
                        _valueHuongCheckOut.frame = CGRectMake(self.viewWidth *0.1, self.viewHeight * 0.2, 260, 380);
                    }
                else if ([Device isIphone4])  {
                        _valueHuongCheckOut.frame = CGRectMake(self.viewWidth *0.145, self.viewHeight * 0.12, 222, 383);
                }
                else if ([Device isIphone6])
                    _valueHuongCheckOut.frame = CGRectMake(self.viewWidth *0.12, self.viewHeight * 0.15, 295, 510);
                else
                    _valueHuongCheckOut.frame = CGRectMake(self.viewWidth *0.134, self.viewHeight * 0.15, 295, 510);
                
                _valueHuongCheckOut.alpha = 1;
                
            } completion:^(BOOL finished) {
                if (finished) {
                      [self animatedScreen3];
                }
            }];
        }
    }];

}

/**
 * show the view3 in animation
 */

-(void) animatedScreen3 {
    
    [UIView animateWithDuration:1.0f delay:1.5f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        _valueHuongCheckOut.alpha = 0;
        _valueLabelText2.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionLayoutSubviews animations:^{
                _valueLabelText3.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    if ([Device isIphone5] )  {
                        _valueStayRequestImage.frame = CGRectMake(self.viewWidth *2.1, self.viewHeight * 0.15, 240, 410);
                    }
                    else if ([Device isIphone4])  {
                        _valueStayRequestImage.frame = CGRectMake(self.viewWidth *2.148, self.viewHeight * 0.12, 220, 380);
                    }
                    else
                        _valueStayRequestImage.frame = CGRectMake(self.viewWidth *2.12, self.viewHeight * 0.15, 290, 504);
                    
                    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                        if ([Device isIphone5] )  {
                            _valueStayRequestImage.frame = CGRectMake(self.viewWidth *0.13, self.viewHeight * 0.15, 240, 410);
                        }
                        else if ([Device isIphone6] )
                            _valueStayRequestImage.frame = CGRectMake(self.viewWidth *0.12, self.viewHeight * 0.15, 290, 504);
                        
                        else if ([Device isIphone4])  {
                            _valueStayRequestImage.frame = CGRectMake(self.viewWidth *0.148, self.viewHeight * 0.12, 220, 380);
                        }
                        else
                            _valueStayRequestImage.frame = CGRectMake(self.viewWidth *0.146, self.viewHeight * 0.15, 295, 510);
                        
                        _valueStayRequestImage.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self animatedScreen4];
                        }
                    }];
                }
            }];
        }
    }];
    
    
    
}

/**
 * show the view4 in animation
 */

-(void) animatedScreen4 {
    [UIView animateWithDuration:1.0f delay:1.5f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        _valueStayRequestImage.alpha = 0;
        _valueLabelText3.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _valueLabelText4.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    if ([Device isIphone5] )  {
                        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *1.8, self.viewHeight * 0.13, 90, 90);
                    }
                    else if ([Device isIphone4])  {
                        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *2.1, self.viewHeight * 0.12, 80, 80);
                    }
                    else
                        _valueKatAvatar.frame =CGRectMake(- self.viewWidth *1.5, self.viewHeight* 0.13, 110, 110);
                    
                    [UIView animateWithDuration:1.5f delay:0.5f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                        
                        if ([Device isIphone5] )  {
                            _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.08, self.viewHeight * 0.13, 90, 90);
                        }
                        else if ([Device isIphone4])  {
                            _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.1, self.viewHeight * 0.12, 80, 80);
                        }
                        else
                            _valueKatAvatar.frame =CGRectMake(self.viewWidth *0.05, self.viewHeight*0.13, 110, 110);
                        
                        _valueKatAvatar.alpha = 1;
                        _valueDaniRequest.alpha = 1;
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self animatedScreen5];
                        }
                    }];
                    
                }
            }];
        }
    }];
    
    
}

/**
 * show the view5 in animation
 */

-(void) animatedScreen5 {
    
    [UIView animateWithDuration:1.0f delay:2.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _valueDaniRequest.alpha = 0;
        _valueKatAvatar.alpha = 0;
        _valueLabelText4.alpha = 0;
        _valueLabelText5.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                    _chatRow1Image.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        _chatRow2Image.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
                                _chatRow3Image.alpha = 1;
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    [self animatedScreen6];
                                }
                            }];

                        }
                    }];
                }
            }];
        }
    }];
    
}

/**
 * show the view6 in animation
 */

-(void) animatedScreen6 {
    
    if ([Device isIphone5] )  {
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *2.12, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
    }
    else if ([Device isIphone4])  {
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *2.15, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
    }
    else
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth * 2.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);

    [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        _chatRow1Image.alpha = 0;
        _chatRow2Image.alpha = 0;
        _chatRow3Image.alpha = 0;
        _valueLabelText5.alpha = 0;
        _valueLabelText6.alpha = 1;
        [self addValueAvatarKat];
       
    } completion:^(BOOL finished) {
        if (finished) {
            
            if ([Device isIphone5] )  {
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth *2.57, self.viewHeight * 0.266, self.viewWidth *0.29, self.viewHeight *0.19);
            }
            else if ([Device isIphone4])  {
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth *2.54, self.viewHeight * 0.256, self.viewWidth *0.3, self.viewHeight *0.2);
            }
            else
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth * 2.58, self.viewHeight * 0.266, self.viewWidth *0.3, self.viewHeight *0.2);
            
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                _valueDaniAvatar.alpha = 1;
                if ([Device isIphone5] )  {
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth *0.57, self.viewHeight * 0.266, self.viewWidth *0.29, self.viewHeight *0.19);
                }
                else if ([Device isIphone4])  {
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth *0.54, self.viewHeight * 0.256, self.viewWidth *0.3, self.viewHeight *0.2);
                }
                else
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth * 0.58, self.viewHeight * 0.266, self.viewWidth *0.3, self.viewHeight *0.2);

               
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
                        _valueHouseImage.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                //            show button sign up
//                            [self.howItWorksViewDelegate repeatSlideshow];
//                            [_howItWorksViewDelegate showRepeatButton];
                            [_howItWorksViewDelegate gotoNextPage];
                        }
                    }];
                }
            }];
        }
    }];
}

/**
 * Hide the view and animation
 */
-(void)hideView {
    //screen hide all
    self.valueOptionRequest1.alpha = 0;
    self.valueOptionRequest2.alpha = 0;
    self.valueOptionRequest3.alpha = 0;
    self.valueOptionRequest4.alpha = 0;
    self.valueLabelText1.alpha = 0;
    self.valueLabelText2.alpha = 0;
    self.valueLabelText3.alpha = 0;
    self.valueLabelText4.alpha = 0;
    self.valueLabelText5.alpha = 0;
    self.valueLabelText6.alpha = 0;
    
    self.valueStayRequestImage.alpha = 0;
    self.valueHuongCheckOut.alpha = 0;;
    self.valueHouseImage.alpha = 0;
    self.valueDaniAvatar.alpha = 0;
    self.valueDaniRequest.alpha = 0;
    self.valueKatAvatar.alpha = 0;
    
    self.chatRow1Image.alpha = 0;
    self.chatRow2Image.alpha = 0;
    self.chatRow3Image.alpha = 0;
    
    [self.valueOptionRequest1.layer removeAllAnimations];
    [self.valueOptionRequest2.layer removeAllAnimations];
    [self.valueOptionRequest3.layer removeAllAnimations];
    [self.valueOptionRequest4.layer removeAllAnimations];
    [self.valueLabelText1.layer removeAllAnimations];
    [self.valueLabelText2.layer removeAllAnimations];
    [self.valueLabelText3.layer removeAllAnimations];
    [self.valueLabelText4.layer removeAllAnimations];
    [self.valueLabelText5.layer removeAllAnimations];
    [self.valueLabelText6.layer removeAllAnimations];
    
    [self.valueStayRequestImage.layer removeAllAnimations];
    [self.valueHuongCheckOut.layer removeAllAnimations];
    [self.valueHouseImage.layer removeAllAnimations];
    [self.valueDaniAvatar.layer removeAllAnimations];
    [self.valueDaniRequest.layer removeAllAnimations];
    [self.valueKatAvatar.layer removeAllAnimations];
    
    [self.chatRow1Image.layer removeAllAnimations];
    [self.chatRow2Image.layer removeAllAnimations];
    [self.chatRow3Image.layer removeAllAnimations];

}

@end
