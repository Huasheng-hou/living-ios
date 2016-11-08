//
//  LMBalanceChargeRequest.h
//  living
//
//  Created by Ding on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMBalanceChargeRequest : FitBaseRequest

-(id)initWithOrder_uuid:(NSString *)order_uuid useBalance:(NSString *)useBalance;

@end
