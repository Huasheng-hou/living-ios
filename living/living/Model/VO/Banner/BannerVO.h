//
//  BannerVO.h
//  living
//
//  Created by JamHonyZ on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface BannerVO : NSObject

+ (BannerVO *)BannerVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (BannerVO *)BannerVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)BannerVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString       *ImgUrl;
@property(nonatomic, retain) NSString       *LinkUrl;
@property(nonatomic, retain) NSString       *KeyUUID;
@property(nonatomic, retain) NSString       *Type;
@property(nonatomic, retain) NSString       *webUrl;
@property(nonatomic, retain) NSString       *webTitle;

@end
