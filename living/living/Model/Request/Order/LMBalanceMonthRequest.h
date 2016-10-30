//
//  LMBalanceMonthRequest.h
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMBalanceMonthRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andMonth:(NSString *)month;

@end
