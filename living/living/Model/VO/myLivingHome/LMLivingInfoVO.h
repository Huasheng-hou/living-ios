//
//  LMLivingInfoVO.h
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMLivingInfoVO : NSObject

+ (LMLivingInfoVO *)LMLivingInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMLivingInfoVO *)LMLivingInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMLivingInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *livingImage;
@property (nonatomic, strong) NSString *livingName;
@property (nonatomic, strong) NSString *livingTitle;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *livingUuid;
@property (nonatomic, strong) NSString *balance;


@end
