//
//  LMEventListRequest.h
//  living
//
//  Created by hxm on 2017/3/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventListRequest : FitBaseRequest
-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andCity:(NSString *)city;
@end
