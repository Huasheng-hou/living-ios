//
//  LMExpertArticlesRequest.h
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMExpertArticlesRequest : FitBaseRequest

- (instancetype)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize andUserUuid:(NSString *)userUuid;

@end
