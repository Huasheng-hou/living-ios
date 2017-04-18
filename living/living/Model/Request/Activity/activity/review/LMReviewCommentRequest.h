//
//  LMReviewCommentRequest.h
//  living
//
//  Created by hxm on 2017/3/30.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMReviewCommentRequest : FitBaseRequest

- (instancetype)initWithReviewUuid:(NSString *)reviewUuid andCommentContent:(NSString *)commentContent;

@end
