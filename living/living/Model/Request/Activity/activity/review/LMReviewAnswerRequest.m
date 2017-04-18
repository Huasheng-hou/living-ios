//
//  LMReviewAnswerRequest.m
//  living
//
//  Created by hxm on 2017/3/30.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMReviewAnswerRequest.h"

@implementation LMReviewAnswerRequest


- (instancetype)initWithReviewUuid:(NSString *)reviewUuid andCommentUuid:(NSString *)commentUuid andReplyContent:(NSString *)replyContent{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (reviewUuid) {
            [body setObject:reviewUuid forKey:@"review_uuid"];
        }
        if (commentUuid) {
            [body setObject:commentUuid forKey:@"comment_uuid"];
        }
        if (replyContent) {
            [body setObject:replyContent forKey:@"reply_content"];
        }
        NSMutableDictionary * params = [self params];
        [params setObject:body forKey:@"body"];
    }
    return self;

}

- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    
    return @"review/answer";
}

@end
