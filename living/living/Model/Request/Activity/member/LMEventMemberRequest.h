//
//  LMEventMemberRequest.h
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventMemberRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andEvent_uuid:(NSString *)event_uuid;

@end
