//
//  LMCoinlistVO.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMCoinlistVO.h"

@implementation LMCoinlistVO

+ (LMCoinlistVO *)LMCoinlistVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMCoinlistVO LMCoinlistVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMCoinlistVO *)LMCoinlistVOWithDictionary:(NSDictionary *)dictionary
{
    LMCoinlistVO *instance = [[LMCoinlistVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMCoinlistVOWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMCoinlistVO LMCoinlistVOWithDictionary:entry]];
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
        if (nil != [dictionary objectForKey:@"describe"] && ![[dictionary objectForKey:@"describe"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"describe"] isKindOfClass:[NSString class]]) {
            self.describe = [dictionary objectForKey:@"describe"];
        }
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        if (nil != [dictionary objectForKey:@"image"] && ![[dictionary objectForKey:@"image"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"image"] isKindOfClass:[NSString class]]) {
            self.image = [dictionary objectForKey:@"image"];
        }
        if (nil != [dictionary objectForKey:@"numbers"] && ![[dictionary objectForKey:@"numbers"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"numbers"] isKindOfClass:[NSNumber class]]) {
            self.numbers = [[dictionary objectForKey:@"numbers"] intValue];
        }
        
    }
    return self;
}

@end
