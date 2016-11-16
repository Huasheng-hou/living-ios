//
//  LMMemberVO.m
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMemberVO.h"

@implementation LMMemberVO

+ (LMMemberVO *)LMMemberVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMMemberVO LMMemberVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMMemberVO *)LMMemberVOWithDictionary:(NSDictionary *)dictionary
{
    LMMemberVO *instance = [[LMMemberVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMMemberVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMMemberVO LMMemberVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.nickName = [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"event_name"] && ![[dictionary objectForKey:@"event_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_name"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"event_name"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.Avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSNumber class]]) {
            self.userId = [(NSNumber *)[dictionary objectForKey:@"userId"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"number"] && ![[dictionary objectForKey:@"number"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"number"] isKindOfClass:[NSNumber class]]) {
            self.number = [(NSNumber *)[dictionary objectForKey:@"number"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"orderAmount"] && ![[dictionary objectForKey:@"orderAmount"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"orderAmount"] isKindOfClass:[NSString class]]) {
            self.orderAmount = [dictionary objectForKey:@"orderAmount"];
        }
        


    }
    
    return self;
}

@end

