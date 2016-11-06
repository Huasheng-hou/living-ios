//
//  LMBalanceVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceVO.h"

@implementation LMBalanceVO
+ (LMBalanceVO *)LMBalanceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMBalanceVO LMBalanceVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMBalanceVO *)LMBalanceVOWithDictionary:(NSDictionary *)dictionary
{
    LMBalanceVO *instance = [[LMBalanceVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMBalanceVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMBalanceVO LMBalanceVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"month"] && ![[dictionary objectForKey:@"month"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"month"] isKindOfClass:[NSString class]]) {
            self.month = [dictionary objectForKey:@"month"];
        }
        if (nil != [dictionary objectForKey:@"monthofbalance"] && ![[dictionary objectForKey:@"monthofbalance"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"monthofbalance"] isKindOfClass:[NSArray class]])
        {
          self.Banlance = [NSMutableArray arrayWithArray:[LMBanlanceVO LMBanlanceVOListWithArray:[dictionary objectForKey:@"monthofbalance"]]];
        }
        

        
        
        
    }
    
    return self;
}

@end
