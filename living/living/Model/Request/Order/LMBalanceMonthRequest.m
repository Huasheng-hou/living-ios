//
//  LMBalanceMonthRequest.m
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceMonthRequest.h"

@implementation LMBalanceMonthRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andMonth:(NSString *)month
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
        if (month) {
            [body setObject:month forKey:@"month"];
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
    return @"balance/search";
}

@end
