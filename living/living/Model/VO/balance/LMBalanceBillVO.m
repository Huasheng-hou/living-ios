//
//  LMBalanceBillVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceBillVO.h"

@implementation LMBalanceBillVO


+ (LMBalanceBillVO *)LMBalanceBillVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMBalanceBillVO LMBalanceBillVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMBalanceBillVO *)LMBalanceBillVOWithDictionary:(NSDictionary *)dictionary
{
    LMBalanceBillVO *instance = [[LMBalanceBillVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMBalanceBillVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMBalanceBillVO LMBalanceBillVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"recharges"] && ![[dictionary objectForKey:@"recharges"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"recharges"] isKindOfClass:[NSString class]]) {
            self.recharges = [dictionary objectForKey:@"recharges"];
        }
        
        if (nil != [dictionary objectForKey:@"expenditure"] && ![[dictionary objectForKey:@"expenditure"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"expenditure"] isKindOfClass:[NSString class]]) {
            self.expenditure = [dictionary objectForKey:@"expenditure"];
        }
        
        if (nil != [dictionary objectForKey:@"events_bill"] && ![[dictionary objectForKey:@"events_bill"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"events_bill"] isKindOfClass:[NSString class]]) {
            self.eventsBill = [dictionary objectForKey:@"events_bill"];
        }
        
        if (nil != [dictionary objectForKey:@"recharges_bill"] && ![[dictionary objectForKey:@"recharges_bill"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"recharges_bill"] isKindOfClass:[NSString class]]) {
            self.rechargesBill = [dictionary objectForKey:@"recharges_bill"];
        }
        
        if (nil != [dictionary objectForKey:@"refunds_bill"] && ![[dictionary objectForKey:@"refunds_bill"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"refunds_bill"] isKindOfClass:[NSString class]]) {
            self.refundsBill = [dictionary objectForKey:@"refunds_bill"];
        }
        
        
    }
    
    return self;
}

@end

