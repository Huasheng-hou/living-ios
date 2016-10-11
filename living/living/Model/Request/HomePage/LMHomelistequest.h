//
//  LMHomelistequest.h
//  living
//
//  Created by Ding on 16/10/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMHomelistequest : FitBaseRequest

- (id)initWithPageIndex:(int)pageIndex
        andPageSize:(int)pageSize;

@end
