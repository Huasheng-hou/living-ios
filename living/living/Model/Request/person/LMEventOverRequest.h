//
//  LMEventOverRequest.h
//  living
//
//  Created by Ding on 2017/2/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventOverRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andUser_uuid:(NSString *)user_uuid;

@end
