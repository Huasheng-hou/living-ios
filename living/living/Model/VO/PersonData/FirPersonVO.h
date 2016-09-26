//
//  FirPersonVO.h
//  firefly
//
//  Created by Ding on 16/7/4.
//  Copyright © 2016年 Huasheng. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UserInfoVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface FirPersonVO : NSObject

@property (nonatomic, strong) NSString *staffID;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) NSString *updateDatetime;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) double createDatetime;
@property (nonatomic, strong) NSString *employeeUuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSString *joinDatetime;
@property (nonatomic, strong) NSString *homePhone;
@property (nonatomic, strong) NSString *identityNumber;
@property (nonatomic, strong) NSArray *privileges;
@property (nonatomic, strong) NSString *roleType;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSArray *departmentUuid;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *roleUuid;
@property (nonatomic, strong) NSString *address;



//- (FirPersonVO *)initWithDic:(NSDictionary *)dic;
@end