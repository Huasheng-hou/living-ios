//
//  LMFranchiseeWchatPayRequest.h
//  living
//
//  Created by Ding on 2016/11/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFranchiseeWchatPayRequest : FitBaseRequest

- (id)initWithWXRecharge:(NSString *)recharge
           andLivingUuid:(NSString *)living_uuid
                andPhone:(NSString *)phone
                 andName:(NSString *)name;

@end
