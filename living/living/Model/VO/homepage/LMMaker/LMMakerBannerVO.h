//
//  LMMakerBannerVO.h
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif
@interface LMMakerBannerVO : NSObject

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * webUrl;

+ (LMMakerBannerVO *)LMMakerBannerVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMMakerBannerVO *)LMMakerBannerVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMMakerBannerVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
