//
//  LMExpertListRequest.m
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertListRequest.h"

@implementation LMExpertListRequest

- (instancetype)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize andCategory:(NSString *)category{
    
    if (self = [super init]) {
        
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"pageSize"];
        }
        if (category) {
            [body setObject:category forKey:@"category"];
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
    
    return @"master/list";
}
@end
