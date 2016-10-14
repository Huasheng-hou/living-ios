//
//  LMEventLivingMsgRequest.m
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventLivingMsgRequest.h"

@implementation LMEventLivingMsgRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid Commentcontent:(NSString *)comment_content

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_uuid){
            [bodyDict setObject:event_uuid forKey:@"event_uuid"];
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
    return @"event/comment";
}

@end
