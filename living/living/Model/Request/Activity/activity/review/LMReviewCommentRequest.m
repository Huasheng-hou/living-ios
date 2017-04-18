//
//  LMReviewCommentRequest.m
//  living
//
//  Created by hxm on 2017/3/30.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMReviewCommentRequest.h"

@implementation LMReviewCommentRequest

- (instancetype)initWithReviewUuid:(NSString *)reviewUuid andCommentContent:(NSString *)commentContent{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (reviewUuid) {
            [body setObject:reviewUuid forKey:@"review_uuid"];
        }
        if (commentContent) {
            [body setObject:commentContent forKey:@"comment_content"];
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
    
    return @"review/comment";
}

@end
