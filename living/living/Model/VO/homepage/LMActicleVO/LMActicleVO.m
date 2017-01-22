//
//  LMActicleVO.m
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActicleVO.h"

@implementation LMActicleVO

+ (LMActicleVO *)LMActicleVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMActicleVO LMActicleVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}
+ (LMActicleVO *)LMActicleVOWithDictionary:(NSDictionary *)dictionary
{
    LMActicleVO *instance = [[LMActicleVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMActicleVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMActicleVO LMActicleVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"article_name"] && ![[dictionary objectForKey:@"article_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_name"] isKindOfClass:[NSString class]]) {
            self.articleName = [dictionary objectForKey:@"article_name"];
        }
        
        if (nil != [dictionary objectForKey:@"article_content"] && ![[dictionary objectForKey:@"article_content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_content"] isKindOfClass:[NSString class]]) {
            self.articleContent = [dictionary objectForKey:@"article_content"];
        }
        
        if (nil != [dictionary objectForKey:@"article_uuid"] && ![[dictionary objectForKey:@"article_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_uuid"] isKindOfClass:[NSString class]]) {
            self.articleUuid = [dictionary objectForKey:@"article_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"article_title"] && ![[dictionary objectForKey:@"article_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_title"] isKindOfClass:[NSString class]]) {
            self.articleTitle = [dictionary objectForKey:@"article_title"];
        }
        
        if (nil != [dictionary objectForKey:@"publish_time"] && ![[dictionary objectForKey:@"publish_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_time"] isKindOfClass:[NSString class]]) {
            self.publishTime = [dictionary objectForKey:@"publish_time"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        if (nil != [dictionary objectForKey:@"franchisee"] && ![[dictionary objectForKey:@"franchisee"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"franchisee"] isKindOfClass:[NSString class]]) {
            self.franchisee = [dictionary objectForKey:@"franchisee"];
        }
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sign"] isKindOfClass:[NSString class]]) {
            self.sign = [dictionary objectForKey:@"sign"];
        }
        
        
    }
    
    return self;

}

@end
