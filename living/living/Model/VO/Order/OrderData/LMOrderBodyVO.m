//
//  LMOrderBodyVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderBodyVO.h"

@implementation LMOrderBodyVO

+ (LMOrderBodyVO *)LMOrderBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMOrderBodyVO LMOrderBodyVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}
+ (LMOrderBodyVO *)LMOrderBodyVOWithDictionary:(NSDictionary *)dictionary
{
    LMOrderBodyVO *instance = [[LMOrderBodyVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
    
}
+ (NSArray *)LMOrderBodyVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMOrderBodyVO LMOrderBodyVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"number"] && ![[dictionary objectForKey:@"number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"number"] isKindOfClass:[NSNumber class]]) {
            self.number = [(NSNumber *) [dictionary objectForKey:@"number"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"totalMoney"] && ![[dictionary objectForKey:@"totalMoney"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"totalMoney"] isKindOfClass:[NSString class]]) {
            self.totalMoney = [dictionary objectForKey:@"totalMoney"];
        }
        
        if (nil != [dictionary objectForKey:@"price"] && ![[dictionary objectForKey:@"price"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"price"] isKindOfClass:[NSString class]]) {
            self.price = [dictionary objectForKey:@"price"];
        }
        
        if (nil != [dictionary objectForKey:@"order_uuid"] && ![[dictionary objectForKey:@"order_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_uuid"] isKindOfClass:[NSString class]]) {
            self.orderUuid = [dictionary objectForKey:@"order_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"order_time"] && ![[dictionary objectForKey:@"order_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_time"] isKindOfClass:[NSString class]]) {
            self.orderTime = [dictionary objectForKey:@"order_time"];
        }
        
        if (nil != [dictionary objectForKey:@"balance"] && ![[dictionary objectForKey:@"balance"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"balance"] isKindOfClass:[NSString class]]) {
            self.balance = [dictionary objectForKey:@"balance"];
        }
        
        if (nil != [dictionary objectForKey:@"coupons"] && ![[dictionary objectForKey:@"coupons"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"coupons"] isKindOfClass:[NSNumber class]]) {
            self.coupons = [(NSNumber *)[dictionary objectForKey:@"coupons"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"couponMoneys"] && ![[dictionary objectForKey:@"couponMoneys"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"couponMoneys"] isKindOfClass:[NSString class]]) {
            self.couponMoney = [dictionary objectForKey:@"couponMoneys"];
        }
        
        if (nil != [dictionary objectForKey:@"couponPrice"] && ![[dictionary objectForKey:@"couponPrice"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"couponPrice"] isKindOfClass:[NSString class]]) {
            self.couponPrice = [dictionary objectForKey:@"couponPrice"];
        }
        
        
        
    }
    return self;
}

@end
