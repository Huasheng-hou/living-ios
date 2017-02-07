//
//  LMShieldstudentRequest.m
//  living
//
//  Created by Ding on 2016/12/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMShieldstudentRequest.h"

@implementation LMShieldstudentRequest

-(id)initWithPageIndex:(NSString *)pageIndex andPageSize:(int)pageSize voice_uuid:(NSString *)voice_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex) {
            [body setObject:pageIndex forKey:@"currentIndex"];
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
    return @"chat/include";//查看消息记录（屏蔽学员）
}

@end
