//
//  LMCreaterListRequest.m
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCreaterListRequest.h"

@implementation LMCreaterListRequest

- (id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"pageSize"];
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
    return @"event/creater";//查询自己发布的所有活动
}

@end
