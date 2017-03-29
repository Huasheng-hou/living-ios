//
//  LMActivityDetailRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityDetailRequest.h"

@implementation LMActivityDetailRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid

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
    if (self.type == 2) {
        return @"item/detail";
    }
    return @"event/detail";
//    return @"item/detail";
}

@end
