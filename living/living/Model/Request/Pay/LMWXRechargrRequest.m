//
//  LMWXRechargrRequest.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWXRechargrRequest.h"

@implementation LMWXRechargrRequest

- (id)initWithWXRecharge:(NSString *)recharge
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (recharge) {
            [bodyDict setObject:recharge forKey:@"totalMoney"];
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
    return @"wxrecharge/order";//微信充值下单
}

@end
