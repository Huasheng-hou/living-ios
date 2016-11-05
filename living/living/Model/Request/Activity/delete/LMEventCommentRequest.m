//
//  LMEventCommentRequest.m
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventCommentRequest.h"

@implementation LMEventCommentRequest

- (id)initWithCommentUUid:(NSString *)comment_uuid


{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
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
    return @"event/comment/delete";
}

@end
