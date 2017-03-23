//
//  LMLivingVenueVO.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMLivingVenueVO.h"

@implementation LMLivingVenueVO
+ (LMLivingVenueVO *)LMLivingVenueVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMLivingVenueVO LMLivingVenueVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMLivingVenueVO *)LMLivingVenueVOWithDictionary:(NSDictionary *)dictionary
{
    LMLivingVenueVO *instance = [[LMLivingVenueVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMLivingVenueVOWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMLivingVenueVO LMLivingVenueVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"living_uuid"] && ![[dictionary objectForKey:@"living_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_uuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"living_uuid"];
        }
        if (nil != [dictionary objectForKey:@"living_name"] && ![[dictionary objectForKey:@"living_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_name"] isKindOfClass:[NSString class]]) {
            self.livingName = [dictionary objectForKey:@"living_name"];
        }
        if (nil != [dictionary objectForKey:@"living_image"] && ![[dictionary objectForKey:@"living_image"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_image"] isKindOfClass:[NSString class]]) {
            self.livingImage = [dictionary objectForKey:@"living_image"];
        }
        
    }
    return self;
}

@end
