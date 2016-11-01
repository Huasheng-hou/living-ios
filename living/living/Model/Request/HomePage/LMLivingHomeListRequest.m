//
//  LMLivingHomeListRequest.m
//  living
//
//  Created by Ding on 2016/10/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLivingHomeListRequest.h"

@implementation LMLivingHomeListRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize
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
    return @"living/list";
}

@end