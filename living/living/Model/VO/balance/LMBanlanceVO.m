//
//  LMBanlanceVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBanlanceVO.h"

@implementation LMBanlanceVO


+ (LMBanlanceVO *)LMBanlanceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMBanlanceVO LMBanlanceVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMBanlanceVO *)LMBanlanceVOWithDictionary:(NSDictionary *)dictionary
{
    LMBanlanceVO *instance = [[LMBanlanceVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMBanlanceVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMBanlanceVO LMBanlanceVOWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"balanceUuid"] && ![[dictionary objectForKey:@"balanceUuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"balanceUuid"] isKindOfClass:[NSString class]]) {
            self.balanceUuid = [dictionary objectForKey:@"balanceUuid"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"datetime"] && ![[dictionary objectForKey:@"datetime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"datetime"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.datetime = [formatter dateFromString:[dictionary objectForKey:@"datetime"]];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.name = [dictionary objectForKey:@"name"];
        }

        
        
    }
    
    return self;
}

@end

