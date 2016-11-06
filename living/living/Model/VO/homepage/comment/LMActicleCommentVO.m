//
//  LMActicleCommentVO.m
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActicleCommentVO.h"

@implementation LMActicleCommentVO

+ (LMActicleCommentVO *)LMActicleCommentVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMActicleCommentVO LMActicleCommentVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}
+ (LMActicleCommentVO *)LMActicleCommentVOWithDictionary:(NSDictionary *)dictionary
{
    LMActicleCommentVO *instance = [[LMActicleCommentVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMActicleCommentVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMActicleCommentVO LMActicleCommentVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"reply_time"] && ![[dictionary objectForKey:@"reply_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"reply_time"] isKindOfClass:[NSString class]]) {
            self.replyTime = [dictionary objectForKey:@"reply_time"];
        }
        
        if (nil != [dictionary objectForKey:@"reply_uuid"] && ![[dictionary objectForKey:@"reply_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"reply_uuid"] isKindOfClass:[NSString class]]) {
            self.replyUuid = [dictionary objectForKey:@"reply_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"has_praised"] && ![[dictionary objectForKey:@"has_praised"] isEqual:[NSNull null]]) {
            self.hasPraised = [(NSNumber *)[dictionary objectForKey:@"has_praised"] boolValue];
        }
        
        if (nil != [dictionary objectForKey:@"comment_time"] && ![[dictionary objectForKey:@"comment_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"comment_time"] isKindOfClass:[NSString class]]) {
            self.commentTime = [dictionary objectForKey:@"comment_time"];
        }
        
        if (nil != [dictionary objectForKey:@"praise_count"] && ![[dictionary objectForKey:@"praise_count"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"praise_count"] isKindOfClass:[NSNumber class]]) {
            self.praiseCount = [(NSNumber *)[dictionary objectForKey:@"praise_count"] intValue];
        }
    
        
        if (nil != [dictionary objectForKey:@"comment_uuid"] && ![[dictionary objectForKey:@"comment_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"comment_uuid"] isKindOfClass:[NSString class]]) {
            self.commentUuid = [dictionary objectForKey:@"comment_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"nick_name"] && ![[dictionary objectForKey:@"nick_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]]) {
            self.nickName = [dictionary objectForKey:@"nick_name"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"respondent_nickname"] && ![[dictionary objectForKey:@"respondent_nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"respondent_nickname"] isKindOfClass:[NSString class]]) {
            self.respondentNickname = [dictionary objectForKey:@"respondent_nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        
        if (nil != [dictionary objectForKey:@"comment_content"] && ![[dictionary objectForKey:@"comment_content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"comment_content"] isKindOfClass:[NSString class]]) {
            self.commentContent = [dictionary objectForKey:@"comment_content"];
        }    
    }
    
    return self;
}

@end
