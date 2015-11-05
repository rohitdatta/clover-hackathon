//
//  AuthAPI.h
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthAPI : NSObject

+ (NSDictionary *)sendRequest:(NSDictionary *)request
                   toEndpoint:(NSString *)endpoint
                     withType:(NSString *)type;

@end
