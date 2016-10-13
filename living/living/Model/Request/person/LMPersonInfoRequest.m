//
//  LMPersonInfoRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPersonInfoRequest.h"

@implementation LMPersonInfoRequest

{
    NSString    *_user_uuid;
}

- (id)initWithUserUUid:(NSString *)user_uuid
{
    self = [super init];
    if (self) {
        
        if (user_uuid && [user_uuid isKindOfClass:[NSString class]]) {
            _user_uuid  = user_uuid;
        }
    }
    
    return self;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"user/%@", _user_uuid];
}

@end
