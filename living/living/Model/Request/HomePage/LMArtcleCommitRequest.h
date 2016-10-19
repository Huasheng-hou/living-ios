//
//  LMArtcleCommitRequest.h
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMArtcleCommitRequest : FitBaseRequest

- (id)initWithArticle_uuid:(NSString *)article_uuid
             CommentUUid:(NSString *)comment_uuid
           Reply_content:(NSString *)reply_content;

@end
