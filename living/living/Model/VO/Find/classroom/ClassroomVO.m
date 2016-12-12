//
//  ClassroomVO.m
//  living
//
//  Created by Ding on 2016/12/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "ClassroomVO.h"

@implementation ClassroomVO

+ (ClassroomVO *)ClassroomVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [ClassroomVO ClassroomVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (ClassroomVO *)ClassroomVOWithDictionary:(NSDictionary *)dictionary
{
    ClassroomVO *instance = [[ClassroomVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)ClassroomVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[ClassroomVO ClassroomVOWithDictionary:entry]];
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
   
        if (nil != [dictionary objectForKey:@"voice_uuid"] && ![[dictionary objectForKey:@"voice_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_uuid"] isKindOfClass:[NSString class]]) {
            self.voiceUuid = [dictionary objectForKey:@"voice_uuid"];
        }
   
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
   
        if (nil != [dictionary objectForKey:@"nick_name"] && ![[dictionary objectForKey:@"nick_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]]) {
            self.nickname = [dictionary objectForKey:@"nick_name"];
        }
   
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"image"] isKindOfClass:[NSString class]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
   
        if (nil != [dictionary objectForKey:@"voice_title"] && ![[dictionary objectForKey:@"voice_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_title"] isKindOfClass:[NSString class]]) {
            self.voiceTitle = [dictionary objectForKey:@"voice_title"];
        }
        if (nil != [dictionary objectForKey:@"current_num"] && ![[dictionary objectForKey:@"current_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"current_num"] isKindOfClass:[NSNumber class]]) {
            self.currentNum = [(NSNumber *)[dictionary objectForKey:@"current_num"] intValue];
        }
        if (nil != [dictionary objectForKey:@"start_time"] && ![[dictionary objectForKey:@"start_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"start_time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.startTime = [formatter dateFromString:[dictionary objectForKey:@"start_time"]];
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
            self.totalNum = [(NSNumber *)[dictionary objectForKey:@"total_num"] intValue];
        }

        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            self.status = [dictionary objectForKey:@"status"];
        }
   
        
    }
    
    return self;
}

@end
