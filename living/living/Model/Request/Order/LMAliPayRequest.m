//
//  LMAliPayRequest.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAliPayRequest.h"

@implementation LMAliPayRequest

- (id)initWithAliRecharge:(NSString *)recharge
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
    return @"alipay/order";//支付宝支付下单
}

@end
