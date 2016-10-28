//
//  LMEventJoinRequest.m
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventJoinRequest.h"

@implementation LMEventJoinRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid order_nums:(NSString *)order_nums

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_uuid){
            [bodyDict setObject:event_uuid forKey:@"event_uuid"];
        }
        
        if (order_nums){
            [bodyDict setObject:order_nums forKey:@"order_nums"];
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
    return @"event/join";
}

@end
