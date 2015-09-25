//
//  PythonParsingRequest.h
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

@interface PythonParsingRequest : NSObject
+(void)getCurrentAppVersion:(void (^)(NSString *appVersion))appVersion;
+(void)getAirbnbPropertyInfoForPropertyWithPid:(NSString *)pid andSourceCode:(NSString *)sourceCode withCompletionHandler:(void (^)(Property *property))completionHandler;
+(void)getAirbnbPidsInSourceCode:(NSString *)sourceCode withCompletionHandler:(void (^)(NSArray *pids))completionHandler;
+(void)getUserImportPropertyWithJson:(NSDictionary *)source andPid:(NSString *)pid withCompletionHandler:(void (^)(Property *property))completionHandler;
@end
