//
//  LMWriterDataRequest.h
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMWriterDataRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize authorUuid:(NSString *)author_uuid;

@end
