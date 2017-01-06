//
//  LMVoiceChangeTextRequest.m
//  living
//
//  Created by Ding on 2017/1/6.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMVoiceChangeTextRequest.h"

@implementation LMVoiceChangeTextRequest

-(id)initWithtranscodingUrl:(NSString *)transcodingUrl andcurrentIndex:(int)currentIndex voice_uuid:(NSString *)voice_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (transcodingUrl) {
            [body setObject:transcodingUrl forKey:@"transcodingUrl"];
        }
        if (currentIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", currentIndex] forKey:@"currentIndex"];
        }
        if (voice_uuid) {
            [body setObject:voice_uuid forKey:@"voice_uuid"];
        }
        
        NSMutableDictionary *parmDic = [self params];
        [parmDic setValue:body forKey:@"body"];
    }
    return self;
    
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"chat/read";//语音转文字
}
@end
