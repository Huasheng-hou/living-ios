//
//  LMEventReplydeleteRequest.m
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventReplydeleteRequest.h"

@implementation LMEventReplydeleteRequest
-(id)initWithCommentUUid:(NSString *)comment_uuid

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (comment_uuid){
            [bodyDict setObject:comment_uuid forKey:@"reply_uuid"];
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
    return @"reply/event/delete";
}

@end
