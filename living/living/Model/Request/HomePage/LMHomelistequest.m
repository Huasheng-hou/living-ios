//
//  LMHomelistequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomelistequest.h"

@implementation LMHomelistequest

-(id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (pageIndex != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", pageIndex] forKey:@"pageIndex"];
        }
        if (pageSize != -1) {
            [body setObject:[NSString stringWithFormat:@"%ld", pageSize] forKey:@"pageSize"];
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
