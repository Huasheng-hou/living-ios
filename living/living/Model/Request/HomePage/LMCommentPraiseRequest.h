//
//  LMCommentPraiseRequest.h
//  living
//
//  Created by Ding on 16/10/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMCommentPraiseRequest : FitBaseRequest

- (id)initWithArticle_uuid:(NSString *)article_uuid CommentUUid:(NSString *)comment_uuid;

@end
