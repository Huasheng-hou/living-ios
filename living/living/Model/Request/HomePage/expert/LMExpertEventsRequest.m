//
//  LMExpertEventsRequest.m
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertEventsRequest.h"

@implementation LMExpertEventsRequest
- (instancetype)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize andUserUuid:(NSString *)userUuid{
    
    if (self = [super init]) {
        
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", (long)pageSize] forKey:@"pageSize"];
        }
        if (userUuid) {
            [body setObject:userUuid forKey:@"user_uuid"];
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
    
    return @"master/more/events";
}

@end
