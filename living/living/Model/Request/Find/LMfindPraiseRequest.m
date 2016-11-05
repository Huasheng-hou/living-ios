//
//  LMfindPraiseRequest.m
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMfindPraiseRequest.h"

@implementation LMfindPraiseRequest

-(id)initWithPageFindUUID:(NSString *)findUuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (findUuid) {
            [body setObject:findUuid forKey:@"find_uuid"];
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
    return @"find/praise";//发现页点赞
}


@end
