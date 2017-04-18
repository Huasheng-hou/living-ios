//
//  LMWXRechargeResultRequest.h
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMWXRechargeResultRequest : FitBaseRequest

@property (nonatomic, assign) NSInteger type;

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid;

@end
