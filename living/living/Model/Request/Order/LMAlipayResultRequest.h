//
//  LMAlipayResultRequest.h
//  living
//
//  Created by Ding on 16/10/20.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMAlipayResultRequest : FitBaseRequest

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid andAlipayResult:(NSDictionary *)alipayResult;

@end
