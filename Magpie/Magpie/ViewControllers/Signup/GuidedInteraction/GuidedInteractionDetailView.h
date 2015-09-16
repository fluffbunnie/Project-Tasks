//
//  GuidedInteractionDetailView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const KAT_NAME = @"Katerina";

static NSString * const MINH_NAME = @"Michael";

static NSString * const HUONG_NAME = @"Jenny";


static NSString * const KATERINA_DESCRIPTION = @"Originally from New York but now a firm believer of the “west coast, best coast” mentality. I love spontaneous road trips, long dinners with friends, and anything that involves pizza! Enjoy a blissful weekend in my romantic guesthouse nestled in the picturesque town of Carmel.";

static NSString * const MINH_DESCRIPTION = @"Hi, I’m Michael! I’m an entrepreneur and travel frequently for work, so my beautiful LA home is up for you to enjoy. I’m an avid tennis player and love trying new restaurants. There are some awesome sushi places and great shopping near my home - you won’t have a shortage of things to do.";

static NSString * const HUONG_DESCRIPTION = @"I’ve been a nomad most of my live but have recently settled down in San Francisco. I’m an artist working on opening up my own gallery downtown. Would love to meet other creative individuals and host you in my sunny SF oasis.";

static NSString * const KAT_HOME_TITLE = @"Classic guest house in Carmel Highlands";

static NSString * const MINH_HOME_TITLE = @"Modern home in the heart of downtown";

static NSString * const HUONG_HOME_TITLE = @"Bright & sunny San Francisco apartment";

@interface GuidedInteractionDetailView : UIView
-(id)initWithIndex:(int)index;
-(id)initFromOriginWithIndex:(int)index;
@end
