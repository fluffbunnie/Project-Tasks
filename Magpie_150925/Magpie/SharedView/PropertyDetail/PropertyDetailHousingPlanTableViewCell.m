//
//  PropertyDetailHousingPlanTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 4/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PropertyDetailHousingPlanTableViewCell.h"
#import "FontColor.h"

@interface PropertyDetailHousingPlanTableViewCell()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) HousingLayoutView *housingLayoutView;
@end

@implementation PropertyDetailHousingPlanTableViewCell
#pragma mark - initiation
/**
 * Lazily init the housing layout view
 * @return HousingLayoutView
 */
-(HousingLayoutView *)housingLayoutView {
    if (_housingLayoutView == nil) {
        _housingLayoutView = [[HousingLayoutView alloc] initWithFrame:CGRectMake(50, 30, self.cellWidth - 100, self.cellWidth - 100)];
        _housingLayoutView.housingLayoutDelegate = self;
    }
    return _housingLayoutView;
}

#pragma mark - public methods
-(id)init {
    self = [super init];
    if (self) {
        self.cellWidth = [[UIScreen mainScreen] bounds].size.width;
        [self addSubview:[self housingLayoutView]];
    }
    return self;
}

/**
 * Get the view height
 * @return the height of the view
 */
-(CGFloat)viewHeight {
    return self.cellWidth - 40;
}

/**
 * HousingLayoutView delegate
 * Handle the behavior when user click on any of the housing plan button
 * @param index
 */
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index {
    [self.housingPlanDelegate housingLayoutButtonClickAtIndex:index];
}

@end
