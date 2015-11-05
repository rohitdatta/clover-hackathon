//
//  AuthScanner.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "AuthScanner.h"
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
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  NSLog(@"something went wrong");
                                  return;
                              }
                              
                              if (success) {
                                  NSLog(@"success!");
                                  
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
