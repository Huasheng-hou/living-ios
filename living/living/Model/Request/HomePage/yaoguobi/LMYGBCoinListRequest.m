//
//  LMYGBCoinListRequest.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBCoinListRequest.h"

@implementation LMYGBCoinListRequest
- (id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize{
    if (self = [super init]) {
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

- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    return @"coin/list";
}

@end
