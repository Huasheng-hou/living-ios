//
//  LMRewardBlanceRequest.m
//  living
//
//  Created by Ding on 2017/2/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMRewardBlanceRequest.h"

@implementation LMRewardBlanceRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid
               user_uuid:(NSString *)user_uuid
            money_reward:(NSString *)money_reward
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (voice_uuid ) {
            [body setObject:voice_uuid forKey:@"voice_uuid"];
        }
        
        if (user_uuid) {
            [body setObject:user_uuid forKey:@"user_uuid"];
        }
        if (money_reward) {
            [body setObject:money_reward forKey:@"money_reward"];
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
    return @"reward/balance";//通过消息编号查询消息记录
}


@end
