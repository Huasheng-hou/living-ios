//
//  LMCommentPraiseRequest.m
//  living
//
//  Created by Ding on 16/10/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCommentPraiseRequest.h"

@implementation LMCommentPraiseRequest

- (id)initWithArticle_uuid:(NSString *)article_uuid CommentUUid:(NSString *)comment_uuid
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
    return @"article/comment/praise";
}

@end
