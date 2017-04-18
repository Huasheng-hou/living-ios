//
//  LMEventBodyVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventBodyVO.h"

@implementation LMEventBodyVO

+ (LMEventBodyVO *)LMEventBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMEventBodyVO LMEventBodyVOWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMEventBodyVO *)LMEventBodyVOWithDictionary:(NSDictionary *)dictionary
{
    LMEventBodyVO *instance = [[LMEventBodyVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMEventBodyVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMEventBodyVO LMEventBodyVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"event_img"] && ![[dictionary objectForKey:@"event_img"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_img"] isKindOfClass:[NSString class]]) {
            self.eventImg= [dictionary objectForKey:@"event_img"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"publish_name"] && ![[dictionary objectForKey:@"publish_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_name"] isKindOfClass:[NSString class]]) {
            self.publishName = [dictionary objectForKey:@"publish_name"];
        }
        
        if (nil != [dictionary objectForKey:@"total_number"] && ![[dictionary objectForKey:@"total_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"total_number"] isKindOfClass:[NSNumber class]]) {
            self.totalNumber= [(NSNumber *)[dictionary objectForKey:@"total_number"] intValue];
        }
        if (nil != [dictionary objectForKey:@"total_num"] && ![[dictionary objectForKey:@"total_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"total_num"] isKindOfClass:[NSNumber class]]) {
            self.totalNum= [(NSNumber *)[dictionary objectForKey:@"total_num"] intValue];
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
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        
        if (nil != [dictionary objectForKey:@"publish_avatar"] && ![[dictionary objectForKey:@"publish_avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_avatar"] isKindOfClass:[NSString class]]) {
            self.publishAvatar = [dictionary objectForKey:@"publish_avatar"];
        }
        if (nil != [dictionary objectForKey:@"longitude"] && ![[dictionary objectForKey:@"longitude"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"longitude"] isKindOfClass:[NSString class]]) {
            self.longitude = [dictionary objectForKey:@"longitude"];
        }
        
        if (nil != [dictionary objectForKey:@"latitude"] && ![[dictionary objectForKey:@"latitude"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"latitude"] isKindOfClass:[NSString class]]) {
            self.latitude = [dictionary objectForKey:@"latitude"];
        }
        
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSNumber class]]) {
            self.status = [(NSNumber *)[dictionary objectForKey:@"status"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"living_uuid"] && ![[dictionary objectForKey:@"living_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_uuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"living_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"notices"] && ![[dictionary objectForKey:@"notices"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"notices"] isKindOfClass:[NSString class]]) {
            self.notices = [dictionary objectForKey:@"notices"];
        }
        if (nil != [dictionary objectForKey:@"eventid"] && ![[dictionary objectForKey:@"eventid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"eventid"] isKindOfClass:[NSNumber class]]) {
            self.eventid= [(NSNumber *)[dictionary objectForKey:@"eventid"] intValue];
        }
        if (nil != [dictionary objectForKey:@"is_buy"] && ![[dictionary objectForKey:@"is_buy"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"eventid"] isKindOfClass:[NSNumber class]]) {
            self.isBuy= [(NSNumber *)[dictionary objectForKey:@"is_buy"] intValue];
        }

        
    }
    return self;
}


@end
