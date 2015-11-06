//
//  User.h
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import <Realm/Realm.h>

@interface User : RLMObject

@property NSString *firstname;
@property NSString *email;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<User>
RLM_ARRAY_TYPE(User)
