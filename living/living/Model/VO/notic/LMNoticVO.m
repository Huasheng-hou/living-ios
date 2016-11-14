//
//  LMNoticVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNoticVO.h"

@implementation LMNoticVO


+ (LMNoticVO *)LMNoticVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMNoticVO LMNoticVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMNoticVO *)LMNoticVOWithDictionary:(NSDictionary *)dictionary
{
    LMNoticVO *instance = [[LMNoticVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMNoticVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMNoticVO LMNoticVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"comment_uuid"] && ![[dictionary objectForKey:@"comment_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"comment_uuid"] isKindOfClass:[NSString class]]) {
            self.commentUuid = [dictionary objectForKey:@"comment_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            self.content = [dictionary objectForKey:@"content"];
        }

        if (nil != [dictionary objectForKey:@"article_uuid"] && ![[dictionary objectForKey:@"article_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_uuid"] isKindOfClass:[NSString class]]) {
            self.articleUuid = [dictionary objectForKey:@"article_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"userNick"] && ![[dictionary objectForKey:@"userNick"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userNick"] isKindOfClass:[NSString class]]) {
            self.userNick = [dictionary objectForKey:@"userNick"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"notice_time"] && ![[dictionary objectForKey:@"notice_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"notice_time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.noticeTime = [formatter dateFromString:[dictionary objectForKey:@"notice_time"]];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"notice_uuid"] && ![[dictionary objectForKey:@"notice_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"notice_uuid"] isKindOfClass:[NSString class]]) {
            self.noticeUuid = [dictionary objectForKey:@"notice_uuid"];
        }

        if (nil != [dictionary objectForKey:@"article_title"] && ![[dictionary objectForKey:@"article_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"article_title"] isKindOfClass:[NSString class]]) {
            self.articleTitle = [dictionary objectForKey:@"article_title"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sign"] isKindOfClass:[NSString class]]) {
            self.sign = [dictionary objectForKey:@"sign"];
        }
 
    }
    
    return self;
}

@end



