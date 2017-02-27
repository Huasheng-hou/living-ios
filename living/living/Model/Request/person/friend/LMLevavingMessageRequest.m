//
//  LMLevavingMessageRequest.m
//  living
//
//  Created by Ding on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMLevavingMessageRequest.h"

@implementation LMLevavingMessageRequest

-(id)initWithuser_uuid:(NSString *)user_uuid andContent:(NSString *)content

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (user_uuid){
            [bodyDict setObject:user_uuid forKey:@"user_uuid"];
        }
        
        if (content){
            [bodyDict setObject:content forKey:@"content"];
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
    return @"message/leaving";
}

@end
