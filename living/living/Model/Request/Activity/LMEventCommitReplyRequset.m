//
//  LMEventCommitReplyRequset.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventCommitReplyRequset.h"

@implementation LMEventCommitReplyRequset

- (id)initWithEvent_uuid:(NSString *)event_uuid
             CommentUUid:(NSString *)comment_uuid
           Reply_content:(NSString *)reply_content
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_uuid){
            [bodyDict setObject:event_uuid forKey:@"event_uuid"];
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
    return @"reply/event/answer";
}

@end
