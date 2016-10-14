//
//  LMEventDetailEventBody.m
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMEventDetailEventBody.h"


NSString *const kLMEventDetailEventBodyPublishName = @"publish_name";
NSString *const kLMEventDetailEventBodyPublishAvatar = @"publish_avatar";
NSString *const kLMEventDetailEventBodyContactPhone = @"contact_phone";
NSString *const kLMEventDetailEventBodyUserUuid = @"user_uuid";
NSString *const kLMEventDetailEventBodyEventName = @"event_name";
NSString *const kLMEventDetailEventBodyStartTime = @"start_time";
NSString *const kLMEventDetailEventBodyTotalNumber = @"total_number";
NSString *const kLMEventDetailEventBodyTotalNum = @"total_num";
NSString *const kLMEventDetailEventBodyEventImg = @"event_img";
NSString *const kLMEventDetailEventBodyAddress = @"address";
NSString *const kLMEventDetailEventBodyEventUuid = @"event_uuid";
NSString *const kLMEventDetailEventBodyEndTime = @"end_time";
NSString *const kLMEventDetailEventBodyPerCost = @"per_cost";
NSString *const kLMEventDetailEventBodyContactName = @"contact_name";


@interface LMEventDetailEventBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMEventDetailEventBody

@synthesize publishName = _publishName;
@synthesize publishAvatar = _publishAvatar;
@synthesize contactPhone = _contactPhone;
@synthesize userUuid = _userUuid;
@synthesize eventName = _eventName;
@synthesize startTime = _startTime;
@synthesize totalNumber = _totalNumber;
@synthesize totalNum = _totalNum;
@synthesize eventImg = _eventImg;
@synthesize address = _address;
@synthesize eventUuid = _eventUuid;
@synthesize endTime = _endTime;
@synthesize perCost = _perCost;
@synthesize contactName = _contactName;


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
            self.publishName = [self objectOrNilForKey:kLMEventDetailEventBodyPublishName fromDictionary:dict];
            self.publishAvatar = [self objectOrNilForKey:kLMEventDetailEventBodyPublishAvatar fromDictionary:dict];
            self.contactPhone = [self objectOrNilForKey:kLMEventDetailEventBodyContactPhone fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMEventDetailEventBodyUserUuid fromDictionary:dict];
            self.eventName = [self objectOrNilForKey:kLMEventDetailEventBodyEventName fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kLMEventDetailEventBodyStartTime fromDictionary:dict];
            self.totalNumber = [[self objectOrNilForKey:kLMEventDetailEventBodyTotalNumber fromDictionary:dict] doubleValue];
            self.totalNum = [[self objectOrNilForKey:kLMEventDetailEventBodyTotalNum fromDictionary:dict] doubleValue];
            self.eventImg = [self objectOrNilForKey:kLMEventDetailEventBodyEventImg fromDictionary:dict];
            self.address = [self objectOrNilForKey:kLMEventDetailEventBodyAddress fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMEventDetailEventBodyEventUuid fromDictionary:dict];
            self.endTime = [self objectOrNilForKey:kLMEventDetailEventBodyEndTime fromDictionary:dict];
            self.perCost = [self objectOrNilForKey:kLMEventDetailEventBodyPerCost fromDictionary:dict];
            self.contactName = [self objectOrNilForKey:kLMEventDetailEventBodyContactName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.publishName forKey:kLMEventDetailEventBodyPublishName];
    [mutableDict setValue:self.publishAvatar forKey:kLMEventDetailEventBodyPublishAvatar];
    [mutableDict setValue:self.contactPhone forKey:kLMEventDetailEventBodyContactPhone];
    [mutableDict setValue:self.userUuid forKey:kLMEventDetailEventBodyUserUuid];
    [mutableDict setValue:self.eventName forKey:kLMEventDetailEventBodyEventName];
    [mutableDict setValue:self.startTime forKey:kLMEventDetailEventBodyStartTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNumber] forKey:kLMEventDetailEventBodyTotalNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNum] forKey:kLMEventDetailEventBodyTotalNum];
    [mutableDict setValue:self.eventImg forKey:kLMEventDetailEventBodyEventImg];
    [mutableDict setValue:self.address forKey:kLMEventDetailEventBodyAddress];
    [mutableDict setValue:self.eventUuid forKey:kLMEventDetailEventBodyEventUuid];
    [mutableDict setValue:self.endTime forKey:kLMEventDetailEventBodyEndTime];
    [mutableDict setValue:self.perCost forKey:kLMEventDetailEventBodyPerCost];
    [mutableDict setValue:self.contactName forKey:kLMEventDetailEventBodyContactName];

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

    self.publishName = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyPublishName];
    self.publishAvatar = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyPublishAvatar];
    self.contactPhone = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyContactPhone];
    self.userUuid = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyUserUuid];
    self.eventName = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyEventName];
    self.startTime = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyStartTime];
    self.totalNumber = [aDecoder decodeDoubleForKey:kLMEventDetailEventBodyTotalNumber];
    self.totalNum = [aDecoder decodeDoubleForKey:kLMEventDetailEventBodyTotalNum];
    self.eventImg = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyEventImg];
    self.address = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyAddress];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyEventUuid];
    self.endTime = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyEndTime];
    self.perCost = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyPerCost];
    self.contactName = [aDecoder decodeObjectForKey:kLMEventDetailEventBodyContactName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_publishName forKey:kLMEventDetailEventBodyPublishName];
    [aCoder encodeObject:_publishAvatar forKey:kLMEventDetailEventBodyPublishAvatar];
    [aCoder encodeObject:_contactPhone forKey:kLMEventDetailEventBodyContactPhone];
    [aCoder encodeObject:_userUuid forKey:kLMEventDetailEventBodyUserUuid];
    [aCoder encodeObject:_eventName forKey:kLMEventDetailEventBodyEventName];
    [aCoder encodeObject:_startTime forKey:kLMEventDetailEventBodyStartTime];
    [aCoder encodeDouble:_totalNumber forKey:kLMEventDetailEventBodyTotalNumber];
    [aCoder encodeDouble:_totalNum forKey:kLMEventDetailEventBodyTotalNum];
    [aCoder encodeObject:_eventImg forKey:kLMEventDetailEventBodyEventImg];
    [aCoder encodeObject:_address forKey:kLMEventDetailEventBodyAddress];
    [aCoder encodeObject:_eventUuid forKey:kLMEventDetailEventBodyEventUuid];
    [aCoder encodeObject:_endTime forKey:kLMEventDetailEventBodyEndTime];
    [aCoder encodeObject:_perCost forKey:kLMEventDetailEventBodyPerCost];
    [aCoder encodeObject:_contactName forKey:kLMEventDetailEventBodyContactName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMEventDetailEventBody *copy = [[LMEventDetailEventBody alloc] init];
    
    if (copy) {

        copy.publishName = [self.publishName copyWithZone:zone];
        copy.publishAvatar = [self.publishAvatar copyWithZone:zone];
        copy.contactPhone = [self.contactPhone copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.eventName = [self.eventName copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.totalNumber = self.totalNumber;
        copy.totalNum = self.totalNum;
        copy.eventImg = [self.eventImg copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.endTime = [self.endTime copyWithZone:zone];
        copy.perCost = [self.perCost copyWithZone:zone];
        copy.contactName = [self.contactName copyWithZone:zone];
    }
    
    return copy;
}


@end
