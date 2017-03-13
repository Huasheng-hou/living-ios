//
//  LMFriendMessageRequest.h
//  living
//
//  Created by Ding on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMFriendMessageRequest : FitBaseRequest

-(id)initWithPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize user_uuid:(NSString *)user_uuid;

@end
