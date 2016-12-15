//
//  LMVoiceJoinRequest.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceJoinRequest.h"

@implementation LMVoiceJoinRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
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
    return @"voice/join";//参加课程
}

@end
