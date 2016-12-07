//
//  LMArtcleTypeListRequest.m
//  living
//
//  Created by Ding on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArtcleTypeListRequest.h"

@implementation LMArtcleTypeListRequest

-(id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize andType:(NSString *)type
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
        
        if (type) {
            [body setObject:type forKey:@"type"];
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
    return @"article/typeOfAll";//分类下所有文章
}

@end
