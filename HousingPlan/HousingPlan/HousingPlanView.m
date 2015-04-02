//
//  HousingPlanView.m
//  HousingPlan
//
//  Created by minh thao nguyen on 4/1/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HousingPlanView.h"

static NSString * BEDROOM_BACKGROUND = @"HousingPlanBedroomBackground";
static NSString * BEDROOM_ICON_STATE_NORMAL = @"HousingPlanBedroomStateNormal";
static NSString * BEDROOM_ICON_STATE_HIGHLIGHT = @"HousingPlanBedroomStateHighlight";

static NSString * BATHROOM_BACKGROUND = @"HousingPlanBathroomBackground";
static NSString * BATHROOM_ICON_STATE_NORMAL = @"HousingPlanBathroomStateNormal";
static NSString * BATHROOM_ICON_STATE_HIGHLIGHT = @"HousingPlanBathroomStateHighlight";

static NSString * LIVINGROOM_BACKGROUND = @"HousingPlanLivingroomBackground";
static NSString * LIVINGROOM_ICON_STATE_NORMAL = @"HousingPlanLivingroomStateNormal";
static NSString * LIVINGROOM_ICON_STATE_HIGHLIGHT = @"HousingPlanLivingroomStateHighlight";

static NSString * KITCHEN_AND_DINING_ROOM_BACKGROUND = @"HousingPlanKitchenAndDiningRoomBackground";
static NSString * KITCHEN_AND_DINING_ROOM_ICON_STATE_NORMAL = @"HousingPlanKitchenAndDiningRoomStateNormal";
static NSString * KITCHEN_AND_DINING_ROOM_ICON_STATE_HIGHLIGHT = @"HousingPlanKitchenAndDiningRoomStateHighlight";

static NSString * NETWORK_AND_COMMUNICATION_BACKGROUND = @"HousingPlanNetworkAndCommunicationBackground";
static NSString * NETWORK_AND_COMMUNICATION_ICON_STATE_NORMAL = @"HousingPlanNetworkAndCommunicationStateNormal";
static NSString * NETWORK_AND_COMMUNICATION_ICON_STATE_HIGHLIGHT = @"HousingPlanNetworkAndCommunicationStateHighlight";

static NSString * OTHERS_BACKGROUND = @"HousingPlanOthersBackground";
static NSString * OTHERS_ICON_STATE_NORMAL = @"HousingPlanOthersStateNormal";
static NSString * OTHERS_ICON_STATE_HIGHLIGHT = @"HousingPlanOthersStateHighlight";

@interface HousingPlanView()

@property (nonatomic, assign) CGFloat viewWitdh;  // the width of the view when instantiate
@property (nonatomic, assign) CGFloat viewHeight;  //the height of the view when instantiate

@end

@implementation HousingPlanView
#pragma mark - identify the view frame for each of the button
/**
 * Get the frame for the living room
 * @return CGRect
 */
-(CGRect)getLivingRoomButtonFrame {
    //TODO return the correct frame for the living room button
    return CGRectZero;
}

/**
 * Get the frame for the bedroom
 * @return CGRect
 */
-(CGRect)getBedroomButtonFrame {
    //TODO return the correct frame
    return CGRectZero;
}

/**
 * Get the frame for the bathroom
 * @return CGRect
 */
-(CGRect)getBathroomButtonFrame {
    //TODO return the correct frame
    return CGRectZero;
}

/**
 * Get the frame for the kitchen and dining room
 * @return CGRect
 */
-(CGRect)getKitchenAndDiningRoomButtomFrame {
    //TODO return the correct frame
    return CGRectZero;
}

/**
 * Get the frame for the network and communication button
 * @return CGRect
 */
-(CGRect)getNetworkAndCommunicationButtonFrame {
    //TODO return the correct frame
    return CGRectZero;
}

/**
 * Get the frame for the others button
 * @return CGRect
 */
-(CGRect)getOtherButtonFrame {
    //TODO return the correct frame
    return CGRectZero;
}

#pragma mark - instantiation
/**
 * Lazily init the living room button
 * @return living room button
 */
-(UIButton *)livingRoomButton {
    if (_livingRoomButton == nil) {
        _livingRoomButton = [[UIButton alloc] initWithFrame:[self getLivingRoomButtonFrame]];
        [_livingRoomButton setBackgroundImage:[UIImage imageNamed:LIVINGROOM_BACKGROUND] forState:UIControlStateNormal];
        [_livingRoomButton setImage:[UIImage imageNamed:LIVINGROOM_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_livingRoomButton setImage:[UIImage imageNamed:LIVINGROOM_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_livingRoomButton addTarget:self action:@selector(livingRoomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _livingRoomButton;
}

/**
 * Lazily init the bedroom button
 * @return bedroom button
 */
-(UIButton *)bedroomButton {
    if (_bedroomButton == nil) {
        _bedroomButton = [[UIButton alloc] initWithFrame:[self getBedroomButtonFrame]];
        [_bedroomButton setBackgroundImage:[UIImage imageNamed:BEDROOM_BACKGROUND] forState:UIControlStateNormal];
        [_bedroomButton setImage:[UIImage imageNamed:BEDROOM_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_bedroomButton setImage:[UIImage imageNamed:BEDROOM_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_bedroomButton addTarget:self action:@selector(bedroomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bedroomButton;
}

/**
 * Lazily init the bathroom button
 * @return bathroom button
 */
-(UIButton *)bathroomButton {
    if (_bathroomButton == nil) {
        _bathroomButton = [[UIButton alloc] initWithFrame:[self getBathroomButtonFrame]];
        [_bathroomButton setBackgroundImage:[UIImage imageNamed:BATHROOM_BACKGROUND] forState:UIControlStateNormal];
        [_bathroomButton setImage:[UIImage imageNamed:BATHROOM_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_bathroomButton setImage:[UIImage imageNamed:BATHROOM_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_bathroomButton addTarget:self action:@selector(bathroomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bathroomButton;
}

/**
 * Lazily init the kitchen and dining room button
 * @return kitchen and dining room button
 */
-(UIButton *)kitchenAndDiningRoomButton {
    if (_kitchenAndDiningRoomButton == nil) {
        _kitchenAndDiningRoomButton = [[UIButton alloc] initWithFrame:[self getKitchenAndDiningRoomButtomFrame]];
        [_kitchenAndDiningRoomButton setBackgroundImage:[UIImage imageNamed:KITCHEN_AND_DINING_ROOM_BACKGROUND] forState:UIControlStateNormal];
        [_kitchenAndDiningRoomButton setImage:[UIImage imageNamed:KITCHEN_AND_DINING_ROOM_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_kitchenAndDiningRoomButton setImage:[UIImage imageNamed:KITCHEN_AND_DINING_ROOM_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_kitchenAndDiningRoomButton addTarget:self action:@selector(kitchenAndDiningRoomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kitchenAndDiningRoomButton;
}

/**
 * Lazily init the communication button
 * @return communication button
 */
-(UIButton *)communicationButton {
    if (_communicationButton == nil) {
        _communicationButton = [[UIButton alloc] initWithFrame:[self getNetworkAndCommunicationButtonFrame]];
        [_communicationButton setBackgroundImage:[UIImage imageNamed:NETWORK_AND_COMMUNICATION_BACKGROUND] forState:UIControlStateNormal];
        [_communicationButton setImage:[UIImage imageNamed:NETWORK_AND_COMMUNICATION_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_communicationButton setImage:[UIImage imageNamed:NETWORK_AND_COMMUNICATION_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_communicationButton addTarget:self action:@selector(networkAndCommunicationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _communicationButton;
}

/**
 * Lazily init the others button
 * @return others button
 */
-(UIButton *)othersButton {
    if (_othersButton == nil) {
        _othersButton = [[UIButton alloc] initWithFrame:[self getOtherButtonFrame]];
        [_othersButton setBackgroundImage:[UIImage imageNamed:OTHERS_BACKGROUND] forState:UIControlStateNormal];
        [_othersButton setImage:[UIImage imageNamed:OTHERS_ICON_STATE_NORMAL] forState:UIControlStateNormal];
        [_othersButton setImage:[UIImage imageNamed:OTHERS_ICON_STATE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_othersButton addTarget:self action:@selector(othersButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _othersButton;
}

#pragma mark - buttons actions
/**
 * Call the delegate to handle the action when the living room button is pressed
 */
-(void)livingRoomButtonPressed {
    [self.planDelegate onLivingRoomItemClicked];
}

/**
 * Call the delegate to handle the action when the bedroom button is pressed
 */
-(void)bedroomButtonPressed {
    [self.planDelegate onBedroomItemClick];
}

/**
 * Call the delegate to handle the action when the bathroom button is pressed
 */
-(void)bathroomButtonPressed {
    [self.planDelegate onBathroomItemClick];
}

/**
 * Call the delegate to handle the action when the kitchen/dining room button is pressed
 */
-(void)kitchenAndDiningRoomButtonPressed {
    [self.planDelegate onKitchenAndDiningItemClick];
}

/**
 * Call the delegate to handle the action when the network and communication button is pressed
 */
-(void)networkAndCommunicationButtonPressed {
    [self.planDelegate onNetworkAndCommunicationItemClick];
}

/**
 * call the delegate to handle the action when the others button is pressed
 */
-(void)othersButtonPressed {
    [self.planDelegate onOthersClick];
}

#pragma mark - initation
/**
 * Init with the frame
 * @param frame
 */
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWitdh = CGRectGetWidth(frame);
        self.viewHeight = CGRectGetHeight(frame);
        
        [self addSubview:[self livingRoomButton]];
        [self addSubview:[self bedroomButton]];
        [self addSubview:[self bathroomButton]];
        [self addSubview:[self kitchenAndDiningRoomButton]];
        [self addSubview:[self communicationButton]];
        [self addSubview:[self othersButton]];
    }
    return self;
}

/**
 * Empty init method. Then basically make it fill the entire screen
 */
-(id)init {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    return [self initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
}

@end
