//
//  LMFriendListRequest.h
//  living
//
//  Created by Ding on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFriendListRequest : FitBaseRequest

-(id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize;

@end
