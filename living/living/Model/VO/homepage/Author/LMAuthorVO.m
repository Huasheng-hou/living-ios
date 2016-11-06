//
//  LMAuthorVO.m
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAuthorVO.h"

@implementation LMAuthorVO

+ (LMAuthorVO *)LMAuthorVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMAuthorVO LMAuthorVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMAuthorVO *)LMAuthorVOWithDictionary:(NSDictionary *)dictionary
{
    LMAuthorVO *instance = [[LMAuthorVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMAuthorVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMAuthorVO LMAuthorVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"article_content"] && ![[dictionary objectForKey:@"article_content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_content"] isKindOfClass:[NSString class]]) {
            self.articleContent = [dictionary objectForKey:@"article_content"];
        }
        
        if (nil != [dictionary objectForKey:@"article_uuid"] && ![[dictionary objectForKey:@"article_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_uuid"] isKindOfClass:[NSString class]]) {
            self.articleUuid = [dictionary objectForKey:@"article_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"cover"] && ![[dictionary objectForKey:@"cover"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"cover"] isKindOfClass:[NSString class]]) {
            self.cover = [dictionary objectForKey:@"cover"];
        }
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.nickname = [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"author_uuid"] && ![[dictionary objectForKey:@"author_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"author_uuid"] isKindOfClass:[NSString class]]) {
            self.authorUuid = [dictionary objectForKey:@"author_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"publish_time"] && ![[dictionary objectForKey:@"publish_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_time"] isKindOfClass:[NSString class]]) {
            self.publishTime = [dictionary objectForKey:@"publish_time"];
        }
    }
    
    return self;
}

@end
