//
//  LMVoiceDetailVO.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceDetailVO.h"

@implementation LMVoiceDetailVO

+ (LMVoiceDetailVO *)LMVoiceDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMVoiceDetailVO LMVoiceDetailVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMVoiceDetailVO *)LMVoiceDetailVOWithDictionary:(NSDictionary *)dictionary
{
    LMVoiceDetailVO *instance = [[LMVoiceDetailVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMVoiceDetailVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMVoiceDetailVO LMVoiceDetailVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"voice_uuid"] && ![[dictionary objectForKey:@"voice_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_uuid"] isKindOfClass:[NSString class]]) {
            self.voiceUuid = [dictionary objectForKey:@"voice_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"image"] isKindOfClass:[NSString class]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
        
        if (nil != [dictionary objectForKey:@"voice_title"] && ![[dictionary objectForKey:@"voice_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_title"] isKindOfClass:[NSString class]]) {
            self.voiceTitle = [dictionary objectForKey:@"voice_title"];
        }
        
        if (nil != [dictionary objectForKey:@"publish_name"] && ![[dictionary objectForKey:@"publish_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_name"] isKindOfClass:[NSString class]]) {
            self.publishName = [dictionary objectForKey:@"publish_name"];
        }
        if (nil != [dictionary objectForKey:@"number"] && ![[dictionary objectForKey:@"number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"number"] isKindOfClass:[NSNumber class]]) {
            self.number = [dictionary objectForKey:@"number"];
        }
        
        if (nil != [dictionary objectForKey:@"contact_phone"] && ![[dictionary objectForKey:@"contact_phone"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"contact_phone"] isKindOfClass:[NSString class]]) {
            self.contactPhone = [dictionary objectForKey:@"contact_phone"];
        }
        
        if (nil != [dictionary objectForKey:@"contact_name"] && ![[dictionary objectForKey:@"contact_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"contact_name"] isKindOfClass:[NSString class]]) {
            self.contactName = [dictionary objectForKey:@"contact_name"];
        }
        
        if (nil != [dictionary objectForKey:@"per_cost"] && ![[dictionary objectForKey:@"per_cost"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"per_cost"] isKindOfClass:[NSString class]]) {
            self.perCost = [dictionary objectForKey:@"per_cost"];
        }
        
        if (nil != [dictionary objectForKey:@"discount"] && ![[dictionary objectForKey:@"discount"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"discount"] isKindOfClass:[NSString class]]) {
            self.discount = [dictionary objectForKey:@"discount"];
        }
        
        if (nil != [dictionary objectForKey:@"start_time"] && ![[dictionary objectForKey:@"start_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"start_time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.startTime = [formatter dateFromString:[dictionary objectForKey:@"start_time"]];
        }
        
        if (nil != [dictionary objectForKey:@"end_time"] && ![[dictionary objectForKey:@"end_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"end_time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.endTime = [formatter dateFromString:[dictionary objectForKey:@"end_time"]];
        }
        if (nil != [dictionary objectForKey:@"limit_num"] && ![[dictionary objectForKey:@"limit_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"limit_num"] isKindOfClass:[NSNumber class]]) {
            self.limitNum = [dictionary objectForKey:@"limit_num"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            self.status = [dictionary objectForKey:@"status"];
        }
        if (nil != [dictionary objectForKey:@"living_uuid"] && ![[dictionary objectForKey:@"living_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_uuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"living_uuid"];
        }
        if (nil != [dictionary objectForKey:@"list"] && ![[dictionary objectForKey:@"list"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
            self.list = [dictionary objectForKey:@"list"];
        }
        
        if (nil != [dictionary objectForKey:@"notices"] && ![[dictionary objectForKey:@"notices"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"notices"] isKindOfClass:[NSString class]]) {
            self.notices = [dictionary objectForKey:@"notices"];
        }
    }
    
    return self;
}

@end

