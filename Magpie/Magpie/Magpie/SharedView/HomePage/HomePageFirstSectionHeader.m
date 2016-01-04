//
//  HomePageFirstSectionHeader.m
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageFirstSectionHeader.h"
#import "FontColor.h"

static NSString * FIRST_SECTION_TITLE = @"READY TO WANDER?";
static NSString * FIRST_SECTION_DESCRIPTION = @"THESE HOMES ARE WAITING FOR YOU";

@interface HomePageFirstSectionHeader()
@property (nonatomic, assign) CGFloat containerWidth;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation HomePageFirstSectionHeader
#pragma mark - initiation
/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.containerWidth, 18)];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:FIRST_SECTION_TITLE];
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
//        [attributeString addAttribute:NSUnderlineStyleAttributeName
//                                value:[NSNumber numberWithInt:1]
//                                range:(NSRange){0,[attributeString length]}];
        [attributeString addAttributes:@{NSForegroundColorAttributeName:[FontColor titleColor],
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:12]}
                                 range:(NSRange){0, [attributeString length]}];
        
        _titleLabel.attributedText = attributeString;
    }
    return _titleLabel;
}

/**
 * Lazily init the first section description
 * @return first section description
 */
-(UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.containerWidth, 40)];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:19];
        _descriptionLabel.textColor = [FontColor titleColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.text = FIRST_SECTION_DESCRIPTION;
    }
    return _descriptionLabel;
}

#pragma mark - public init
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.containerWidth = frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self descriptionLabel]];
    }
    return self;
}

@end
