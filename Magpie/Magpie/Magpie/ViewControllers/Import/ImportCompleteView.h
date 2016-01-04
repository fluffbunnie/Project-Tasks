//
//  ImportCompleteView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImportCompleteViewDelegate <NSObject>
-(void)completeButtonClicked;
@end

@interface ImportCompleteView : UIView
@property (nonatomic, weak) id<ImportCompleteViewDelegate> importCompleteViewDelegate;
-(void)setNumPlacesImported:(int)numPlaces;
@end
