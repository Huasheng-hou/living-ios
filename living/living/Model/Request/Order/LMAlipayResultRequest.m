//
//  LMAlipayResultRequest.m
//  living
//
//  Created by Ding on 16/10/20.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAlipayResultRequest.h"

@implementation LMAlipayResultRequest


- (id)initWithMyOrderUuid:(NSString *)myOrderUuid andAlipayResult:(NSDictionary *)alipayResult
{
    self = [super init];
    if (self)
    {
        
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (myOrderUuid) {
            [bodyDict setObject:myOrderUuid forKey:@"myOrderUuid"];
        }
        
        if (alipayResult) {
            [bodyDict setObject:alipayResult forKey:@"alipayResult"];
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
    return @"alipay/result";//支付宝支付结果确认
}

@end
