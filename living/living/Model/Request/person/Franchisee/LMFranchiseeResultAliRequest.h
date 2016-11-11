//
//  LMFranchiseeResultAliRequest.h
//  living
//
//  Created by Ding on 2016/11/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFranchiseeResultAliRequest : FitBaseRequest

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid andAlipayResult:(NSDictionary *)alipayResult;

@end
