//
//  LMActivityList.m
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMActivityList.h"


NSString *const kLMActivityListAddress = @"address";
NSString *const kLMActivityListEventName = @"event_name";
NSString *const kLMActivityListCurrentNum = @"current_num";
NSString *const kLMActivityListTotalnum = @"total_num";
NSString *const kLMActivityListStartTime = @"start_time";
NSString *const kLMActivityListUserUuid = @"user_uuid";
NSString *const kLMActivityListPerCost = @"per_cost";
NSString *const kLMActivityListEventImg = @"event_img";
NSString *const kLMActivityListEventUuid = @"event_uuid";
NSString *const kLMActivityListAvatar = @"avatar";
NSString *const kLMActivityListNickname = @"nick_name";


@interface LMActivityList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMActivityList

@synthesize address = _address;
@synthesize eventName = _eventName;
@synthesize currentNum = _currentNum;
@synthesize totalnum = _totalnum;
@synthesize startTime = _startTime;
@synthesize userUuid = _userUuid;
@synthesize perCost = _perCost;
@synthesize eventImg = _eventImg;
@synthesize eventUuid = _eventUuid;
@synthesize avatar = _avatar;
@synthesize nickNname = _nickNname;



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
            self.address = [self objectOrNilForKey:kLMActivityListAddress fromDictionary:dict];
            self.eventName = [self objectOrNilForKey:kLMActivityListEventName fromDictionary:dict];
            self.currentNum = [[self objectOrNilForKey:kLMActivityListCurrentNum fromDictionary:dict] doubleValue];
            self.totalnum = [[self objectOrNilForKey:kLMActivityListTotalnum fromDictionary:dict] doubleValue];
            self.startTime = [self objectOrNilForKey:kLMActivityListStartTime fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMActivityListUserUuid fromDictionary:dict];
            self.perCost = [self objectOrNilForKey:kLMActivityListPerCost fromDictionary:dict];
            self.eventImg = [self objectOrNilForKey:kLMActivityListEventImg fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMActivityListEventUuid fromDictionary:dict];
            self.avatar = [self objectOrNilForKey:kLMActivityListAvatar fromDictionary:dict];
            self.nickNname = [self objectOrNilForKey:kLMActivityListNickname fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kLMActivityListAddress];
    [mutableDict setValue:self.eventName forKey:kLMActivityListEventName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentNum] forKey:kLMActivityListCurrentNum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalnum] forKey:kLMActivityListTotalnum];
    [mutableDict setValue:self.startTime forKey:kLMActivityListStartTime];
    [mutableDict setValue:self.userUuid forKey:kLMActivityListUserUuid];
    [mutableDict setValue:self.perCost forKey:kLMActivityListPerCost];
    [mutableDict setValue:self.eventImg forKey:kLMActivityListEventImg];
    [mutableDict setValue:self.eventUuid forKey:kLMActivityListEventUuid];
    [mutableDict setValue:self.avatar forKey:kLMActivityListAvatar];
    [mutableDict setValue:self.nickNname forKey:kLMActivityListNickname];

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

    self.address = [aDecoder decodeObjectForKey:kLMActivityListAddress];
    self.eventName = [aDecoder decodeObjectForKey:kLMActivityListEventName];
    self.currentNum = [aDecoder decodeDoubleForKey:kLMActivityListCurrentNum];
    self.totalnum = [aDecoder decodeDoubleForKey:kLMActivityListTotalnum];
    self.startTime = [aDecoder decodeObjectForKey:kLMActivityListStartTime];
    self.userUuid = [aDecoder decodeObjectForKey:kLMActivityListUserUuid];
    self.perCost = [aDecoder decodeObjectForKey:kLMActivityListPerCost];
    self.eventImg = [aDecoder decodeObjectForKey:kLMActivityListEventImg];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMActivityListEventUuid];
    self.nickNname = [aDecoder decodeObjectForKey:kLMActivityListNickname];
    self.avatar = [aDecoder decodeObjectForKey:kLMActivityListAvatar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kLMActivityListAddress];
    [aCoder encodeObject:_eventName forKey:kLMActivityListEventName];
    [aCoder encodeDouble:_currentNum forKey:kLMActivityListCurrentNum];
    [aCoder encodeDouble:_totalnum forKey:kLMActivityListTotalnum];
    [aCoder encodeObject:_startTime forKey:kLMActivityListStartTime];
    [aCoder encodeObject:_userUuid forKey:kLMActivityListUserUuid];
    [aCoder encodeObject:_perCost forKey:kLMActivityListPerCost];
    [aCoder encodeObject:_eventImg forKey:kLMActivityListEventImg];
    [aCoder encodeObject:_nickNname forKey:kLMActivityListNickname];
    [aCoder encodeObject:_avatar forKey:kLMActivityListAvatar];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMActivityList *copy = [[LMActivityList alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.eventName = [self.eventName copyWithZone:zone];
        copy.currentNum = self.currentNum;
        copy.totalnum = self.totalnum;
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.perCost = [self.perCost copyWithZone:zone];
        copy.eventImg = [self.eventImg copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
        copy.nickNname = [self.nickNname copyWithZone:zone];
    }
    
    return copy;
}


@end
