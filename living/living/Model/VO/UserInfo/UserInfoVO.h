
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


@property(nonatomic, retain) NSString *Avatar;
@property(nonatomic, retain) NSString *UUID;
@property(nonatomic, retain) NSString *Username;
@property(nonatomic, retain) NSString *Name;
@property(nonatomic, retain) NSString *Address;
@property(nonatomic, retain) NSString *Firm;
@property(nonatomic, retain) NSString *Contact;
@property(nonatomic, retain) NSString *Gender;
@property(nonatomic, retain) NSString *StaffID;
@property(nonatomic, retain) NSString *Emp_uuid;
@property(nonatomic, retain) NSArray  *roleName;
@property(nonatomic, retain) NSArray  *department;
@property(nonatomic, retain) NSString *joinDateTime;
@property(nonatomic, retain) NSString *phone;
@property(nonatomic, retain) NSString *homePhone;

@end
