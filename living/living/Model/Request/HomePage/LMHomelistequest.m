//
//  LMHomelistequest.m
//  living
//
//  Created by Ding on 16/10/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomelistequest.h"

@implementation LMHomelistequest

- (id)initWithPageIndex:(int)pageIndex
            andPageSize:(int)pageSize
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"pageSize"];
        }

        
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageIndex"];
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
    return @"article/list";
}

@end
