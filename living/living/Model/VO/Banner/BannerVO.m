//
//  BannerVO.m
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "BannerVO.h"

@implementation BannerVO

+ (BannerVO *)BannerVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [BannerVO BannerVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (BannerVO *)BannerVOWithDictionary:(NSDictionary *)dictionary
{
    BannerVO *instance = [[BannerVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)BannerVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[BannerVO BannerVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
       
        if (nil != [dictionary objectForKey:@"imgUrl"] && ![[dictionary objectForKey:@"imgUrl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"imgUrl"] isKindOfClass:[NSString class]]) {
            self.ImgUrl = [dictionary objectForKey:@"imgUrl"];
        }
        
        if (nil != [dictionary objectForKey:@"linkUrl"] && ![[dictionary objectForKey:@"linkUrl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"linkUrl"] isKindOfClass:[NSString class]]) {
            self.LinkUrl = [dictionary objectForKey:@"linkUrl"];
        }
        
        if (nil != [dictionary objectForKey:@"event_uuid"] && ![[dictionary objectForKey:@"event_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_uuid"] isKindOfClass:[NSString class]]) {
            self.KeyUUID = [dictionary objectForKey:@"event_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.Type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"webUrl"] && ![[dictionary objectForKey:@"webUrl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"webUrl"] isKindOfClass:[NSString class]]) {
            self.webUrl = [dictionary objectForKey:@"webUrl"];
        }
        
        if (nil != [dictionary objectForKey:@"webTitle"] && ![[dictionary objectForKey:@"webTitle"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"webTitle"] isKindOfClass:[NSString class]]) {
            self.webTitle = [dictionary objectForKey:@"webTitle"];
        }
    }
    
    return self;
}

@end
