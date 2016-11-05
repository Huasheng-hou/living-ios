//
//  LMFriendList.m
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMFriendList.h"


NSString *const kLMFriendListAvatar = @"avatar";
NSString *const kLMFriendListNickname = @"nickname";
NSString *const kLMFriendListUserUuid = @"user_uuid";
NSString *const kLMFriendListAddress = @"address";


@interface LMFriendList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMFriendList

@synthesize avatar = _avatar;
@synthesize nickname = _nickname;
@synthesize userUuid = _userUuid;
@synthesize address = _address;


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
            self.avatar = [self objectOrNilForKey:kLMFriendListAvatar fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kLMFriendListNickname fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMFriendListUserUuid fromDictionary:dict];
            self.address = [self objectOrNilForKey:kLMFriendListAddress fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kLMFriendListAvatar];
    [mutableDict setValue:self.nickname forKey:kLMFriendListNickname];
    [mutableDict setValue:self.userUuid forKey:kLMFriendListUserUuid];
    [mutableDict setValue:self.address forKey:kLMFriendListAddress];

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

    self.avatar = [aDecoder decodeObjectForKey:kLMFriendListAvatar];
    self.nickname = [aDecoder decodeObjectForKey:kLMFriendListNickname];
    self.userUuid = [aDecoder decodeObjectForKey:kLMFriendListUserUuid];
    self.address = [aDecoder decodeObjectForKey:kLMFriendListAddress];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kLMFriendListAvatar];
    [aCoder encodeObject:_nickname forKey:kLMFriendListNickname];
    [aCoder encodeObject:_userUuid forKey:kLMFriendListUserUuid];
    [aCoder encodeObject:_address forKey:kLMFriendListAddress];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMFriendList *copy = [[LMFriendList alloc] init];
    
    if (copy) {

        copy.avatar = [self.avatar copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
    }
    
    return copy;
}


@end
