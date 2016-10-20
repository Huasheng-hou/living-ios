//
//  LMWXPayResultRequest.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWXPayResultRequest.h"

@implementation LMWXPayResultRequest

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
    return @"wechat/result";//微信支付结果确认
}

@end
