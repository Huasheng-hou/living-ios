//
//  LMHomeDetailRequest.m
//  living
//

//  Created by Ding on 16/10/13.

//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomeDetailRequest.h"

@implementation LMHomeDetailRequest


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
    return @"article/detail";
}


@end
