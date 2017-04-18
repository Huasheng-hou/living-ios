//
//  LMWXRechargrRequest.h
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMWXRechargrRequest : FitBaseRequest

@property (nonatomic, assign)NSInteger type;

- (id)initWithWXRecharge:(NSString *)recharge andLivingUuid:(NSString *)liveUUID;

@end
