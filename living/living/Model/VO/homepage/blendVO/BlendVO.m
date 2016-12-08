//
//  BlendVO.m
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "BlendVO.h"

@implementation BlendVO

+ (BlendVO *)BlendVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [BlendVO BlendVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (BlendVO *)BlendVOWithDictionary:(NSDictionary *)dictionary
{
    BlendVO *instance = [[BlendVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)BlendVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[BlendVO BlendVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {

        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
  
        if (dictionary[@"images"] && [dictionary[@"images"] isKindOfClass:[NSArray class]]) {
            self.images = dictionary[@"images"];
        }
    }
    return self;
}

@end

