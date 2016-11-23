//
//  LMCouponVO.m
//  living
//
//  Created by Ding on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponVO.h"

@implementation LMCouponVO

+ (LMCouponVO *)LMCouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMCouponVO LMCouponVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMCouponVO *)LMCouponVOWithDictionary:(NSDictionary *)dictionary
{
    LMCouponVO *instance = [[LMCouponVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMCouponVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMCouponVO LMCouponVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"amount"] && ![[dictionary objectForKey:@"amount"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"amount"] isKindOfClass:[NSString class]]) {
            self.amount = [dictionary objectForKey:@"amount"];
        }
        
        if (nil != [dictionary objectForKey:@"living_name"] && ![[dictionary objectForKey:@"living_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_name"] isKindOfClass:[NSString class]]) {
            self.livingName = [dictionary objectForKey:@"living_name"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"living_uuid"] && ![[dictionary objectForKey:@"living_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_uuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"living_uuid"];
        }
        if (nil != [dictionary objectForKey:@"coupon_uuid"] && ![[dictionary objectForKey:@"coupon_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"coupon_uuid"] isKindOfClass:[NSString class]]) {
            self.couponUuid = [dictionary objectForKey:@"coupon_uuid"];
        }
        if (nil != [dictionary objectForKey:@"createTime"] && ![[dictionary objectForKey:@"createTime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"createTime"] isKindOfClass:[NSString class]]) {
            self.createTime = [dictionary objectForKey:@"createTime"];
        }
        if (nil != [dictionary objectForKey:@"endTime"] && ![[dictionary objectForKey:@"endTime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"endTime"] isKindOfClass:[NSString class]]) {
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.endTime = [formatter dateFromString:[dictionary objectForKey:@"endTime"]];
        }
        
    }
    
    return self;
}

@end
