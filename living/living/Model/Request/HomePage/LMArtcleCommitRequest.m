//
//  LMArtcleCommitRequest.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArtcleCommitRequest.h"

@implementation LMArtcleCommitRequest

- (id)initWithArticle_uuid:(NSString *)article_uuid
               CommentUUid:(NSString *)comment_uuid
             Reply_content:(NSString *)reply_content

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (article_uuid){
            [bodyDict setObject:article_uuid forKey:@"article_uuid"];
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
    return @"reply/answer";
}


@end
