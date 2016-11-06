//
//  WechatInfoVO.h
//  living
//
//  Created by Huasheng on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface WechatInfoVO : NSObject

+ (WechatInfoVO *)WechatInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (WechatInfoVO *)WechatInfoVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property   (nonatomic, retain)     NSString       *OpenId;
@property   (nonatomic, retain)     NSString       *NickName;
@property   (nonatomic, assign)     int             sex;
@property   (nonatomic, retain)     NSString       *Province;
@property   (nonatomic, retain)     NSString       *City;
@property   (nonatomic, retain)     NSString       *Country;
@property   (nonatomic, retain)     NSString       *HeadImgUrl;
@property   (nonatomic, retain)     NSArray        *Privilege;
@property   (nonatomic, retain)     NSString       *UnionId;

@end
