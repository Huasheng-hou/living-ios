//
//  LMLivingHomeListRequest.h
//  living
//
//  Created by Ding on 2016/10/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMLivingHomeListRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize;

@end
