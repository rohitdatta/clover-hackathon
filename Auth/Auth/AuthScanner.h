//
//  AuthScanner.h
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthScanner : NSObject

+ (NSDictionary *)validateFingerFromPush:(NSDictionary *)data;

@end
