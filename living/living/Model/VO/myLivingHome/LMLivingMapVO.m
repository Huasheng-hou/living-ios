//
//  LMLivingMapVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLivingMapVO.h"

@implementation LMLivingMapVO


+ (LMLivingMapVO *)LMLivingMapVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMLivingMapVO LMLivingMapVOWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMLivingMapVO *)LMLivingMapVOWithDictionary:(NSDictionary *)dictionary
{
    LMLivingMapVO *instance = [[LMLivingMapVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMLivingMapVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMLivingMapVO LMLivingMapVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"join_nums"] && ![[dictionary objectForKey:@"join_nums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"join_nums"] isKindOfClass:[NSNumber class]]) {
            self.joinNums = [(NSNumber *)[dictionary objectForKey:@"join_nums"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"publish_nums"] && ![[dictionary objectForKey:@"publish_nums"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"publish_nums"] isKindOfClass:[NSNumber class]]) {
            self.publishNums = [(NSNumber *)[dictionary objectForKey:@"publish_nums"] intValue];
        }
        
        
    }
    return self;
}


@end


