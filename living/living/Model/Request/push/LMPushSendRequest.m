//
//  LMPushSendRequest.m
//  living
//
//  Created by Ding on 2016/11/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPushSendRequest.h"

@implementation LMPushSendRequest

- (id)initWithUserUUid:(NSString *)user_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        if (user_uuid) {
            [bodyDict setObject:user_uuid forKey:@"user_uuid"];
        }
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"push/send";//向成员推送活动开始/结束消息
}


@end
