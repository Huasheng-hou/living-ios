//
//  LMReviewDetailRequest.m
//  living
//
//  Created by hxm on 2017/3/30.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMReviewDetailRequest.h"

@implementation LMReviewDetailRequest

- (id)initWithReviewUuid:(NSString *)reviewUuid{
    
    if (self = [super init]) {
        
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (reviewUuid) {
            [body setObject:reviewUuid forKey:@"review_uuid"];
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
    return @"review/detail";
}


@end
