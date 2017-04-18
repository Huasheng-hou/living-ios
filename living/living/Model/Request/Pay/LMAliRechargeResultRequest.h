//
//  LMAliRechargeResultRequest.h
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMAliRechargeResultRequest : FitBaseRequest

@property (nonatomic, assign) NSInteger type;

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid andAlipayResult:(NSDictionary *)alipayResult;

@end
