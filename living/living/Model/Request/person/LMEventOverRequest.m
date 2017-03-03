//
//  LMEventOverRequest.m
//  living
//
//  Created by Ding on 2017/2/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventOverRequest.h"

@implementation LMEventOverRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andUser_uuid:(NSString *)user_uuid
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
        
        if (user_uuid) {
            [body setObject:user_uuid forKey:@"user_uuid"];
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
    return @"event/isOver";
}



@end
