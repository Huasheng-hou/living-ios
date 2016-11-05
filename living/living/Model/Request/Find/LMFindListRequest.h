//
//  LMFindListRequest.h
//  living
//
//  Created by Ding on 16/10/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFindListRequest : FitBaseRequest

-(id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize;

@end
