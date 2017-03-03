//
//  LMPublicArticleRequest.h
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMPublicArticleRequest : FitBaseRequest

-(id)initWithArticlecontent:(NSString *)article_content
          Article_title:(NSString *)article_title
            Descrition:(NSString *)descrition
            andImageURL:(NSArray *)article_imgs
                    andType:(NSString *)type
                      blend:(NSArray *)blend
                       sign:(NSString *)sign;

@end
