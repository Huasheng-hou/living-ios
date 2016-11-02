//
//  UserInfo.m
//
//  Created by   on 16/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMUserInfo.h"


NSString *const kUserInfoGender = @"gender";
NSString *const kUserInfoNickName = @"nick_name";
NSString *const kUserInfoCity = @"city";
NSString *const kUserInfoAvatar = @"avatar";
NSString *const kUserInfoEventNum = @"event_num";
NSString *const kUserInfoBalance = @"balance";
NSString *const kUserInfoBirthday = @"birthday";
NSString *const kUserInfoOrderNumber = @"order_number";
NSString *const kUserInfoTotalEventNum = @"total_event_num";
NSString *const kUserInfoProvince = @"province";
NSString *const kUserInfoLivingUuid = @"livingUuid";

@interface LMUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMUserInfo

@synthesize gender = _gender;
@synthesize nickName = _nickName;
@synthesize city = _city;
@synthesize avatar = _avatar;
@synthesize eventNum = _eventNum;
@synthesize balance = _balance;
@synthesize birthday = _birthday;
@synthesize orderNumber = _orderNumber;
@synthesize totalEventNum = _totalEventNum;
@synthesize province = _province;
@synthesize livingUuid = _livingUuid;

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
        self.gender = [self objectOrNilForKey:kUserInfoGender fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kUserInfoNickName fromDictionary:dict];
        self.city = [self objectOrNilForKey:kUserInfoCity fromDictionary:dict];
        self.avatar = [self objectOrNilForKey:kUserInfoAvatar fromDictionary:dict];
        self.eventNum = [self objectOrNilForKey:kUserInfoEventNum fromDictionary:dict];
        self.balance = [[self objectOrNilForKey:kUserInfoBalance fromDictionary:dict] doubleValue];
        self.birthday = [self objectOrNilForKey:kUserInfoBirthday fromDictionary:dict];
        self.orderNumber = [[self objectOrNilForKey:kUserInfoOrderNumber fromDictionary:dict] doubleValue];
        self.totalEventNum = [self objectOrNilForKey:kUserInfoTotalEventNum fromDictionary:dict];
        self.province = [self objectOrNilForKey:kUserInfoProvince fromDictionary:dict];
        self.livingUuid = [self objectOrNilForKey:kUserInfoLivingUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.gender forKey:kUserInfoGender];
    [mutableDict setValue:self.nickName forKey:kUserInfoNickName];
    [mutableDict setValue:self.city forKey:kUserInfoCity];
    [mutableDict setValue:self.avatar forKey:kUserInfoAvatar];
    [mutableDict setValue:self.eventNum forKey:kUserInfoEventNum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.balance] forKey:kUserInfoBalance];
    [mutableDict setValue:self.birthday forKey:kUserInfoBirthday];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderNumber] forKey:kUserInfoOrderNumber];
    [mutableDict setValue:self.totalEventNum forKey:kUserInfoTotalEventNum];
    [mutableDict setValue:self.province forKey:kUserInfoProvince];
    [mutableDict setValue:self.livingUuid forKey:kUserInfoLivingUuid];

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

    self.gender = [aDecoder decodeObjectForKey:kUserInfoGender];
    self.nickName = [aDecoder decodeObjectForKey:kUserInfoNickName];
    self.city = [aDecoder decodeObjectForKey:kUserInfoCity];
    self.avatar = [aDecoder decodeObjectForKey:kUserInfoAvatar];
    self.eventNum = [aDecoder decodeObjectForKey:kUserInfoEventNum];
    self.balance = [aDecoder decodeDoubleForKey:kUserInfoBalance];
    self.birthday = [aDecoder decodeObjectForKey:kUserInfoBirthday];
    self.orderNumber = [aDecoder decodeDoubleForKey:kUserInfoOrderNumber];
    self.totalEventNum = [aDecoder decodeObjectForKey:kUserInfoTotalEventNum];
    self.province = [aDecoder decodeObjectForKey:kUserInfoProvince];
    self.livingUuid = [aDecoder decodeObjectForKey:kUserInfoLivingUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_gender forKey:kUserInfoGender];
    [aCoder encodeObject:_nickName forKey:kUserInfoNickName];
    [aCoder encodeObject:_city forKey:kUserInfoCity];
    [aCoder encodeObject:_avatar forKey:kUserInfoAvatar];
    [aCoder encodeObject:_eventNum forKey:kUserInfoEventNum];
    [aCoder encodeDouble:_balance forKey:kUserInfoBalance];
    [aCoder encodeObject:_birthday forKey:kUserInfoBirthday];
    [aCoder encodeDouble:_orderNumber forKey:kUserInfoOrderNumber];
    [aCoder encodeObject:_totalEventNum forKey:kUserInfoTotalEventNum];
    [aCoder encodeObject:_province forKey:kUserInfoProvince];
    [aCoder encodeObject:_livingUuid forKey:kUserInfoLivingUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMUserInfo *copy = [[LMUserInfo alloc] init];
    
    if (copy) {

        copy.gender = [self.gender copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
        copy.eventNum = [self.eventNum copyWithZone:zone];
        copy.balance = self.balance;
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.orderNumber = self.orderNumber;
        copy.totalEventNum = [self.totalEventNum copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.livingUuid = [self.livingUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
