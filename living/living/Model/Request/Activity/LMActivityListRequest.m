//
//  LMActivityListRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityListRequest.h"

@implementation LMActivityListRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andCity:(NSString *)city
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
        }
        
        if (city) {
            [body setObject:city forKey:@"city"];
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
    return @"event/list";
}

@end
