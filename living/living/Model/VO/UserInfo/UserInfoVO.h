
//
//  UserInfoVO.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/27.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface UserInfoVO : NSObject

+ (UserInfoVO *)UserInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (UserInfoVO *)UserInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)UserInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *eventNum;
@property (nonatomic, assign) float balance;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) int orderNumber;
@property (nonatomic, strong) NSString *totalEventNum;
@property (nonatomic, strong) NSString *franchisee;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *prove;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *privileges;
@property (nonatomic, strong) NSString *livingUuid;
@property (nonatomic, assign) int livingNumber;
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *endTime;

@end
