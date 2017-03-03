//
//  LMVoiceDeleteReplyRequest.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceDeleteReplyRequest.h"

@implementation LMVoiceDeleteReplyRequest

- (id)initWithReplyUuid:(NSString *)reply_uuid

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (reply_uuid){
            [bodyDict setObject:reply_uuid forKey:@"reply_uuid"];
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
    return @"reply/voice/delete";//删除回复
}

@end
