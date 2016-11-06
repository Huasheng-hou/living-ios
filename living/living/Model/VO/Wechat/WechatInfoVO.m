//
//  WechatInfoVO.m
//  living
//
//  Created by Huasheng on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "WechatInfoVO.h"

@implementation WechatInfoVO

+ (WechatInfoVO *)WechatInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [WechatInfoVO WechatInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (WechatInfoVO *)WechatInfoVOWithDictionary:(NSDictionary *)dictionary
{
    WechatInfoVO *instance = [[WechatInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"openid"] && ![[dictionary objectForKey:@"openid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"openid"] isKindOfClass:[NSString class]]) {
            self.OpenId = [dictionary objectForKey:@"openid"];
        }
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.NickName = [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"sex"] && ![[dictionary objectForKey:@"sex"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sex"] isKindOfClass:[NSNumber class]]) {
            self.sex = [(NSNumber *)[dictionary objectForKey:@"sex"] intValue];
        }
        
        if (nil != [dictionary objectForKey:@"province"] && ![[dictionary objectForKey:@"province"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"province"] isKindOfClass:[NSString class]]) {
            self.Province = [dictionary objectForKey:@"province"];
        }
        
        if (nil != [dictionary objectForKey:@"city"] && ![[dictionary objectForKey:@"city"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"city"] isKindOfClass:[NSString class]]) {
            self.City = [dictionary objectForKey:@"city"];
        }
        
        if (nil != [dictionary objectForKey:@"country"] && ![[dictionary objectForKey:@"country"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"country"] isKindOfClass:[NSString class]]) {
            self.Country = [dictionary objectForKey:@"country"];
        }
        
        if (nil != [dictionary objectForKey:@"headimgurl"] && ![[dictionary objectForKey:@"headimgurl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"headimgurl"] isKindOfClass:[NSString class]]) {
            self.HeadImgUrl = [dictionary objectForKey:@"headimgurl"];
        }
        
        if (nil != [dictionary objectForKey:@"privilege"] && ![[dictionary objectForKey:@"privilege"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"privilege"] isKindOfClass:[NSArray class]]) {
            self.Privilege = [dictionary objectForKey:@"privilege"];
        }
        
        if (nil != [dictionary objectForKey:@"unionid"] && ![[dictionary objectForKey:@"unionid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"unionid"] isKindOfClass:[NSString class]]) {
            self.UnionId = [dictionary objectForKey:@"unionid"];
        }
        
    }
    
    return self;
}

@end
