//
//  PayloadVO.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "PayloadVO.h"

@implementation PayloadVO

+ (PayloadVO *)PayloadVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [PayloadVO PayloadVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (PayloadVO *)PayloadVOWithDictionary:(NSDictionary *)dictionary
{
    PayloadVO *instance = [[PayloadVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.Type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"detail"] && ![[dictionary objectForKey:@"detail"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"detail"] isKindOfClass:[NSDictionary class]]) {
            self.Detail = [dictionary objectForKey:@"detail"];
        }
    }
    
    return self;
}

@end
