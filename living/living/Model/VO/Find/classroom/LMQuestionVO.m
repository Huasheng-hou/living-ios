//
//  LMQuestionVO.m
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMQuestionVO.h"

@implementation LMQuestionVO
+ (LMQuestionVO *)LMQuestionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMQuestionVO LMQuestionVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMQuestionVO *)LMQuestionVOWithDictionary:(NSDictionary *)dictionary
{
    LMQuestionVO *instance = [[LMQuestionVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMQuestionVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMQuestionVO LMQuestionVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"question_uuid"] && ![[dictionary objectForKey:@"question_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"question_uuid"] isKindOfClass:[NSString class]]) {
            self.question_uuid = [dictionary objectForKey:@"question_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"time"] && ![[dictionary objectForKey:@"time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.time = [formatter dateFromString:[dictionary objectForKey:@"time"]];
        }


        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            self.status = [dictionary objectForKey:@"status"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
    }
    
    return self;
}

@end
