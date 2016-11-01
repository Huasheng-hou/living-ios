//
//  LMWriterDataRequest.m
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWriterDataRequest.h"

@implementation LMWriterDataRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize authorUuid:(NSString *)author_uuid
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
        if (author_uuid) {
            [body setObject:author_uuid forKey:@"author_uuid"];
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
    return @"article/personal";
}

@end
