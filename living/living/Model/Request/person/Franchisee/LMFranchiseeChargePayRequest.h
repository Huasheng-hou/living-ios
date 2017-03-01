//
//  LMFranchiseeChargePayRequest.h
//  living
//
//  Created by Ding on 2017/3/1.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFranchiseeChargePayRequest : FitBaseRequest

- (id)initWithPayRecharge:(NSString *)recharge
            andLivingUuid:(NSString *)living_uuid
                 andPhone:(NSString *)phone
                  andName:(NSString *)name;

@end
