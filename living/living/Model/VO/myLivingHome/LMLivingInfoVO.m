//
//  LMLivingInfoVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLivingInfoVO.h"

@implementation LMLivingInfoVO

+ (LMLivingInfoVO *)LMLivingInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMLivingInfoVO LMLivingInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMLivingInfoVO *)LMLivingInfoVOWithDictionary:(NSDictionary *)dictionary
{
    LMLivingInfoVO *instance = [[LMLivingInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMLivingInfoVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMLivingInfoVO LMLivingInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);

}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        if (dictionary[@"living_image"] && [dictionary[@"living_image"] isKindOfClass:[NSArray class]]) {
            self.livingImage = dictionary[@"living_image"];
        }
        
        if (nil != [dictionary objectForKey:@"living_name"] && ![[dictionary objectForKey:@"living_name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_name"] isKindOfClass:[NSString class]]) {
            self.livingName = [dictionary objectForKey:@"living_name"];
        }
        
        if (nil != [dictionary objectForKey:@"living_title"] && ![[dictionary objectForKey:@"living_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_title"] isKindOfClass:[NSString class]]) {
            self.livingTitle = [dictionary objectForKey:@"living_title"];
        }
        
        if (nil != [dictionary objectForKey:@"userUuid"] && ![[dictionary objectForKey:@"userUuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userUuid"] isKindOfClass:[NSString class]]) {
            self.userUuid = [dictionary objectForKey:@"userUuid"];
        }
        
        if (nil != [dictionary objectForKey:@"living_uuid"] && ![[dictionary objectForKey:@"living_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"living_uuid"] isKindOfClass:[NSString class]]) {
            self.livingUuid = [dictionary objectForKey:@"living_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"balance"] && ![[dictionary objectForKey:@"balance"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"balance"] isKindOfClass:[NSString class]]) {
            self.balance = [dictionary objectForKey:@"balance"];
        }
        
        
    }
    return self;
}


@end
