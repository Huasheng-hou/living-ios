//
//  LMFriendListRequest.m
//  living
//
//  Created by Ding on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFriendListRequest.h"

@implementation LMFriendListRequest

-(id)initWithUserUuid:(NSString *)user_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (user_uuid) {
          [body setObject:user_uuid forKey:@"user_uuid"];
        
        }
        
        NSMutableDictionary *parmDic = [self params];
        [parmDic setValue:body forKey:@"body"];
    }
    return self;
    
}
- (BOOL)isPost
{
    return YES;
}


- (NSString *)methodPath
{
    return @"friends/onefriend";
}

@end
