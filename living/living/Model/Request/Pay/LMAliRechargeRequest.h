//
//  LMAliRechargeRequest.h
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMAliRechargeRequest : FitBaseRequest

@property (nonatomic, assign) NSInteger type;

- (id)initWithAliRecharge:(NSString *)recharge andLivingUuid:(NSString *)living_uuid;

@end
