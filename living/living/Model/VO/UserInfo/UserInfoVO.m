//
//  UserInfoVO.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/27.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "UserInfoVO.h"

@implementation UserInfoVO

+ (UserInfoVO *)UserInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [UserInfoVO UserInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (UserInfoVO *)UserInfoVOWithDictionary:(NSDictionary *)dictionary
{
    UserInfoVO *instance = [[UserInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)UserInfoVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[UserInfoVO UserInfoVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"livingUuid"] && ![[dictionary objectForKey:@"livingUuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"livingUuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"livingUuid"];
        }
        
        if (nil != [dictionary objectForKey:@"city"] && ![[dictionary objectForKey:@"city"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"city"] isKindOfClass:[NSString class]]) {
            self.city = [dictionary objectForKey:@"city"];
        }
        
        if (nil != [dictionary objectForKey:@"nick_name"] && ![[dictionary objectForKey:@"nick_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]]) {
            self.nickName = [dictionary objectForKey:@"nick_name"];
        }
        
        if (nil != [dictionary objectForKey:@"province"] && ![[dictionary objectForKey:@"province"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"province"] isKindOfClass:[NSString class]]) {
            self.province = [dictionary objectForKey:@"province"];
        }
        
        if (nil != [dictionary objectForKey:@"prove"] && ![[dictionary objectForKey:@"prove"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"prove"] isKindOfClass:[NSString class]]) {
            self.prove = [dictionary objectForKey:@"prove"];
        }
        
        if (nil != [dictionary objectForKey:@"franchisee"] && ![[dictionary objectForKey:@"franchisee"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"franchisee"] isKindOfClass:[NSString class]]) {
            self.franchisee = [dictionary objectForKey:@"franchisee"];
        }
        
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sign"] isKindOfClass:[NSString class]]) {
            self.sign = [dictionary objectForKey:@"sign"];
        }
        
        if (nil != [dictionary objectForKey:@"birthday"] && ![[dictionary objectForKey:@"birthday"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"birthday"] isKindOfClass:[NSString class]]) {
            self.birthday = [dictionary objectForKey:@"birthday"];
        }
        
        
        if (nil != [dictionary objectForKey:@"balance"] && ![[dictionary objectForKey:@"balance"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"balance"] isKindOfClass:[NSNumber class]]) {
            self.balance =[(NSNumber *) [dictionary objectForKey:@"balance"] floatValue];
        }
        
        if (nil != [dictionary objectForKey:@"total_event_num"] && ![[dictionary objectForKey:@"total_event_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"total_event_num"] isKindOfClass:[NSString class]]) {
            self.totalEventNum =[dictionary objectForKey:@"total_event_num"];
        }
        
        if (nil != [dictionary objectForKey:@"event_num"] && ![[dictionary objectForKey:@"event_num"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_num"] isKindOfClass:[NSString class]]) {
            self.eventNum =[dictionary objectForKey:@"event_num"];
        }
        
        if (nil != [dictionary objectForKey:@"gender"] && ![[dictionary objectForKey:@"gender"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"gender"] isKindOfClass:[NSString class]]) {
            self.gender = [dictionary objectForKey:@"gender"];
        }
        
        if (nil != [dictionary objectForKey:@"privileges"] && ![[dictionary objectForKey:@"privileges"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"privileges"] isKindOfClass:[NSString class]]) {
            self.privileges = [dictionary objectForKey:@"privileges"];
        }

        if (nil != [dictionary objectForKey:@"order_number"] && ![[dictionary objectForKey:@"order_number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"order_number"] isKindOfClass:[NSNumber class]]) {
            self.orderNumber =[(NSNumber *) [dictionary objectForKey:@"order_number"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"living_nums"] && ![[dictionary objectForKey:@"living_nums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_nums"] isKindOfClass:[NSNumber class]]) {
            self.livingNumber =[(NSNumber *) [dictionary objectForKey:@"living_nums"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSNumber class]]) {
            self.userId =[(NSNumber *) [dictionary objectForKey:@"userId"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"endTime"] && ![[dictionary objectForKey:@"endTime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"endTime"] isKindOfClass:[NSString class]]) {
            self.endTime = [dictionary objectForKey:@"endTime"];
        }
    }
    
    return self;
}

@end
