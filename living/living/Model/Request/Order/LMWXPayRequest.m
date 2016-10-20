//
//  LMWXPayRequest.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWXPayRequest.h"

@implementation LMWXPayRequest

- (id)initWithWXRecharge:(NSString *)recharge
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (recharge) {
            [bodyDict setObject:recharge forKey:@"order_uuid"];
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
    return @"wechat/order";//微信支付下单
}

@end
