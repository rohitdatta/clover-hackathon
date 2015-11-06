//
//  AuthAPI.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "AuthAPI.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation AuthAPI

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)sendRequest:(NSDictionary *)request
                   toEndpoint:(NSString *)endpoint
                     withType:(NSString *)type {
    return [[[AuthAPI alloc] init] sendRequest:request toEndpoint:endpoint withType:type];
}

- (NSDictionary *)sendRequest:(NSDictionary *)request
                   toEndpoint:(NSString *)endpoint
                     withType:(NSString *)type {
    
    if ([type isEqualToString:@"POST"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSError *error = nil;
        NSDictionary *result = [manager syncPOST:[NSString stringWithFormat:@"http://10.0.1.223:5000/%@", endpoint]
                                      parameters:request
                                       operation:NULL
                                           error:&error];
        if (error){
            return @{@"error": error};
        }else {
            return result;
        }
        
    }else if ([type isEqualToString:@"GET"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSError *error = nil;
        NSDictionary *result = [manager syncGET:[NSString stringWithFormat:@"http://10.0.1.223:5000/%@", endpoint]
                                     parameters:request
                                      operation:NULL
                                          error:&error];
        
        return result;
        
    }else {
        return nil;
    }
}

@end
