//
//  LMCancelauthorRequest.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCancelauthorRequest.h"

@implementation LMCancelauthorRequest

-(id)initWithAuthor_uuid:(NSString *)author_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (author_uuid){
            [bodyDict setObject:author_uuid forKey:@"author_uuid"];
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
    return @"author/cancel";//取消屏蔽
}

@end
