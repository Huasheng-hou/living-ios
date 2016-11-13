//
//  LMOrderInfoVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderInfoVO.h"

@implementation LMOrderInfoVO

+ (LMOrderInfoVO *)LMOrderInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMOrderInfoVO LMOrderInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}
+ (LMOrderInfoVO *)LMOrderInfoVOWithDictionary:(NSDictionary *)dictionary
{
    LMOrderInfoVO *instance = [[LMOrderInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMOrderInfoVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMOrderInfoVO LMOrderInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);

}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"end_time"] && ![[dictionary objectForKey:@"end_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"end_time"] isKindOfClass:[NSString class]]) {
            self.endTime = [dictionary objectForKey:@"end_time"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"totalMoney"] && ![[dictionary objectForKey:@"totalMoney"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"totalMoney"] isKindOfClass:[NSString class]]) {
            self.totalMoney = [dictionary objectForKey:@"totalMoney"];
        }
        
        if (nil != [dictionary objectForKey:@"start_time"] && ![[dictionary objectForKey:@"start_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"start_time"] isKindOfClass:[NSString class]]) {
            self.startTime = [dictionary objectForKey:@"start_time"];
        }
        
        if (nil != [dictionary objectForKey:@"event_address"] && ![[dictionary objectForKey:@"event_address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_address"] isKindOfClass:[NSString class]]) {
            self.eventAddress = [dictionary objectForKey:@"event_address"];
        }
        
        if (nil != [dictionary objectForKey:@"average_price"] && ![[dictionary objectForKey:@"average_price"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"average_price"] isKindOfClass:[NSString class]]) {
            self.averagePrice = [dictionary objectForKey:@"average_price"];
        }
        
        if (nil != [dictionary objectForKey:@"join_number"] && ![[dictionary objectForKey:@"join_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"join_number"] isKindOfClass:[NSNumber class]]) {
            self.joinNumber = [(NSNumber *)[dictionary objectForKey:@"join_number"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"order_number"] && ![[dictionary objectForKey:@"order_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_number"] isKindOfClass:[NSString class]]) {
            self.orderNumber = [dictionary objectForKey:@"order_number"];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"order_uuid"] && ![[dictionary objectForKey:@"order_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_uuid"] isKindOfClass:[NSString class]]) {
            self.orderUuid = [dictionary objectForKey:@"order_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"validated_price"] && ![[dictionary objectForKey:@"validated_price"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"validated_price"] isKindOfClass:[NSString class]]) {
            self.validatedPrice = [dictionary objectForKey:@"validated_price"];
        }
    }
    return self;
}

@end
