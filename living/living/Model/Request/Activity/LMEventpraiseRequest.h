//
//  LMEventpraiseRequest.h
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventpraiseRequest : FitBaseRequest

- (id)initWithEvent_uuid:(NSString *)event_uuid CommentUUid:(NSString *)comment_uuid;

@end
