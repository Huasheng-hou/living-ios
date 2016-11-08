//
//  LMFindVO.m
//  living
//
//  Created by Ding on 2016/11/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFindVO.h"

@implementation LMFindVO

+ (LMFindVO *)LMFindVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMFindVO LMFindVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (LMFindVO *)LMFindVOWithDictionary:(NSDictionary *)dictionary
{
    LMFindVO *instance = [[LMFindVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)LMFindVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMFindVO LMFindVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"number_of_votes"] && ![[dictionary objectForKey:@"number_of_votes"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"number_of_votes"] isKindOfClass:[NSNumber class]]) {
            self.numberOfVotes = [(NSNumber *)[dictionary objectForKey:@"number_of_votes"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"descrition"] && ![[dictionary objectForKey:@"descrition"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"descrition"] isKindOfClass:[NSString class]]) {
            self.descrition = [dictionary objectForKey:@"descrition"];
        }
        
        if (nil != [dictionary objectForKey:@"title"] && ![[dictionary objectForKey:@"title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"title"] isKindOfClass:[NSString class]]) {
            self.title = [dictionary objectForKey:@"title"];
        }
        
        if (nil != [dictionary objectForKey:@"find_uuid"] && ![[dictionary objectForKey:@"find_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"find_uuid"] isKindOfClass:[NSString class]]) {
            self.findUuid = [dictionary objectForKey:@"find_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"images"] && ![[dictionary objectForKey:@"images"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"images"] isKindOfClass:[NSString class]]) {
            self.images = [dictionary objectForKey:@"images"];
        }
        
        
        if (nil != [dictionary objectForKey:@"has_praised"] && ![[dictionary objectForKey:@"has_praised"] isEqual:[NSNull null]]) {
            self.hasPraised = [(NSNumber *)[dictionary objectForKey:@"has_praised"] boolValue];
        }
        
        
    }
    
    return self;
}

@end
