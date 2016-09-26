//
//  UserInfo.h
//
//  Created by   on 16/8/25
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DYUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, assign) double totalQuestions;
@property (nonatomic, assign) double totalRewards;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double todayRewards;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) double todayQuestions;
@property (nonatomic, assign) double gender;
@property (nonatomic, strong) NSString *avatar;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
