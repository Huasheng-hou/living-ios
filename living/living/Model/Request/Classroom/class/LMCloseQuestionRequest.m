//
//  LMCloseQuestionRequest.m
//  living
//
//  Created by Ding on 2017/1/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMCloseQuestionRequest.h"

@implementation LMCloseQuestionRequest

-(id)initWithQuestionUuid:(NSString *)question_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];

        if (question_uuid) {
            [body setObject:question_uuid forKey:@"question_uuid"];
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
    return @"chat/close";//关闭问题
}
@end
