//
//  LMEventReplydeleteRequest.h
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventReplydeleteRequest : FitBaseRequest

- (id)initWithCommentUUid:(NSString *)comment_uuid;

@end
