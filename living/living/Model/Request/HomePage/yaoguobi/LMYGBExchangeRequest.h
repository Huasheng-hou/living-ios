//
//  LMYGBExchangeRequest.h
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMYGBExchangeRequest : FitBaseRequest

- (instancetype)initWithAmount:(NSString *)amount andNumbers:(int)numbers;

@end
