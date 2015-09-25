//
//  Amenity.m
//  Magpie
//
//  Created by minh thao nguyen on 5/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "Amenity.h"
#import "AmenityItem.h"

#pragma mark - icon
NSString * const SECTION_BATHROOM_HIGHLIGHT_ICON = @"HousingLayoutBathroomHighlight";
NSString * const SECTION_BATHROOM_NORMAL_ICON = @"HousingLayoutBathroomNormal";
NSString * const SECTION_BEDROOM_HIGHLIGHT_ICON = @"HousingLayoutBedroomHighlight";
NSString * const SECTION_BEDROOM_NORMAL_ICON = @"HousingLayoutBedroomNormal";
NSString * const SECTION_GENERAL_HIGHLIGHT_ICON = @"HousingLayoutHomeHighlight";
NSString * const SECTION_GENERAL_NORMAL_ICON = @"HousingLayoutHomeNormal";
NSString * const SECTION_KITCHEN_HIGHLIGHT_ICON = @"HousingLayoutKitchenHighlight";
NSString * const SECTION_KITCHEN_NORMAL_ICON = @"HousingLayoutKitchenNormal";
NSString * const SECTION_LIVINGROOM_HIGHLIGHT_ICON = @"HousingLayoutLivingroomHighlight";
NSString * const SECTION_LIVINGROOM_NORMAL_ICON = @"HousingLayoutLivingroomNormal";

NSString * const BATHROOM_TOWEL_HIGHLIGHT_ICON = @"BathroomTowelHighlight";
NSString * const BATHROOM_TOWEL_NORMAL_ICON = @"BathroomTowelNormal";
NSString * const BATHROOM_TOILET_PAPER_HIGHLIGHT_ICON = @"BathroomToiletPaperHighlight";
NSString * const BATHROOM_TOILET_PAPER_NORMAL_ICON = @"BathroomToiletPaperNormal";
NSString * const BATHROOM_SHAMPOO_HIGHLIGHT_ICON = @"BathroomShampooHighlight";
NSString * const BATHROOM_SHAMPOO_NORMAL_ICON = @"BathroomShampooNormal";
NSString * const BATHROOM_HOT_SHOWER_HIGHLIGHT_ICON = @"BathroomHotShowerHighlight";
NSString * const BATHROOM_HOT_SHOWER_NORMAL_ICON = @"BathroomHotShowerNormal";
NSString * const BATHROOM_HAIR_DRYER_HIGHLIGHT_ICON = @"BathroomHairDryerHighlight";
NSString * const BATHROOM_HAIR_DRYER_NORMAL_ICON = @"BathroomHairDryerNormal";
NSString * const BATHROOM_FIRST_AID_HIGHLIGHT_ICON = @"BathroomFirstAidKitHighlight";
NSString * const BATHROOM_FIRST_AID_NORMAL_ICON = @"BathroomFirstAidKitNormal";

NSString * const BEDROOM_BED_HIGHLIGHT_ICON = @"BedroomBedHighlight";
NSString * const BEDROOM_BED_NORMAL_ICON = @"BedroomBedNormal";
NSString * const BEDROOM_CLOSET_HIGHLIGHT_ICON = @"BedroomClosetHighlight";
NSString * const BEDROOM_CLOSET_NORMAL_ICON = @"BedroomClosetNormal";
NSString * const BEDROOM_TV_HIGHLIGHT_ICON = @"BedroomTVHighlight";
NSString * const BEDROOM_TV_NORMAL_ICON = @"BedroomTVNormal";

NSString * const GENERAL_INTERNET_HIGHLIGHT_ICON = @"GeneralInternetHighlight";
NSString * const GENERAL_INTERNET_NORMAL_ICON = @"GeneralInternetNormal";
NSString * const GENERAL_AIR_CONDITIONING_HIGHLIGHT_ICON = @"GeneralAirConditioningHighlight";
NSString * const GENERAL_AIR_CONDITIONING_NORMAL_ICON = @"GeneralAirConditioningNormal";
NSString * const GENERAL_HEATING_HIGHLIGHT_ICON = @"GeneralHeatingHighlight";
NSString * const GENERAL_HEATING_NORMAL_ICON = @"GeneralHeatingNormal";
NSString * const GENERAL_WASHER_HIGHLIGHT_ICON = @"GeneralWasherHighlight";
NSString * const GENERAL_WASHER_NORMAL_ICON = @"GeneralWasherNormal";
NSString * const GENERAL_DRYER_HIGHLIGHT_ICON = @"GeneralDryerHighlight";
NSString * const GENERAL_DRYER_NORMAL_ICON = @"GeneralDryerNormal";
NSString * const GENERAL_FAMILY_FRIENDLY_HIGHLIGHT_ICON = @"GeneralFamilyFriendlyHighlight";
NSString * const GENERAL_FAMILY_FRIENDLY_NORMAL_ICON = @"GeneralFamilyFriendlyNormal";
NSString * const GENERAL_PET_ALLOWED_HIGHLIGHT_ICON = @"GeneralPetHighlight";
NSString * const GENERAL_PET_ALLOWED_NORMAL_ICON = @"GeneralPetNormal";
NSString * const GENERAL_NO_SMOKING_HIGHLIGHT_ICON = @"GeneralNoSmokingHighlight";
NSString * const GENERAL_NO_SMOKING_NORMAL_ICON = @"GeneralNoSmokingNormal";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_HIGHLIGHT_ICON = @"GeneralWheelchairAccessibleHighlight";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_NORMAL_ICON = @"GeneralWheelchairAccessibleNormal";
NSString * const GENERAL_GYM_HIGHLIGHT_ICON = @"GeneralGymHighlight";
NSString * const GENERAL_GYM_NORMAL_ICON = @"GeneralGymNormal";
NSString * const GENERAL_HOT_TUB_HIGHLIGHT_ICON = @"GeneralHotTubHighlight";
NSString * const GENERAL_HOT_TUB_NORMAL_ICON = @"GeneralHotTubNormal";
NSString * const GENERAL_POOL_HIGHLIGHT_ICON = @"GeneralPoolHighlight";
NSString * const GENERAL_POOL_NORMAL_ICON = @"GeneralPoolNormal";

NSString * const KITCHEN_MICROWAVE_HIGHLIGHT_ICON = @"KitchenMicrowaveHighlight";
NSString * const KITCHEN_MICROWAVE_NORMAL_ICON = @"KitchenMicrowaveNormal";
NSString * const KITCHEN_REFRIGERATOR_HIGHLIGHT_ICON = @"KitchenRefrigeratorHighlight";
NSString * const KITCHEN_REFRIGERATOR_NORMAL_ICON = @"KitchenRefrigeratorNormal";
NSString * const KITCHEN_TOASTER_HIGHLIGHT_ICON = @"KitchenToasterHighlight";
NSString * const KITCHEN_TOASTER_NORMAL_ICON = @"KitchenToasterNormal";
NSString * const KITCHEN_SILVERWARE_HIGHLIGHT_ICON = @"KitchenSilverwareHighlight";
NSString * const KITCHEN_SILVERWARE_NORMAL_ICON = @"KitchenSilverwareNormal";
NSString * const KITCHEN_DISHWARE_HIGHLIGHT_ICON = @"KitchenDishwareHighlight";
NSString * const KITCHEN_DISHWARE_NORMAL_ICON = @"KitchenDishwareNormal";
NSString * const KITCHEN_OVEN_HIGHLIGHT_ICON = @"KitchenOvenHighlight";
NSString * const KITCHEN_OVEN_NORMAL_ICON = @"KitchenOvenNormal";
NSString * const KITCHEN_COFFEE_MAKER_HIGHLIGHT_ICON = @"KitchenCoffeeMakerHighlight";
NSString * const KITCHEN_COFFEE_MAKER_NORMAL_ICON = @"KitchenCoffeeMakerNormal";
NSString * const KITCHEN_DINING_TABLE_HIGHLIGHT_ICON = @"KitchenDiningTableHighlight";
NSString * const KITCHEN_DINING_TABLE_NORMAL_ICON = @"KitchenDiningTableNormal";
NSString * const KITCHEN_SMOKE_DETECTOR_HIGHLIGHT_ICON = @"KitchenSmokeDetectorHighlight";
NSString * const KITCHEN_SMOKE_DETECTOR_NORMAL_ICON = @"KitchenSmokeDetectorNormal";

NSString * const LIVINGROOM_FIREPLACE_HIGHLIGHT_ICON = @"LivingroomFireplaceHighlight";
NSString * const LIVINGROOM_FIREPLACE_NORMAL_ICON = @"LivingroomFireplaceNormal";
NSString * const LIVINGROOM_SOFA_HIGHLIGHT_ICON = @"LivingroomSofaHighlight";
NSString * const LIVINGROOM_SOFA_NORMAL_ICON = @"LivingroomSofaNormal";
NSString * const LIVINGROOM_TV_HIGHLIGHT_ICON = @"LivingroomTVHighlight";
NSString * const LIVINGROOM_TV_NORMAL_ICON = @"LivingroomTVNormal";

#pragma mark - id
NSString * const BATHROOM_TOWEL_ID = @"bathroomTowel";
NSString * const BATHROOM_TOILET_PAPER_ID = @"bathroomToiletPaper";
NSString * const BATHROOM_SHAMPOO_ID = @"bathroomShampoo";
NSString * const BATHROOM_HOT_SHOWER_ID = @"bathroomHotShower";
NSString * const BATHROOM_HAIR_DRYER_ID = @"bathroomHairDryer";
NSString * const BATHROOM_FIRST_AID_ID = @"bathroomFirstAidKit";

NSString * const BEDROOM_BED_ID = @"bedroomBed";
NSString * const BEDROOM_CLOSET_ID = @"bedroomCloset";
NSString * const BEDROOM_TV_ID = @"bedroomTV";

NSString * const GENERAL_INTERNET_ID = @"generalInternet";
NSString * const GENERAL_AIR_CONDITIONING_ID = @"generalAirConditioning";
NSString * const GENERAL_HEATING_ID = @"generalHeating";
NSString * const GENERAL_WASHER_ID = @"generalWasher";
NSString * const GENERAL_DRYER_ID = @"generalDryer";
NSString * const GENERAL_FAMILY_FRIENDLY_ID = @"generalFamilyFriendly";
NSString * const GENERAL_PET_ALLOWED_ID = @"generalPetAllowed";
NSString * const GENERAL_NO_SMOKING_ID = @"generalSmokingNotAllowed";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_ID = @"generalWheelchairAccessible";
NSString * const GENERAL_GYM_ID = @"generalGym";
NSString * const GENERAL_HOT_TUB_ID = @"generalHotTub";
NSString * const GENERAL_POOL_ID = @"generalPool";

NSString * const KITCHEN_MICROWAVE_ID = @"kitchenMicrowave";
NSString * const KITCHEN_REFRIGERATOR_ID = @"kitchenRefrigerator";
NSString * const KITCHEN_TOASTER_ID = @"kitchenToaster";
NSString * const KITCHEN_SILVERWARE_ID = @"kitchenSilverware";
NSString * const KITCHEN_DISHWARE_ID = @"kitchenDishware";
NSString * const KITCHEN_OVEN_ID = @"kitchenOven";
NSString * const KITCHEN_COFFEE_MAKER_ID = @"kitchenCoffeeMaker";
NSString * const KITCHEN_DINING_TABLE_ID = @"kitchenDiningTable";
NSString * const KITCHEN_SMOKE_DETECTOR_ID = @"kitchenSmokeDetector";

NSString * const LIVINGROOM_FIREPLACE_ID = @"livingRoomFireplace";
NSString * const LIVINGROOM_SOFA_ID = @"livingRoomSofa";
NSString * const LIVINGROOM_TV_ID = @"livingRoomTV";

#pragma mark - description id
NSString * const BATHROOM_TOWEL_DESCRIPTION_ID = @"bathroomTowelDescription";
NSString * const BATHROOM_TOILET_PAPER_DESCRIPTION_ID = @"bathroomToiletPaperDescription";
NSString * const BATHROOM_SHAMPOO_DESCRIPTION_ID = @"bathroomShampooDescription";
NSString * const BATHROOM_HOT_SHOWER_DESCRIPTION_ID = @"bathroomHotShowerDescription";
NSString * const BATHROOM_HAIR_DRYER_DESCRIPTION_ID = @"bathroomHairDryerDescription";
NSString * const BATHROOM_FIRST_AID_DESCRIPTION_ID = @"bathroomFirstAidKitDescription";

NSString * const BEDROOM_BED_DESCRIPTION_ID = @"bedroomBedDescription";
NSString * const BEDROOM_CLOSET_DESCRIPTION_ID = @"bedroomClosetDescription";
NSString * const BEDROOM_TV_DESCRIPTION_ID = @"bedroomTVDescription";

NSString * const GENERAL_INTERNET_DESCRIPTION_ID = @"generalInternetDescription";
NSString * const GENERAL_AIR_CONDITIONING_DESCRIPTION_ID = @"generalAirConditioningDescription";
NSString * const GENERAL_HEATING_DESCRIPTION_ID = @"generalHeatingDescription";
NSString * const GENERAL_WASHER_DESCRIPTION_ID = @"generalWasherDescription";
NSString * const GENERAL_DRYER_DESCRIPTION_ID = @"generalDryerDescription";
NSString * const GENERAL_FAMILY_FRIENDLY_DESCRIPTION_ID = @"generalFamilyFriendlyDescription";
NSString * const GENERAL_PET_ALLOWED_DESCRIPTION_ID = @"generalPetAllowedDescription";
NSString * const GENERAL_NO_SMOKING_DESCRIPTION_ID = @"generalSmokingNotAllowedDescription";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_DESCRIPTION_ID = @"generalWheelchairAccessibleDescription";
NSString * const GENERAL_GYM_DESCRIPTION_ID = @"generalGymDescription";
NSString * const GENERAL_HOT_TUB_DESCRIPTION_ID = @"generalHotTubDescription";
NSString * const GENERAL_POOL_DESCRIPTION_ID = @"generalPoolDescription";

NSString * const KITCHEN_MICROWAVE_DESCRIPTION_ID = @"kitchenMicrowaveDescription";
NSString * const KITCHEN_REFRIGERATOR_DESCRIPTION_ID = @"kitchenRefrigeratorDescription";
NSString * const KITCHEN_TOASTER_DESCRIPTION_ID = @"kitchenToasterDescription";
NSString * const KITCHEN_SILVERWARE_DESCRIPTION_ID = @"kitchenSilverwareDescription";
NSString * const KITCHEN_DISHWARE_DESCRIPTION_ID = @"kitchenDishwareDescription";
NSString * const KITCHEN_OVEN_DESCRIPTION_ID = @"kitchenOvenDescription";
NSString * const KITCHEN_COFFEE_MAKER_DESCRIPTION_ID = @"kitchenCoffeeMakerDescription";
NSString * const KITCHEN_DINING_TABLE_DESCRIPTION_ID = @"kitchenDiningTableDescription";
NSString * const KITCHEN_SMOKE_DETECTOR_DESCRIPTION_ID = @"kitchenSmokeDetectorDescription";

NSString * const LIVINGROOM_FIREPLACE_DESCRIPTION_ID = @"livingRoomFireplaceDescription";
NSString * const LIVINGROOM_SOFA_DESCRIPTION_ID = @"livingRoomSofaDescription";
NSString * const LIVINGROOM_TV_DESCRIPTION_ID = @"livingRoomTVDescription";

#pragma mark - name
NSString * const BATHROOM_TOWEL_NAME = @"Towel";
NSString * const BATHROOM_TOILET_PAPER_NAME = @"Toilet paper";
NSString * const BATHROOM_SHAMPOO_NAME = @"Toiletries";
NSString * const BATHROOM_HOT_SHOWER_NAME = @"Hot shower";
NSString * const BATHROOM_HAIR_DRYER_NAME = @"Hair dryer";
NSString * const BATHROOM_FIRST_AID_NAME = @"First aid kit";

NSString * const BEDROOM_BED_NAME = @"Bedding & pillows";
NSString * const BEDROOM_CLOSET_NAME = @"Closet";
NSString * const BEDROOM_TV_NAME = @"TV";

NSString * const GENERAL_INTERNET_NAME = @"Internet";
NSString * const GENERAL_AIR_CONDITIONING_NAME = @"Air conditioning";
NSString * const GENERAL_HEATING_NAME = @"Heating";
NSString * const GENERAL_WASHER_NAME = @"Washer";
NSString * const GENERAL_DRYER_NAME = @"Dryer";
NSString * const GENERAL_FAMILY_FRIENDLY_NAME = @"Family friendly";
NSString * const GENERAL_PET_ALLOWED_NAME = @"Pet allowed";
NSString * const GENERAL_NO_SMOKING_NAME = @"Smoking not allowed";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_NAME = @"Wheelchair accessible";
NSString * const GENERAL_GYM_NAME = @"Gym";
NSString * const GENERAL_HOT_TUB_NAME = @"Hot tub";
NSString * const GENERAL_POOL_NAME = @"Pool";

NSString * const KITCHEN_MICROWAVE_NAME = @"Microwave";
NSString * const KITCHEN_REFRIGERATOR_NAME = @"Refrigerator";
NSString * const KITCHEN_TOASTER_NAME = @"Toaster";
NSString * const KITCHEN_SILVERWARE_NAME = @"Silverware";
NSString * const KITCHEN_DISHWARE_NAME = @"Dishes";
NSString * const KITCHEN_OVEN_NAME = @"Oven";
NSString * const KITCHEN_COFFEE_MAKER_NAME = @"Coffee maker";
NSString * const KITCHEN_DINING_TABLE_NAME = @"Dining table";
NSString * const KITCHEN_SMOKE_DETECTOR_NAME = @"Smoke detector";

NSString * const LIVINGROOM_FIREPLACE_NAME = @"Fireplace";
NSString * const LIVINGROOM_SOFA_NAME = @"Sofa";
NSString * const LIVINGROOM_TV_NAME = @"TV";

#pragma mark - default active text
NSString * const BATHROOM_TOWEL_DEFAULT_ACTIVE_TEXT = @"Extra bath towels for guests";
NSString * const BATHROOM_TOILET_PAPER_DEFAULT_ACTIVE_TEXT = @"Toilet paper available";
NSString * const BATHROOM_SHAMPOO_DEFAULT_ACTIVE_TEXT = @"Toiletries available for use";
NSString * const BATHROOM_HOT_SHOWER_DEFAULT_ACTIVE_TEXT = @"Hot shower available";
NSString * const BATHROOM_HAIR_DRYER_DEFAULT_ACTIVE_TEXT = @"Hair dryer available";
NSString * const BATHROOM_FIRST_AID_DEFAULT_ACTIVE_TEXT = @"First-aid kit provided";

NSString * const BEDROOM_BED_DEFAULT_ACTIVE_TEXT = @"Bedding & pillows provided";
NSString * const BEDROOM_CLOSET_DEFAULT_ACTIVE_TEXT = @"Closet available for use";
NSString * const BEDROOM_TV_DEFAULT_ACTIVE_TEXT = @"TV in the bedroom";

NSString * const GENERAL_INTERNET_DEFAULT_ACTIVE_TEXT = @"Free Internet";
NSString * const GENERAL_AIR_CONDITIONING_DEFAULT_ACTIVE_TEXT = @"AC available";
NSString * const GENERAL_HEATING_DEFAULT_ACTIVE_TEXT = @"Heating available";
NSString * const GENERAL_WASHER_DEFAULT_ACTIVE_TEXT = @"Washer on-site";
NSString * const GENERAL_DRYER_DEFAULT_ACTIVE_TEXT = @"Dryer on-site";
NSString * const GENERAL_FAMILY_FRIENDLY_DEFAULT_ACTIVE_TEXT = @"Kid-friendly & family-friendly";
NSString * const GENERAL_PET_ALLOWED_DEFAULT_ACTIVE_TEXT = @"Furry friends welcome";
NSString * const GENERAL_NO_SMOKING_DEFAULT_ACTIVE_TEXT = @"No smoking please!";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_DEFAULT_ACTIVE_TEXT = @"Wheelchair accessible";
NSString * const GENERAL_GYM_DEFAULT_ACTIVE_TEXT = @"Accessible gym";
NSString * const GENERAL_HOT_TUB_DEFAULT_ACTIVE_TEXT = @"Hot tub available";
NSString * const GENERAL_POOL_DEFAULT_ACTIVE_TEXT = @"Outdoor pool";

NSString * const KITCHEN_MICROWAVE_DEFAULT_ACTIVE_TEXT = @"Microwave available";
NSString * const KITCHEN_REFRIGERATOR_DEFAULT_ACTIVE_TEXT = @"Fridge available";
NSString * const KITCHEN_TOASTER_DEFAULT_ACTIVE_TEXT = @"Toaster available";
NSString * const KITCHEN_SILVERWARE_DEFAULT_ACTIVE_TEXT = @"Silverware available for use";
NSString * const KITCHEN_DISHWARE_DEFAULT_ACTIVE_TEXT = @"Dishes available for use";
NSString * const KITCHEN_OVEN_DEFAULT_ACTIVE_TEXT = @"Oven available";
NSString * const KITCHEN_COFFEE_MAKER_DEFAULT_ACTIVE_TEXT = @"Coffee maker available";
NSString * const KITCHEN_DINING_TABLE_DEFAULT_ACTIVE_TEXT = @"Dining table available";
NSString * const KITCHEN_SMOKE_DETECTOR_DEFAULT_ACTIVE_TEXT = @"Smoke detector available";

NSString * const LIVINGROOM_SOFA_DEFAULT_ACTIVE_TEXT = @"Sofa available";
NSString * const LIVINGROOM_FIREPLACE_DEFAULT_ACTIVE_TEXT = @"Fireplace available for use";
NSString * const LIVINGROOM_TV_DEFAULT_ACTIVE_TEXT = @"TV available";

#pragma mark - input nudge, placeholder when active
NSString * const BATHROOM_TOWEL_SELECTED_PLACEHOLDER_TEXT = @"Where can you find bath towels?";
NSString * const BATHROOM_TOILET_PAPER_SELECTED_PLACEHOLDER_TEXT = @"Where can you find toilet paper?";
NSString * const BATHROOM_SHAMPOO_SELECTED_PLACEHOLDER_TEXT = @"Where can you find toiletries?";
NSString * const BATHROOM_HOT_SHOWER_SELECTED_PLACEHOLDER_TEXT = @"Describe your hot shower situation.";
NSString * const BATHROOM_HAIR_DRYER_SELECTED_PLACEHOLDER_TEXT = @"Where can you find the hair dryer?";
NSString * const BATHROOM_FIRST_AID_SELECTED_PLACEHOLDER_TEXT = @"Where can you find the first-aid kit?";

NSString * const BEDROOM_BED_SELECTED_PLACEHOLDER_TEXT = @"Where can you find bedding & pillows?";
NSString * const BEDROOM_CLOSET_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for closet usage?";
NSString * const BEDROOM_TV_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for watching TV?";

NSString * const GENERAL_INTERNET_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for using the internet?";
NSString * const GENERAL_AIR_CONDITIONING_SELECTED_PLACEHOLDER_TEXT = @"Set rules for AC temps.";
NSString * const GENERAL_HEATING_SELECTED_PLACEHOLDER_TEXT = @"Set rules for heater usage.";
NSString * const GENERAL_WASHER_SELECTED_PLACEHOLDER_TEXT = @"How does you wash clothes?";
NSString * const GENERAL_DRYER_SELECTED_PLACEHOLDER_TEXT = @"How does you dry clothes?";
NSString * const GENERAL_FAMILY_FRIENDLY_SELECTED_PLACEHOLDER_TEXT = @"Describe your pad's family friendliness.";
NSString * const GENERAL_PET_ALLOWED_SELECTED_PLACEHOLDER_TEXT = @"Rules for furry friends?";
NSString * const GENERAL_NO_SMOKING_SELECTED_PLACEHOLDER_TEXT = @"Rules regarding smoking?";
NSString * const GENERAL_WHEELCHAIR_ACCESSIBLE_SELECTED_PLACEHOLDER_TEXT = @"Describe the wheelchair accessibility.";
NSString * const GENERAL_GYM_SELECTED_PLACEHOLDER_TEXT = @"How do you access the gym?";
NSString * const GENERAL_HOT_TUB_SELECTED_PLACEHOLDER_TEXT = @"Rules for using the hot tub?";
NSString * const GENERAL_POOL_SELECTED_PLACEHOLDER_TEXT = @"Rules for using the outdoor pool?";

NSString * const KITCHEN_MICROWAVE_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for microwave usage?";
NSString * const KITCHEN_REFRIGERATOR_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for fridge usage?";
NSString * const KITCHEN_TOASTER_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for toaster usage?";
NSString * const KITCHEN_SILVERWARE_SELECTED_PLACEHOLDER_TEXT = @"Where can you find silverware?";
NSString * const KITCHEN_DISHWARE_SELECTED_PLACEHOLDER_TEXT = @"Where can you find dishes?";
NSString * const KITCHEN_OVEN_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for oven usage?";
NSString * const KITCHEN_COFFEE_MAKER_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for using the coffee maker?";
NSString * const KITCHEN_DINING_TABLE_SELECTED_PLACEHOLDER_TEXT = @"Guidelines for using the dining table?";
NSString * const KITCHEN_SMOKE_DETECTOR_SELECTED_PLACEHOLDER_TEXT = @"Describe your smoke detector situation.";

NSString * const LIVINGROOM_SOFA_SELECTED_PLACEHOLDER_TEXT = @"Rules for using the sofa?";
NSString * const LIVINGROOM_FIREPLACE_SELECTED_PLACEHOLDER_TEXT = @"Rules for using the fireplace?";
NSString * const LIVINGROOM_TV_SELECTED_PLACEHOLDER_TEXT = @"How can your guest use the TV?";


@implementation Amenity

#pragma mark - public method
+(PFObject *)newAmenityObj {
    PFObject *amenityObj = [PFObject objectWithClassName:@"Amenity"];
    amenityObj[BATHROOM_TOILET_PAPER_ID] = @NO;
    amenityObj[BATHROOM_TOILET_PAPER_DESCRIPTION_ID] = @"";
    amenityObj[BATHROOM_TOWEL_ID] = @NO;
    amenityObj[BATHROOM_TOWEL_DESCRIPTION_ID] = @"";
    amenityObj[BATHROOM_HOT_SHOWER_ID] = @NO;
    amenityObj[BATHROOM_HOT_SHOWER_DESCRIPTION_ID] = @"";
    amenityObj[BATHROOM_SHAMPOO_ID] = @NO;
    amenityObj[BATHROOM_SHAMPOO_DESCRIPTION_ID] = @"";
    amenityObj[BATHROOM_HAIR_DRYER_ID] = @NO;
    amenityObj[BATHROOM_HAIR_DRYER_DESCRIPTION_ID] = @"";
    amenityObj[BATHROOM_FIRST_AID_ID] = @NO;
    amenityObj[BATHROOM_FIRST_AID_DESCRIPTION_ID] = @"";
    
    amenityObj[BEDROOM_BED_ID] = @NO;
    amenityObj[BEDROOM_BED_DESCRIPTION_ID] = @"";
    amenityObj[BEDROOM_CLOSET_ID] = @NO;
    amenityObj[BEDROOM_CLOSET_DESCRIPTION_ID] = @"";
    amenityObj[BEDROOM_TV_ID] = @NO;
    amenityObj[BEDROOM_TV_DESCRIPTION_ID] = @"";
    
    amenityObj[GENERAL_INTERNET_ID] = @NO;
    amenityObj[GENERAL_INTERNET_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_AIR_CONDITIONING_ID] = @NO;
    amenityObj[GENERAL_AIR_CONDITIONING_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_HEATING_ID] = @NO;
    amenityObj[GENERAL_HEATING_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_WASHER_ID] = @NO;
    amenityObj[GENERAL_WASHER_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_DRYER_ID] = @NO;
    amenityObj[GENERAL_DRYER_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_FAMILY_FRIENDLY_ID] = @NO;
    amenityObj[GENERAL_FAMILY_FRIENDLY_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_PET_ALLOWED_ID] = @NO;
    amenityObj[GENERAL_PET_ALLOWED_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_NO_SMOKING_ID] = @NO;
    amenityObj[GENERAL_NO_SMOKING_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_ID] = @NO;
    amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_GYM_ID] = @NO;
    amenityObj[GENERAL_GYM_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_HOT_TUB_ID] = @NO;
    amenityObj[GENERAL_HOT_TUB_DESCRIPTION_ID] = @"";
    amenityObj[GENERAL_POOL_ID] = @NO;
    amenityObj[GENERAL_POOL_DESCRIPTION_ID] = @"";
    
    amenityObj[KITCHEN_MICROWAVE_ID] = @NO;
    amenityObj[KITCHEN_MICROWAVE_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_REFRIGERATOR_ID] = @NO;
    amenityObj[KITCHEN_REFRIGERATOR_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_SILVERWARE_ID] = @NO;
    amenityObj[KITCHEN_SILVERWARE_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_TOASTER_ID] = @NO;
    amenityObj[KITCHEN_TOASTER_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_OVEN_ID] = @NO;
    amenityObj[KITCHEN_OVEN_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_COFFEE_MAKER_ID] = @NO;
    amenityObj[KITCHEN_COFFEE_MAKER_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_DINING_TABLE_ID] = @NO;
    amenityObj[KITCHEN_DINING_TABLE_DESCRIPTION_ID] = @"";
    amenityObj[KITCHEN_SMOKE_DETECTOR_ID] = @NO;
    amenityObj[KITCHEN_SMOKE_DETECTOR_DESCRIPTION_ID] = @"";
    
    amenityObj[LIVINGROOM_TV_ID] = @NO;
    amenityObj[LIVINGROOM_TV_DESCRIPTION_ID] = @"";
    amenityObj[LIVINGROOM_SOFA_ID] = @NO;
    amenityObj[LIVINGROOM_SOFA_DESCRIPTION_ID] = @"";
    amenityObj[LIVINGROOM_FIREPLACE_ID] = @NO;
    amenityObj[LIVINGROOM_FIREPLACE_DESCRIPTION_ID] = @"";
    
    return amenityObj;
}

#pragma mark - static method
/**
 * Get the bathroom towels amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomTowelAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_TOWEL_ID;
    amenity.amenityName = BATHROOM_TOWEL_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_TOWEL_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_TOWEL_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_TOWEL_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_TOWEL_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_TOWEL_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_TOWEL_ID] boolValue];
    return amenity;
}

/**
 * Get the bathroom toilet paper amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomToiletPaperAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_TOILET_PAPER_ID;
    amenity.amenityName = BATHROOM_TOILET_PAPER_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_TOILET_PAPER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_TOILET_PAPER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_TOILET_PAPER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_TOILET_PAPER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_TOILET_PAPER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_TOILET_PAPER_ID] boolValue];
    return amenity;
}

/**
 * Get the bathroom shampoo amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomShampooAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_SHAMPOO_ID;
    amenity.amenityName = BATHROOM_SHAMPOO_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_SHAMPOO_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_SHAMPOO_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_SHAMPOO_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_SHAMPOO_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_SHAMPOO_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_SHAMPOO_ID] boolValue];
    return amenity;
}

/**
 * Get the bathroom hot shower amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomHotShowerAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_HOT_SHOWER_ID;
    amenity.amenityName = BATHROOM_HOT_SHOWER_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_HOT_SHOWER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_HOT_SHOWER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_HOT_SHOWER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_HOT_SHOWER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_HOT_SHOWER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_HOT_SHOWER_ID] boolValue];
    return amenity;
}

/**
 * Get the bathroom hair dryer amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomHairDryerAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_HAIR_DRYER_ID;
    amenity.amenityName = BATHROOM_HAIR_DRYER_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_HAIR_DRYER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_HAIR_DRYER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_HAIR_DRYER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_HAIR_DRYER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_HAIR_DRYER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_HAIR_DRYER_ID] boolValue];
    return amenity;
}

/**
 * Get the bathroom toilet paper amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBathroomFirstAidAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BATHROOM_FIRST_AID_ID;
    amenity.amenityName = BATHROOM_FIRST_AID_NAME;
    amenity.amenityDescription = amenityObj[BATHROOM_FIRST_AID_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BATHROOM_FIRST_AID_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BATHROOM_FIRST_AID_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BATHROOM_FIRST_AID_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BATHROOM_FIRST_AID_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BATHROOM_FIRST_AID_ID] boolValue];
    return amenity;
}

/**
 * Get the bedroom bed amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBedroomBedAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BEDROOM_BED_ID;
    amenity.amenityName = BEDROOM_BED_NAME;
    amenity.amenityDescription = amenityObj[BEDROOM_BED_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BEDROOM_BED_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BEDROOM_BED_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BEDROOM_BED_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BEDROOM_BED_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BEDROOM_BED_ID] boolValue];
    return amenity;
}

/**
 * Get the bedroom closet amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBedroomClosetAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BEDROOM_CLOSET_ID;
    amenity.amenityName = BEDROOM_CLOSET_NAME;
    amenity.amenityDescription = amenityObj[BEDROOM_CLOSET_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BEDROOM_CLOSET_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BEDROOM_CLOSET_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BEDROOM_CLOSET_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BEDROOM_CLOSET_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BEDROOM_CLOSET_ID] boolValue];
    return amenity;
}

/**
 * Get the bedroom TV amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getBedroomTVAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = BEDROOM_TV_ID;
    amenity.amenityName = BEDROOM_TV_NAME;
    amenity.amenityDescription = amenityObj[BEDROOM_TV_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = BEDROOM_TV_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = BEDROOM_TV_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:BEDROOM_TV_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:BEDROOM_TV_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[BEDROOM_TV_ID] boolValue];
    return amenity;
}

/**
 * Get the general internet amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralInternetAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_INTERNET_ID;
    amenity.amenityName = GENERAL_INTERNET_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_INTERNET_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_INTERNET_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_INTERNET_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_INTERNET_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_INTERNET_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_INTERNET_ID] boolValue];
    return amenity;
}

/**
 * Get the general air conditioning amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralAirConditioningAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_AIR_CONDITIONING_ID;
    amenity.amenityName = GENERAL_AIR_CONDITIONING_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_AIR_CONDITIONING_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_AIR_CONDITIONING_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_AIR_CONDITIONING_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_AIR_CONDITIONING_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_AIR_CONDITIONING_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_AIR_CONDITIONING_ID] boolValue];
    return amenity;
}

/**
 * Get the general heating amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralHeatingAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_HEATING_ID;
    amenity.amenityName = GENERAL_HEATING_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_HEATING_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_HEATING_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_HEATING_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_HEATING_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_HEATING_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_HEATING_ID] boolValue];
    return amenity;
}

/**
 * Get the general washer amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralWasherAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_WASHER_ID;
    amenity.amenityName = GENERAL_WASHER_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_WASHER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_WASHER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_WASHER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_WASHER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_WASHER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_WASHER_ID] boolValue];
    return amenity;
}

/**
 * Get the general dryer amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralDryerAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_DRYER_ID;
    amenity.amenityName = GENERAL_DRYER_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_DRYER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_DRYER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_DRYER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_DRYER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_DRYER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_DRYER_ID] boolValue];
    return amenity;
}

/**
 * Get the general family friendly amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralFamilyFriendlyAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_FAMILY_FRIENDLY_ID;
    amenity.amenityName = GENERAL_FAMILY_FRIENDLY_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_FAMILY_FRIENDLY_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_FAMILY_FRIENDLY_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_FAMILY_FRIENDLY_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_FAMILY_FRIENDLY_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_FAMILY_FRIENDLY_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_FAMILY_FRIENDLY_ID] boolValue];
    return amenity;
}

/**
 * Get the general pet allowed amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralPetAllowedAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_PET_ALLOWED_ID;
    amenity.amenityName = GENERAL_PET_ALLOWED_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_PET_ALLOWED_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_PET_ALLOWED_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_PET_ALLOWED_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_PET_ALLOWED_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_PET_ALLOWED_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_PET_ALLOWED_ID] boolValue];
    return amenity;
}

/**
 * Get the general no smoking amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralNoSmokingAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_NO_SMOKING_ID;
    amenity.amenityName = GENERAL_NO_SMOKING_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_NO_SMOKING_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_NO_SMOKING_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_NO_SMOKING_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_NO_SMOKING_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_NO_SMOKING_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_NO_SMOKING_ID] boolValue];
    return amenity;
}

/**
 * Get the general wheelchair accessible amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralWheelchairAccessibleAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_WHEELCHAIR_ACCESSIBLE_ID;
    amenity.amenityName = GENERAL_WHEELCHAIR_ACCESSIBLE_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_WHEELCHAIR_ACCESSIBLE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_WHEELCHAIR_ACCESSIBLE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_WHEELCHAIR_ACCESSIBLE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_WHEELCHAIR_ACCESSIBLE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_ID] boolValue];
    return amenity;
}

/**
 * Get the general gym amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralGymAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_GYM_ID;
    amenity.amenityName = GENERAL_GYM_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_GYM_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_GYM_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_GYM_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_GYM_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_GYM_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_GYM_ID] boolValue];
    return amenity;
}

/**
 * Get the general hot tub amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralHotTubAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_HOT_TUB_ID;
    amenity.amenityName = GENERAL_HOT_TUB_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_HOT_TUB_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_HOT_TUB_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_HOT_TUB_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_HOT_TUB_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_HOT_TUB_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_HOT_TUB_ID] boolValue];
    return amenity;
}

/**
 * Get the general pool amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getGeneralPoolAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = GENERAL_POOL_ID;
    amenity.amenityName = GENERAL_POOL_NAME;
    amenity.amenityDescription = amenityObj[GENERAL_POOL_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = GENERAL_POOL_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = GENERAL_POOL_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:GENERAL_POOL_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:GENERAL_POOL_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[GENERAL_POOL_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen microwave amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenMicrowaveAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_MICROWAVE_ID;
    amenity.amenityName = KITCHEN_MICROWAVE_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_MICROWAVE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_MICROWAVE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_MICROWAVE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_MICROWAVE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_MICROWAVE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_MICROWAVE_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen refrigerator amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenRefrigeratorAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_REFRIGERATOR_ID;
    amenity.amenityName = KITCHEN_REFRIGERATOR_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_REFRIGERATOR_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_REFRIGERATOR_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_REFRIGERATOR_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_REFRIGERATOR_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_REFRIGERATOR_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_REFRIGERATOR_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen toaster amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenToasterAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_TOASTER_ID;
    amenity.amenityName = KITCHEN_TOASTER_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_TOASTER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_TOASTER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_TOASTER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_TOASTER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_TOASTER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_TOASTER_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen silverware amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenSilverwareAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_SILVERWARE_ID;
    amenity.amenityName = KITCHEN_SILVERWARE_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_SILVERWARE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_SILVERWARE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_SILVERWARE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_SILVERWARE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_SILVERWARE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_SILVERWARE_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen dishware amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenDishwareAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_DISHWARE_ID;
    amenity.amenityName = KITCHEN_DISHWARE_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_DISHWARE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_DISHWARE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_DISHWARE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_DISHWARE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_DISHWARE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_DISHWARE_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen oven amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenOvenAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_OVEN_ID;
    amenity.amenityName = KITCHEN_OVEN_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_OVEN_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_OVEN_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_OVEN_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_OVEN_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_OVEN_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_OVEN_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen coffee maker amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenCoffeeMakerAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_COFFEE_MAKER_ID;
    amenity.amenityName = KITCHEN_COFFEE_MAKER_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_COFFEE_MAKER_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_COFFEE_MAKER_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_COFFEE_MAKER_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_COFFEE_MAKER_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_COFFEE_MAKER_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_COFFEE_MAKER_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen dining table amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenDiningTableAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_DINING_TABLE_ID;
    amenity.amenityName = KITCHEN_DINING_TABLE_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_DINING_TABLE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_DINING_TABLE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_DINING_TABLE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_DINING_TABLE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_DINING_TABLE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_DINING_TABLE_ID] boolValue];
    return amenity;
}

/**
 * Get the kitchen smoke detector amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getKitchenSmokeDetectorAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = KITCHEN_SMOKE_DETECTOR_ID;
    amenity.amenityName = KITCHEN_SMOKE_DETECTOR_NAME;
    amenity.amenityDescription = amenityObj[KITCHEN_SMOKE_DETECTOR_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = KITCHEN_SMOKE_DETECTOR_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = KITCHEN_SMOKE_DETECTOR_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:KITCHEN_SMOKE_DETECTOR_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:KITCHEN_SMOKE_DETECTOR_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[KITCHEN_SMOKE_DETECTOR_ID] boolValue];
    return amenity;
}

/**
 * Get the livingroom fireplace amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getLivingroomFireplaceAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = LIVINGROOM_FIREPLACE_ID;
    amenity.amenityName = LIVINGROOM_FIREPLACE_NAME;
    amenity.amenityDescription = amenityObj[LIVINGROOM_FIREPLACE_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = LIVINGROOM_FIREPLACE_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = LIVINGROOM_FIREPLACE_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:LIVINGROOM_FIREPLACE_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:LIVINGROOM_FIREPLACE_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[LIVINGROOM_FIREPLACE_ID] boolValue];
    return amenity;
}

/**
 * Get the livingroom sofa amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getLivingroomSofaAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = LIVINGROOM_SOFA_ID;
    amenity.amenityName = LIVINGROOM_SOFA_NAME;
    amenity.amenityDescription = amenityObj[LIVINGROOM_SOFA_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = LIVINGROOM_SOFA_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = LIVINGROOM_SOFA_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:LIVINGROOM_SOFA_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:LIVINGROOM_SOFA_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[LIVINGROOM_SOFA_ID] boolValue];
    return amenity;
}

/**
 * Get the livingroom tv amenity item
 * @param PFObject
 * @return AmenityItem
 */
+(AmenityItem *)getLivingroomTVAmenity:(PFObject *)amenityObj {
    AmenityItem *amenity = [[AmenityItem alloc] init];
    amenity.amenityId = LIVINGROOM_TV_ID;
    amenity.amenityName = LIVINGROOM_TV_NAME;
    amenity.amenityDescription = amenityObj[LIVINGROOM_TV_DESCRIPTION_ID];
    amenity.amenityDefaultActiveText = LIVINGROOM_TV_DEFAULT_ACTIVE_TEXT;
    amenity.amenitySelectedPlaceholder = LIVINGROOM_TV_SELECTED_PLACEHOLDER_TEXT;
    amenity.amenityImageActive = [UIImage imageNamed:LIVINGROOM_TV_HIGHLIGHT_ICON];
    amenity.amenityImageInactive = [UIImage imageNamed:LIVINGROOM_TV_NORMAL_ICON];
    amenity.amenityEnabled = [amenityObj[LIVINGROOM_TV_ID] boolValue];
    return amenity;
}

#pragma mark - public methods
/**
 * Get the array of amenities in the bathroom section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getBathroomAmenities:(PFObject *)amenityObj {
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    [amenities addObject:[self getBathroomToiletPaperAmenity:amenityObj]];
    [amenities addObject:[self getBathroomTowelAmenity:amenityObj]];
    [amenities addObject:[self getBathroomHotShowerAmenity:amenityObj]];
    [amenities addObject:[self getBathroomShampooAmenity:amenityObj]];
    [amenities addObject:[self getBathroomHairDryerAmenity:amenityObj]];
    [amenities addObject:[self getBathroomFirstAidAmenity:amenityObj]];
    return amenities;
}

/**
 * Get the array of active amenities in the bathroom section
 * @param PFObject 
 * @return NSArray
 */
+(NSArray *)getBathroomActiveAmenities:(PFObject *)amenityObj {
    NSArray *allAmenities = [self getBathroomAmenities:amenityObj];
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    for (AmenityItem *item in allAmenities) {
        if (item.amenityEnabled) [amenities addObject:item];
    }
    return amenities;
}

/**
 * Get the array of amenities in the bedroom section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getBedroomAmenities:(PFObject *)amenityObj {
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    [amenities addObject:[self getBedroomBedAmenity:amenityObj]];
    [amenities addObject:[self getBedroomClosetAmenity:amenityObj]];
    [amenities addObject:[self getBedroomTVAmenity:amenityObj]];
    return amenities;
}

/**
 * Get the array of active amenities in the bedroom section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getBedroomActiveAmenities:(PFObject *)amenityObj {
    NSArray *allAmenities = [self getBedroomAmenities:amenityObj];
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    for (AmenityItem *item in allAmenities) {
        if (item.amenityEnabled) [amenities addObject:item];
    }
    return amenities;
}

/**
 * Get the array of amenities in the general section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getGeneralAmenities:(PFObject *)amenityObj {
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    [amenities addObject:[self getGeneralInternetAmenity:amenityObj]];
    [amenities addObject:[self getGeneralAirConditioningAmenity:amenityObj]];
    [amenities addObject:[self getGeneralHeatingAmenity:amenityObj]];
    [amenities addObject:[self getGeneralWasherAmenity:amenityObj]];
    [amenities addObject:[self getGeneralDryerAmenity:amenityObj]];
    [amenities addObject:[self getGeneralFamilyFriendlyAmenity:amenityObj]];
    [amenities addObject:[self getGeneralPetAllowedAmenity:amenityObj]];
    [amenities addObject:[self getGeneralNoSmokingAmenity:amenityObj]];
    [amenities addObject:[self getGeneralWheelchairAccessibleAmenity:amenityObj]];
    [amenities addObject:[self getGeneralGymAmenity:amenityObj]];
    [amenities addObject:[self getGeneralHotTubAmenity:amenityObj]];
    [amenities addObject:[self getGeneralPoolAmenity:amenityObj]];
    return amenities;
}

/**
 * Get the array of active amenities in the general section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getGeneralActiveAmenities:(PFObject *)amenityObj {
    NSArray *allAmenities = [self getGeneralAmenities:amenityObj];
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    for (AmenityItem *item in allAmenities) {
        if (item.amenityEnabled) [amenities addObject:item];
    }
    return amenities;
}

/**
 * Get the array of amenities in the kitchen section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getKitchenAmenities:(PFObject *)amenityObj {
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    [amenities addObject:[self getKitchenMicrowaveAmenity:amenityObj]];
    [amenities addObject:[self getKitchenRefrigeratorAmenity:amenityObj]];
    [amenities addObject:[self getKitchenToasterAmenity:amenityObj]];
    [amenities addObject:[self getKitchenSilverwareAmenity:amenityObj]];
    [amenities addObject:[self getKitchenDishwareAmenity:amenityObj]];
    [amenities addObject:[self getKitchenOvenAmenity:amenityObj]];
    [amenities addObject:[self getKitchenCoffeeMakerAmenity:amenityObj]];
    [amenities addObject:[self getKitchenDiningTableAmenity:amenityObj]];
    [amenities addObject:[self getKitchenSmokeDetectorAmenity:amenityObj]];
    return amenities;
}

/**
 * Get the array of active amenities in the kitchen section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getKitchenActiveAmenities:(PFObject *)amenityObj {
    NSArray *allAmenities = [self getKitchenAmenities:amenityObj];
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    for (AmenityItem *item in allAmenities) {
        if (item.amenityEnabled) [amenities addObject:item];
    }
    return amenities;
}

/**
 * Get the array of amenities in the livingroom section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getLivingroomAmenities:(PFObject *)amenityObj {
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    [amenities addObject:[self getLivingroomFireplaceAmenity:amenityObj]];
    [amenities addObject:[self getLivingroomSofaAmenity:amenityObj]];
    [amenities addObject:[self getLivingroomTVAmenity:amenityObj]];
    return amenities;
}

/**
 * Get the array of active amenities in the livingroom section
 * @param PFObject
 * @return NSArray
 */
+(NSArray *)getLivingroomActiveAmenities:(PFObject *)amenityObj {
    NSArray *allAmenities = [self getLivingroomAmenities:amenityObj];
    NSMutableArray *amenities = [[NSMutableArray alloc] init];
    for (AmenityItem *item in allAmenities) {
        if (item.amenityEnabled) [amenities addObject:item];
    }
    return amenities;
}


@end
