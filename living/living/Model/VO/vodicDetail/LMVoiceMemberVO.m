//
//  LMVoiceMemberVO.m
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMVoiceMemberVO.h"

@implementation LMVoiceMemberVO

+ (LMVoiceMemberVO *)LMVoiceMemberVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMVoiceMemberVO LMVoiceMemberVOWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMVoiceMemberVO *)LMVoiceMemberVOWithDictionary:(NSDictionary *)dictionary
{
    LMVoiceMemberVO *instance = [[LMVoiceMemberVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMVoiceMemberVOWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMVoiceMemberVO LMVoiceMemberVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"userId"] && ![[dictionary objectForKey:@"userId"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"userId"] isKindOfClass:[NSString class]]) {
            self.userId = [dictionary objectForKey:@"userId"];
        }
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.nickname= [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.address= [dictionary objectForKey:@"address"];
        }
        
        
    }
    return self;
}


@end
