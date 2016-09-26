//
//  HeadVO.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "HeadVO.h"

@implementation HeadVO

+ (HeadVO *)HeadVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [HeadVO HeadVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (HeadVO *)HeadVOWithDictionary:(NSDictionary *)dictionary
{
    HeadVO *instance = [[HeadVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"returnCode"] && ![[dictionary objectForKey:@"returnCode"] isEqual:[NSNull null]]) {
            self.Code = [dictionary objectForKey:@"returnCode"];
            
            self.SysCode = [[self.Code substringWithRange:NSMakeRange(0,1)] intValue];
            self.UserCode = [[self.Code substringWithRange:NSMakeRange(1,1)] intValue];
            self.ResCode = [[self.Code substringWithRange:NSMakeRange(2,1)] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"returnDescription"] && ![[dictionary objectForKey:@"returnDescription"] isEqual:[NSNull null]]) {
            self.Desc = [dictionary objectForKey:@"returnDescription"];
        }
    }
    
    return self;
}

@end
