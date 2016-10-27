
//
//  FitUserManager.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitUserManager : NSObject

+ (FitUserManager *)sharedUserManager;

@property   (retain, nonatomic)     NSString        *uuid;
@property   (retain, nonatomic)     NSString        *password;
@property   (retain, nonatomic)     NSString        *username;
@property   (retain, nonatomic)     NSString        *avatar;
@property   (retain, nonatomic)     NSString        *slogan;
@property   (retain, nonatomic)     NSString        *phone;
@property   (retain, nonatomic)     NSString        *age;
@property   (retain, nonatomic)     NSString        *gender;
@property   (retain, nonatomic)     NSString        *balance;
@property   (retain, nonatomic)     NSString        *tokenMoney;
@property   (retain, nonatomic)     NSString        *contact;
@property   (retain, nonatomic)     NSString        *address;
@property   (retain, nonatomic)     NSString        *firm;
@property   (retain, nonatomic)     NSString        *birthday;
@property   (retain, nonatomic)     NSString        *city;
@property   (retain, nonatomic)     NSString        *emp_uuid;

@property   (retain, nonatomic)     NSString        *privileges;
@property   (retain, nonatomic)     NSString        *name;
@property   (retain, nonatomic)     NSString        *province;

@property   (assign, nonatomic)     BOOL            isNew;

@property   (nonatomic,retain)     NSMutableArray    *tagArray;

- (BOOL)isLogin;
- (BOOL)logout;

- (BOOL)isRememberPsw;
- (BOOL)savePsw:(NSString *)psw;
- (NSString *)getPsw;

- (NSDictionary *)userInfo;
- (BOOL)updateUserInfo:(NSDictionary *)userData;
- (void)saveUserInnfo:(NSString *)value ForKey:(NSString *)key;

@end
