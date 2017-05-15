//
//  LMExpertSpaceVO.m
//  living
//
//  Created by hxm on 2017/3/16.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertSpaceVO.h"

@implementation LMExpertSpaceVO
+ (LMExpertSpaceVO *)LMExpertSapceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMExpertSpaceVO LMExpertSapceVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMExpertSpaceVO *)LMExpertSapceVOWithDictionary:(NSDictionary *)dictionary
{
    LMExpertSpaceVO *instance = [[LMExpertSpaceVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMExpertSapceVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMExpertSpaceVO LMExpertSapceVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"nick_name"] && ![[dictionary objectForKey:@"nick_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nick_name"] isKindOfClass:[NSString class]]) {
            self.nickName = [dictionary objectForKey:@"nick_name"];
        }
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        if (nil != [dictionary objectForKey:@"images"] && ![[dictionary objectForKey:@"images"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"images"] isKindOfClass:[NSString class]]) {
            self.images = [dictionary objectForKey:@"images"];
        }
        if (nil != [dictionary objectForKey:@"introduce"] && ![[dictionary objectForKey:@"introduce"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"introduce"] isKindOfClass:[NSString class]]) {
            self.introduce = [dictionary objectForKey:@"introduce"];
        }
        if (nil != [dictionary objectForKey:@"gender"] && ![[dictionary objectForKey:@"gender"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"gender"] isKindOfClass:[NSString class]]) {
            self.gender = [dictionary objectForKey:@"gender"];
        }
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSString class]]) {
            self.userId = [dictionary objectForKey:@"userId"];
        }
        if (nil != [dictionary objectForKey:@"province"] && ![[dictionary objectForKey:@"province"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"province"] isKindOfClass:[NSString class]]) {
            self.province = [dictionary objectForKey:@"province"];
        }
        if (nil != [dictionary objectForKey:@"city"] && ![[dictionary objectForKey:@"city"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"city"] isKindOfClass:[NSString class]]) {
            self.city = [dictionary objectForKey:@"city"];
        }
        if (nil != [dictionary objectForKey:@"franchisee"] && ![[dictionary objectForKey:@"franchisee"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"franchisee"] isKindOfClass:[NSString class]]) {
            self.franchisee = [dictionary objectForKey:@"franchisee"];
        }
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sign"] isKindOfClass:[NSString class]]) {
            self.sign = [dictionary objectForKey:@"sign"];
        }
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        if (nil != [dictionary objectForKey:@"articleNums"] && ![[dictionary objectForKey:@"articleNums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"articleNums"] isKindOfClass:[NSNumber class]]) {
            self.articleNums = [dictionary objectForKey:@"articleNums"];
        }
        if (nil != [dictionary objectForKey:@"eventNums"] && ![[dictionary objectForKey:@"eventNums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"eventNums"] isKindOfClass:[NSNumber class]]) {
            self.eventNums = [dictionary objectForKey:@"eventNums"];
        }
        if (nil != [dictionary objectForKey:@"voiceNums"] && ![[dictionary objectForKey:@"voiceNums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voiceNums"] isKindOfClass:[NSNumber class]]) {
            self.voiceNums = [dictionary objectForKey:@"voiceNums"];
        }
    }
    return self;
}

@end
