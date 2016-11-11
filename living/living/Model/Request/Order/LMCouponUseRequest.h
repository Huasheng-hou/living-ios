//
//  LMCouponUseRequest.h
//  living
//
//  Created by Ding on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMCouponUseRequest : FitBaseRequest

-(id)initWithOrder_uuid:(NSString *)order_uuid
            couponMoney:(NSString *)couponMoney
             couponUuid:(NSString *)coupon_uuid;

@end
