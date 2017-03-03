//
//  LMBlackListRequest.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBlackListRequest.h"

@implementation LMBlackListRequest

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
    return [NSString stringWithFormat:@"author/list/%@", _user_uuid];
}

@end
