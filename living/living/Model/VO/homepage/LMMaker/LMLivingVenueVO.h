//
//  LMLivingVenueVO.h
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMLivingVenueVO : NSObject

@property (nonatomic, copy) NSString * livingUuid;
@property (nonatomic, copy) NSString * livingName;
@property (nonatomic, copy) NSString * livingImage;

+ (LMLivingVenueVO *)LMLivingVenueVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMLivingVenueVO *)LMLivingVenueVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMLivingVenueVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
