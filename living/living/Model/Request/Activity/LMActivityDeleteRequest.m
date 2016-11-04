//
//  LMActivityDeleteRequest.m
//  living
//
//  Created by JamHonyZ on 2016/11/4.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityDeleteRequest.h"

@implementation LMActivityDeleteRequest

- (id)initWithEvent_uuid:(NSArray *)event_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_uuid){
            [bodyDict setObject:event_uuid forKey:@"event_uuid"];
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
    return @"event/delete";//删除活动
}

@end
