//
//  LMVoiceCommentReplyRequest.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceCommentReplyRequest.h"

@implementation LMVoiceCommentReplyRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid commentUuid:(NSString *)comment_uuid replyContent:(NSString *)reply_content
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (voice_uuid){
            [bodyDict setObject:voice_uuid forKey:@"voice_uuid"];
        }
        
        if (comment_uuid){
            [bodyDict setObject:comment_uuid forKey:@"comment_uuid"];
        }
        
        if (reply_content){
            [bodyDict setObject:reply_content forKey:@"reply_content"];
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
    return @"reply/voice";//回复评论
}

@end
