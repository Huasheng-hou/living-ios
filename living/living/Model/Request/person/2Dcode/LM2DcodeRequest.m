//
//  LM2DcodeRequest.m
//  living
//
//  Created by Ding on 2016/10/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LM2DcodeRequest.h"

@implementation LM2DcodeRequest

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
    return [NSString stringWithFormat:@"user/code/%@", _user_uuid];
}

@end
