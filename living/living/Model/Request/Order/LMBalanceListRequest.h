//
//  LMBalanceListRequest.h
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMBalanceListRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andMonth:(NSString *)month;

@end
