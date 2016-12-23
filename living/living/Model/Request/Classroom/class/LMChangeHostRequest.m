//
//  LMChangeHostRequest.m
//  living
//
//  Created by Ding on 2016/12/23.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChangeHostRequest.h"

@implementation LMChangeHostRequest

- (id)initWithUserId:(NSString *)userId nickname:(NSString *)nickname voice_uuid:(NSString *)voice_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (userId) {
            [bodyDict setObject:userId forKey:@"userId"];
        }
        
        if (nickname){
            [bodyDict setObject:nickname forKey:@"nickname"];
        }
        
        if (voice_uuid){
            [bodyDict setObject:voice_uuid forKey:@"voice_uuid"];
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
    return @"voice/update/host";//更换主持人
}

@end
