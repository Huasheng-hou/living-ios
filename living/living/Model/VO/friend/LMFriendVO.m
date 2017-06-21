//
//  LMFriendVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFriendVO.h"

@implementation LMFriendVO


+ (LMFriendVO *)LMFriendVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMFriendVO LMFriendVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMFriendVO *)LMFriendVOWithDictionary:(NSDictionary *)dictionary
{
    LMFriendVO *instance = [[LMFriendVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMFriendVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMFriendVO LMFriendVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.nickname = [dictionary objectForKey:@"nickname"];
        }
        if (nil != [dictionary objectForKey:@"myNickname"] && ![[dictionary objectForKey:@"myNickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"myNickname"] isKindOfClass:[NSString class]]) {
            self.myNickname = [dictionary objectForKey:@"myNickname"];
        }
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSNumber class]]) {
            self.userId = [(NSNumber *)[dictionary objectForKey:@"userId"] intValue];
        };
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSString class]]) {
            self.UserID = [dictionary objectForKey:@"userId"];
        };
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"myContent"] && ![[dictionary objectForKey:@"myContent"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"myContent"] isKindOfClass:[NSString class]]) {
            self.myContent = [dictionary objectForKey:@"myContent"];
        }
        if (nil != [dictionary objectForKey:@"remark"] && ![[dictionary objectForKey:@"remark"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"remark"] isKindOfClass:[NSString class]]) {
            self.remark = [dictionary objectForKey:@"remark"];
        }
        
        if (nil != [dictionary objectForKey:@"add_time"] && ![[dictionary objectForKey:@"add_time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"add_time"] isKindOfClass:[NSString class]]) {
            self.addTime = [dictionary objectForKey:@"add_time"];
        }
        
        if (nil != [dictionary objectForKey:@"coupons"] && ![[dictionary objectForKey:@"coupons"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"coupons"] isKindOfClass:[NSArray class]]) {
            self.coupons = [dictionary objectForKey:@"coupons"];
        }
        
        
    }
    
    return self;
}

@end


