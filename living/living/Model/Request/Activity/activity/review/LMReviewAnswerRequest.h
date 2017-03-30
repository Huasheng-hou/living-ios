//
//  LMReviewAnswerRequest.h
//  living
//
//  Created by hxm on 2017/3/30.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMReviewAnswerRequest : FitBaseRequest

- (instancetype)initWithReviewUuid:(NSString *)reviewUuid andCommentUuid:(NSString *)commentUuid andReplyContent:(NSString *)replyContent;

@end
