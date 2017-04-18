//
//  LMMakerBannerVO.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMakerBannerVO.h"

@implementation LMMakerBannerVO
+ (LMMakerBannerVO *)LMMakerBannerVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMMakerBannerVO LMMakerBannerVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMMakerBannerVO *)LMMakerBannerVOWithDictionary:(NSDictionary *)dictionary
{
    LMMakerBannerVO *instance = [[LMMakerBannerVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMMakerBannerVOWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMMakerBannerVO LMMakerBannerVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        if (nil != [dictionary objectForKey:@"weburl"] && ![[dictionary objectForKey:@"weburl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"weburl"] isKindOfClass:[NSString class]]) {
            self.webUrl = [dictionary objectForKey:@"weburl"];
        }
        
    }
    return self;
}

@end
