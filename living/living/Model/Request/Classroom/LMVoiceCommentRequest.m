//
//  LMVoiceCommentRequest.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceCommentRequest.h"

@implementation LMVoiceCommentRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid commentContent:(NSString *)comment_content
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (voice_uuid){
            [bodyDict setObject:voice_uuid forKey:@"voice_uuid"];
        }
        
        if (comment_content){
            [bodyDict setObject:comment_content forKey:@"comment_content"];
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
    return @"voice/comment";//评论课程
}

@end
