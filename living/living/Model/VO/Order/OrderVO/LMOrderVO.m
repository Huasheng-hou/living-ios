//
//  LMOrderVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderVO.h"

@implementation LMOrderVO

+ (LMOrderVO *)LMOrderVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMOrderVO LMOrderVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}
+ (LMOrderVO *)LMOrderVOWithDictionary:(NSDictionary *)dictionary
{
    LMOrderVO *instance = [[LMOrderVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMOrderVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMOrderVO LMOrderVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        
        if (nil != [dictionary objectForKey:@"event_img"] && ![[dictionary objectForKey:@"event_img"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_img"] isKindOfClass:[NSString class]]) {
            self.eventImg = [dictionary objectForKey:@"event_img"];
        }
        
        if (nil != [dictionary objectForKey:@"order_status"] && ![[dictionary objectForKey:@"order_status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_status"] isKindOfClass:[NSString class]]) {
            self.orderStatus = [dictionary objectForKey:@"order_status"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.eventUuid = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"order_amount"] && ![[dictionary objectForKey:@"order_amount"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_amount"] isKindOfClass:[NSString class]]) {
            self.orderAmount = [dictionary objectForKey:@"order_amount"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"pay_status"] && ![[dictionary objectForKey:@"pay_status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"pay_status"] isKindOfClass:[NSString class]]) {
            self.payStatus = [dictionary objectForKey:@"pay_status"];
        }
        
        if (nil != [dictionary objectForKey:@"order_uuid"] && ![[dictionary objectForKey:@"order_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_uuid"] isKindOfClass:[NSString class]]) {
            self.orderUuid = [dictionary objectForKey:@"order_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"order_number"] && ![[dictionary objectForKey:@"order_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_number"] isKindOfClass:[NSString class]]) {
            self.orderNumber = [dictionary objectForKey:@"order_number"];
        }
        
        if (nil != [dictionary objectForKey:@"ordering_time"] && ![[dictionary objectForKey:@"ordering_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"ordering_time"] isKindOfClass:[NSString class]]) {
            self.orderingTime = [dictionary objectForKey:@"ordering_time"];
        }
        
        if (nil != [dictionary objectForKey:@"numbers"] && ![[dictionary objectForKey:@"numbers"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"numbers"] isKindOfClass:[NSNumber class]]) {
            self.number = [(NSNumber *)[dictionary objectForKey:@"numbers"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"has_coupon"] && ![[dictionary objectForKey:@"has_coupon"] isEqual:[NSNull null]]) {
            self.hasCoupon = [(NSNumber *)[dictionary objectForKey:@"has_coupon"] boolValue];
        }
        
        
        if (nil != [dictionary objectForKey:@"couponMoney"] && ![[dictionary objectForKey:@"couponMoney"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"couponMoney"] isKindOfClass:[NSString class]]) {
            self.couponMoney = [dictionary objectForKey:@"couponMoney"];
        }
        
        if (nil != [dictionary objectForKey:@"discountMoney"] && ![[dictionary objectForKey:@"discountMoney"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"discountMoney"] isKindOfClass:[NSString class]]) {
            self.discountMoney = [dictionary objectForKey:@"discountMoney"];
        }
        
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSNumber class]]) {
            self.status =[(NSNumber *) [dictionary objectForKey:@"status"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"voiceStatus"] && ![[dictionary objectForKey:@"voiceStatus"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voiceStatus"] isKindOfClass:[NSString class]]) {
            self.voiceStatus = [dictionary objectForKey:@"voiceStatus"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"voice_uuid"] && ![[dictionary objectForKey:@"voice_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_uuid"] isKindOfClass:[NSString class]]) {
            self.voiceUuid = [dictionary objectForKey:@"voice_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"voice_title"] && ![[dictionary objectForKey:@"voice_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_title"] isKindOfClass:[NSString class]]) {
            self.voiceTitle = [dictionary objectForKey:@"voice_title"];
        }
        
        if (nil != [dictionary objectForKey:@"voice_images"] && ![[dictionary objectForKey:@"voice_images"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voice_images"] isKindOfClass:[NSString class]]) {
            self.voiceImages = [dictionary objectForKey:@"voice_images"];
        }
        
        
        
    }
    return self;
}

@end
