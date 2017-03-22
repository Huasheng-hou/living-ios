//
//  LMBookLivingRequest.h
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMBookLivingRequest : FitBaseRequest

- (id)initWithName:(NSString *)name andPhone:(NSString *)phone andLivingUuid:(NSString *)livingUuid;

@end
