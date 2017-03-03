//
//  LMVoiceQuesrtionRequest.m
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceQuesrtionRequest.h"

@implementation LMVoiceQuesrtionRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize voiceUuid:(NSString *)voice_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
        }
        
        if (voice_uuid) {
            [body setObject:voice_uuid forKey:@"voice_uuid"];
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
    return @"chat/questions";//查询问题列表
}

@end
