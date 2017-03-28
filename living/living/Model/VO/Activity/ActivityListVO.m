
//
//  ActivityListVO.m
//  living
//
//  Created by JamHonyZ on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "ActivityListVO.h"

@implementation ActivityListVO

+ (ActivityListVO *)ActivityListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ActivityListVO ActivityListVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ActivityListVO *)ActivityListVOWithDictionary:(NSDictionary *)dictionary
{
    ActivityListVO *instance = [[ActivityListVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ActivityListVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ActivityListVO ActivityListVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"nick_name"] && ![[dictionary objectForKey:@"nick_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]]) {
            self.nickName = [dictionary objectForKey:@"nick_name"];
        }
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        if (nil != [dictionary objectForKey:@"event_img"] && ![[dictionary objectForKey:@"event_img"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_img"] isKindOfClass:[NSString class]]) {
            self.eventImg = [dictionary objectForKey:@"event_img"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"total_number"] && ![[dictionary objectForKey:@"total_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"total_number"] isKindOfClass:[NSNumber class]]) {
            self.currentNumber = [dictionary objectForKey:@"total_number"];
        }
        
//        if (nil != [dictionary objectForKey:@"create_time"] && ![[dictionary objectForKey:@"create_time"] isEqual:[NSNull null]]
//            && [[dictionary objectForKey:@"create_time"] isKindOfClass:[NSString class]]) {
//            
//            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
//            
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            
//            self.createTime = (NSString *)[formatter dateFromString:[dictionary objectForKey:@"create_time"]];
//        }
        
        if (nil != [dictionary objectForKey:@"create_time"] && ![[dictionary objectForKey:@"create_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"create_time"] isKindOfClass:[NSString class]]) {
            self.createTime = [dictionary objectForKey:@"create_time"];
        }
        if (nil != [dictionary objectForKey:@"start_time"] && ![[dictionary objectForKey:@"start_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"start_time"] isKindOfClass:[NSString class]]) {
            self.startTime = [dictionary objectForKey:@"start_time"];
        }
        if (nil != [dictionary objectForKey:@"per_cost"] && ![[dictionary objectForKey:@"per_cost"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"per_cost"] isKindOfClass:[NSString class]]) {
            self.perCost = [dictionary objectForKey:@"per_cost"];
        }
        
        if (nil != [dictionary objectForKey:@"discount"] && ![[dictionary objectForKey:@"discount"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"discount"] isKindOfClass:[NSString class]]) {
            self.discount = [dictionary objectForKey:@"discount"];
        }
        
        if (nil != [dictionary objectForKey:@"total_num"] && ![[dictionary objectForKey:@"total_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"total_num"] isKindOfClass:[NSNumber class]]) {
            self.totalNumber = [dictionary objectForKey:@"total_num"];
        }
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSNumber class]]) {
            self.status = [dictionary objectForKey:@"status"];
        }
        if (nil != [dictionary objectForKey:@"category"] && ![[dictionary objectForKey:@"category"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"category"] isKindOfClass:[NSString class]]) {
            self.category = [dictionary objectForKey:@"category"];
        }
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        
    }
    
    return self;
}

@end
