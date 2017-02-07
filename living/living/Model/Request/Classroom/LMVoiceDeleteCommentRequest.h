//
//  LMVoiceDeleteCommentRequest.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceDeleteCommentRequest : FitBaseRequest

- (id)initWithCommentUuid:(NSString *)comment_uuid;

@end
