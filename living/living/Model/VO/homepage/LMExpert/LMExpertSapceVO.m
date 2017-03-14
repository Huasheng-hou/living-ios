//
//  LMExpertSapceVO.m
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertSapceVO.h"

@implementation LMExpertSapceVO
+ (LMExpertSapceVO *)LMExpertSapceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMExpertSapceVO LMExpertSapceVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMExpertSapceVO *)LMExpertSapceVOWithDictionary:(NSDictionary *)dictionary
{
    LMExpertSapceVO *instance = [[LMExpertSapceVO alloc] initWithDictionary:dictionary];
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
        
        [resultsArray addObject:[LMExpertSapceVO LMExpertSapceVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

@end
