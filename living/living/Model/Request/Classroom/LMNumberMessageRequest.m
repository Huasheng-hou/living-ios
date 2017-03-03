//
//  LMNumberMessageRequest.m
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMNumberMessageRequest.h"

@implementation LMNumberMessageRequest

-(id)initWithCurrentIndex:(int)currentIndex  andVoiceUuid:(NSString *)voice_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (currentIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", currentIndex] forKey:@"currentIndex"];
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
    return @"chat/number";//通过消息编号查询消息记录
}

@end
