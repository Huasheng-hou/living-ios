//
//  LMPublicArticleRequest.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicArticleRequest.h"

@implementation LMPublicArticleRequest

-(id)initWithArticlecontent:(NSString *)article_content
              Article_title:(NSString *)article_title
                 Descrition:(NSString *)descrition
                andImageURL:(NSArray *)article_imgs
                    andType:(NSString *)type
                      blend:(NSArray *)blend
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        if (article_content) {
            [bodyDict setObject:article_content forKey:@"article_content"];
        }
        
        if (article_title) {
            [bodyDict setObject:article_title forKey:@"article_title"];
        }
        
        if (descrition) {
            [bodyDict setObject:descrition forKey:@"descrition"];
        }
        
        
        if (article_imgs) {
            [bodyDict setObject:article_imgs forKey:@"article_imgs"];
        }
        
        if (type) {
            [bodyDict setObject:article_imgs forKey:@"article_imgs"];
        }
        
        if (blend) {
            [bodyDict setObject:blend forKey:@"blend"];
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"article/add";
}

@end
