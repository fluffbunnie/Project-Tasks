//
//  PythonParsingRequest.m
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PythonParsingRequest.h"
#import "Property.h"
#import "AFNetworking.h"

@implementation PythonParsingRequest
/**
 * Get the current app version
 * @param Completion hander
 */
+(void)getCurrentAppVersion:(void (^)(NSString *version))appVersion {
    NSString *url = @"http://minhthao.pythonanywhere.com/ios/version";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *response = (NSDictionary *)responseObject;
            if (response[@"response"]) appVersion(response[@"response"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

/**
 * Get the airbnb property info given its pid and source code
 * @param NSString
 * @param NSString
 * @param Completion handler
 */
+(void)getAirbnbPropertyInfoForPropertyWithPid:(NSString *)pid andSourceCode:(NSString *)sourceCode withCompletionHandler:(void (^)(Property *property))completionHandler {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    @try {
        NSString *url = [NSString stringWithFormat:@"http://minhthao.pythonanywhere.com/api/airbnb/property/info/%@", pid];
        //NSString *url = [NSString stringWithFormat:@"http://minhthao.pythonanywhere.com/api/airbnb/property/newinfo/%@", pid];
        
        NSData *data = [sourceCode dataUsingEncoding:NSUTF8StringEncoding];
        NSString *dataLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
        
        [request setURL:[NSURL URLWithString:url]];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
    } @finally {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer new];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler([[Property alloc] initWithPythonDictionary:responseObject]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionHandler(nil);
        }];
        [operation start];
    }
}

/**
 * Get the user's property ids from the given source code from the webview
 * @param uid
 * @param Completion handler
 */
+(void)getAirbnbPidsInSourceCode:(NSString *)sourceCode withCompletionHandler:(void (^)(NSArray *pids))completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    @try {
        NSString *url = @"http://minhthao.pythonanywhere.com/api/airbnb/user-property/pids";
        
        NSData *data = [sourceCode dataUsingEncoding:NSUTF8StringEncoding];
        NSString *dataLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
        
        [request setURL:[NSURL URLWithString:url]];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
    } @finally {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer new];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler(responseObject[@"response"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completionHandler(nil);
        }];
        [operation start];
    }
}

/**
 * Get the airbnb property info given its json
 * @param JSON
 * @param Completion handler
 */
+(void)getUserImportPropertyWithJson:(NSDictionary *)source andPid:(NSString *)pid withCompletionHandler:(void (^)(Property *property))completionHandler{
    NSString *url = [NSString stringWithFormat:@"http://minhthao.pythonanywhere.com/api/airbnb/property/newinfo/%@", pid];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:source success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler([[Property alloc] initWithPythonDictionary:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(nil);
    }];
}

@end
