//
//  LMYGBDetailVO.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBDetailVO.h"

@implementation LMYGBDetailVO
+ (LMYGBDetailVO *)LMYGBDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMYGBDetailVO LMYGBDetailVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMYGBDetailVO *)LMYGBDetailVOWithDictionary:(NSDictionary *)dictionary
{
    LMYGBDetailVO *instance = [[LMYGBDetailVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMYGBDetailVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMYGBDetailVO LMYGBDetailVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"user_uuid"];
        }
        if (nil != [dictionary objectForKey:@"datetime"] && ![[dictionary objectForKey:@"datetime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"datetime"] isKindOfClass:[NSString class]]) {
            self.dateTime = [dictionary objectForKey:@"datetime"];
        }
        if (nil != [dictionary objectForKey:@"numbers"] && ![[dictionary objectForKey:@"numbers"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"numbers"] isKindOfClass:[NSString class]]) {
            self.numbers = [dictionary objectForKey:@"numbers"];
        }
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
    }
    return self;
}

@end
