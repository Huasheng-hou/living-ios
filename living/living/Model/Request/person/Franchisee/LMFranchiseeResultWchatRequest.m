//
//  LMFranchiseeResultWchatRequest.m
//  living
//
//  Created by Ding on 2016/11/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFranchiseeResultWchatRequest.h"


@implementation LMFranchiseeResultWchatRequest

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid
{
    self = [super init];
    if (self)
    {
        
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (myOrderUuid) {
            [bodyDict setObject:myOrderUuid forKey:@"myOrderUuid"];
        }
        
        NSMutableDictionary     *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"join/wechat/result";//加盟充值下单
}

@end
