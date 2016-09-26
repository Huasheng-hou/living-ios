//
//  UserInfo.m
//
//  Created by   on 16/8/25
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "DYUserInfo.h"


NSString *const kUserInfoPhone = @"phone";
NSString *const kUserInfoUserUuid = @"user_uuid";
NSString *const kUserInfoCreatedAt = @"created_at";
NSString *const kUserInfoProvince = @"province";
NSString *const kUserInfoTotalQuestions = @"total_questions";
NSString *const kUserInfoTotalRewards = @"total_rewards";
NSString *const kUserInfoPassword = @"password";
NSString *const kUserInfoBirthday = @"birthday";
NSString *const kUserInfoCity = @"city";
NSString *const kUserInfoUpdatedAt = @"updated_at";
NSString *const kUserInfoTodayRewards = @"today_rewards";
NSString *const kUserInfoNickname = @"nickname";
NSString *const kUserInfoTodayQuestions = @"today_questions";
NSString *const kUserInfoGender = @"gender";
NSString *const kUserInfoAvatar = @"avatar";


@interface DYUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DYUserInfo

@synthesize phone = _phone;
@synthesize userUuid = _userUuid;
@synthesize createdAt = _createdAt;
@synthesize province = _province;
@synthesize totalQuestions = _totalQuestions;
@synthesize totalRewards = _totalRewards;
@synthesize password = _password;
@synthesize birthday = _birthday;
@synthesize city = _city;
@synthesize updatedAt = _updatedAt;
@synthesize todayRewards = _todayRewards;
@synthesize nickname = _nickname;
@synthesize todayQuestions = _todayQuestions;
@synthesize gender = _gender;
@synthesize avatar = _avatar;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.phone = [self objectOrNilForKey:kUserInfoPhone fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kUserInfoUserUuid fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kUserInfoCreatedAt fromDictionary:dict];
            self.province = [self objectOrNilForKey:kUserInfoProvince fromDictionary:dict];
            self.totalQuestions = [[self objectOrNilForKey:kUserInfoTotalQuestions fromDictionary:dict] doubleValue];
            self.totalRewards = [[self objectOrNilForKey:kUserInfoTotalRewards fromDictionary:dict] doubleValue];
            self.password = [self objectOrNilForKey:kUserInfoPassword fromDictionary:dict];
            self.birthday = [self objectOrNilForKey:kUserInfoBirthday fromDictionary:dict];
            self.city = [self objectOrNilForKey:kUserInfoCity fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kUserInfoUpdatedAt fromDictionary:dict];
            self.todayRewards = [[self objectOrNilForKey:kUserInfoTodayRewards fromDictionary:dict] doubleValue];
            self.nickname = [self objectOrNilForKey:kUserInfoNickname fromDictionary:dict];
            self.todayQuestions = [[self objectOrNilForKey:kUserInfoTodayQuestions fromDictionary:dict] doubleValue];
            self.gender = [[self objectOrNilForKey:kUserInfoGender fromDictionary:dict] doubleValue];
            self.avatar = [self objectOrNilForKey:kUserInfoAvatar fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.phone forKey:kUserInfoPhone];
    [mutableDict setValue:self.userUuid forKey:kUserInfoUserUuid];
    [mutableDict setValue:self.createdAt forKey:kUserInfoCreatedAt];
    [mutableDict setValue:self.province forKey:kUserInfoProvince];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalQuestions] forKey:kUserInfoTotalQuestions];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalRewards] forKey:kUserInfoTotalRewards];
    [mutableDict setValue:self.password forKey:kUserInfoPassword];
    [mutableDict setValue:self.birthday forKey:kUserInfoBirthday];
    [mutableDict setValue:self.city forKey:kUserInfoCity];
    [mutableDict setValue:self.updatedAt forKey:kUserInfoUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.todayRewards] forKey:kUserInfoTodayRewards];
    [mutableDict setValue:self.nickname forKey:kUserInfoNickname];
    [mutableDict setValue:[NSNumber numberWithDouble:self.todayQuestions] forKey:kUserInfoTodayQuestions];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kUserInfoGender];
    [mutableDict setValue:self.avatar forKey:kUserInfoAvatar];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.phone = [aDecoder decodeObjectForKey:kUserInfoPhone];
    self.userUuid = [aDecoder decodeObjectForKey:kUserInfoUserUuid];
    self.createdAt = [aDecoder decodeObjectForKey:kUserInfoCreatedAt];
    self.province = [aDecoder decodeObjectForKey:kUserInfoProvince];
    self.totalQuestions = [aDecoder decodeDoubleForKey:kUserInfoTotalQuestions];
    self.totalRewards = [aDecoder decodeDoubleForKey:kUserInfoTotalRewards];
    self.password = [aDecoder decodeObjectForKey:kUserInfoPassword];
    self.birthday = [aDecoder decodeObjectForKey:kUserInfoBirthday];
    self.city = [aDecoder decodeObjectForKey:kUserInfoCity];
    self.updatedAt = [aDecoder decodeObjectForKey:kUserInfoUpdatedAt];
    self.todayRewards = [aDecoder decodeDoubleForKey:kUserInfoTodayRewards];
    self.nickname = [aDecoder decodeObjectForKey:kUserInfoNickname];
    self.todayQuestions = [aDecoder decodeDoubleForKey:kUserInfoTodayQuestions];
    self.gender = [aDecoder decodeDoubleForKey:kUserInfoGender];
    self.avatar = [aDecoder decodeObjectForKey:kUserInfoAvatar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_phone forKey:kUserInfoPhone];
    [aCoder encodeObject:_userUuid forKey:kUserInfoUserUuid];
    [aCoder encodeObject:_createdAt forKey:kUserInfoCreatedAt];
    [aCoder encodeObject:_province forKey:kUserInfoProvince];
    [aCoder encodeDouble:_totalQuestions forKey:kUserInfoTotalQuestions];
    [aCoder encodeDouble:_totalRewards forKey:kUserInfoTotalRewards];
    [aCoder encodeObject:_password forKey:kUserInfoPassword];
    [aCoder encodeObject:_birthday forKey:kUserInfoBirthday];
    [aCoder encodeObject:_city forKey:kUserInfoCity];
    [aCoder encodeObject:_updatedAt forKey:kUserInfoUpdatedAt];
    [aCoder encodeDouble:_todayRewards forKey:kUserInfoTodayRewards];
    [aCoder encodeObject:_nickname forKey:kUserInfoNickname];
    [aCoder encodeDouble:_todayQuestions forKey:kUserInfoTodayQuestions];
    [aCoder encodeDouble:_gender forKey:kUserInfoGender];
    [aCoder encodeObject:_avatar forKey:kUserInfoAvatar];
}

- (id)copyWithZone:(NSZone *)zone
{
    DYUserInfo *copy = [[DYUserInfo alloc] init];
    
    if (copy) {

        copy.phone = [self.phone copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.totalQuestions = self.totalQuestions;
        copy.totalRewards = self.totalRewards;
        copy.password = [self.password copyWithZone:zone];
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.todayRewards = self.todayRewards;
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.todayQuestions = self.todayQuestions;
        copy.gender = self.gender;
        copy.avatar = [self.avatar copyWithZone:zone];
    }
    
    return copy;
}


@end
