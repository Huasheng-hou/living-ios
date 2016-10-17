//
//  LMOrderListRequest.h
//  living
//
//  Created by Ding on 16/10/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMOrderListRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize;

@end
