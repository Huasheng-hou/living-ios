//
//  LMYGBCoinListRequest.h
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMYGBCoinListRequest : FitBaseRequest
- (id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize;
@end