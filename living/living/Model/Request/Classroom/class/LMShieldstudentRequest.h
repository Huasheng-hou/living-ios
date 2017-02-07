//
//  LMShieldstudentRequest.h
//  living
//
//  Created by Ding on 2016/12/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMShieldstudentRequest : FitBaseRequest

-(id)initWithPageIndex:(NSString *)pageIndex andPageSize:(int)pageSize voice_uuid:(NSString *)voice_uuid;

@end
