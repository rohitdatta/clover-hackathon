//
//  AuthScanner.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "AuthScanner.h"
#import "AuthAPI.h"
#import "User.h"
#import "FCUUID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation AuthScanner

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)validateFingerFromPush:(NSDictionary *)data {
    return [[[AuthScanner alloc] init] validateFingerFromPush:data];
}

- (NSDictionary *)validateFingerFromPush:(NSDictionary *)data {
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    NSLog(@"%@", data);
    NSString *reason = [NSString stringWithFormat:@"Does [%@] match the code on your screen? If so, scan!", data[@"code"]];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  NSLog(@"something went wrong");
                                  return;
                              }
                              
                              if (success) {
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                      RLMResults *users = [User allObjects];
                                      NSDictionary *response = [AuthAPI sendRequest:@{@"username": users[0][@"email"], @"uuid": [FCUUID uuidForDevice], @"one_time_code": data[@"code"]} toEndpoint:@"login/auth" withType:@"POST"];
                                      NSLog(@"%@", response);
                                  });
                                  
                              } else {
                                  NSLog(@"incorrect finger rpint");
                              }
                              
                          }];
        
    } else {
        
        NSLog(@"device doesn't have Touchid");
        
    }
    return @{};
}

@end
