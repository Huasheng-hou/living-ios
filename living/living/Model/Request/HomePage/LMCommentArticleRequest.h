//
//  LMCommentArticleRequest.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMCommentArticleRequest : FitBaseRequest

-(id)initWithArticle_uuid:(NSString *)article_uuid Commentcontent:(NSString *)comment_content;

@end
