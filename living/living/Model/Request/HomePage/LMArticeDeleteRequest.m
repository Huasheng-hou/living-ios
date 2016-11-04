//
//  LMArticeDeleteRequest.m
//  living
//
//  Created by JamHonyZ on 2016/11/4.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArticeDeleteRequest.h"

@implementation LMArticeDeleteRequest

- (id)initWithArticle_uuid:(NSString *)article_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (article_uuid){
            [bodyDict setObject:article_uuid forKey:@"article_uuid"];
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
    return @"article/delete";//删除文章
}

@end
