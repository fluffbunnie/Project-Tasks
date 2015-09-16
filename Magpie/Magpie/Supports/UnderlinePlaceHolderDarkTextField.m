//
//  FloatUnderlinePlaceHolderDarkTextField.m
//  Magpie
//
//  Created by minh thao nguyen on 9/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "UnderlinePlaceHolderDarkTextField.h"
#import "FontColor.h"

@interface UnderlinePlaceHolderDarkTextField()

@property (nonatomic, strong) UIView *viewUnderline;
@property (nonatomic, strong) NSString *placeHolderStr;

@end

@implementation UnderlinePlaceHolderDarkTextField
/**
 * init view backgroud textfield
 * @return view background
 */
-(UIView *)viewUnderline{
    if (_viewUnderline == nil) {
        CGRect frame = CGRectMake(0, self.frame.size.height - 7, self.frame.size.width, 1);
        _viewUnderline = [[UIView alloc] initWithFrame:frame];
        _viewUnderline.backgroundColor = [FontColor tableSeparatorColor];
        _viewUnderline.userInteractionEnabled = NO;
    }
    return _viewUnderline;
}

#pragma mark - public method
-(id)initWithPlaceHolder:(NSString *)placeholder andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeyDone;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[FontColor propertyImageBackgroundColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15]}];
        
        self.layer.masksToBounds = NO;
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        self.textColor = [FontColor descriptionColor];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self addSubview:[self viewUnderline]];
    }
    return self;
}

@end
