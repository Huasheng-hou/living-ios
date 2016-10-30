//
//  LMOrderDataOrderInfo.m
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMOrderDataOrderInfo.h"


NSString *const kLMOrderDataOrderInfoEndTime = @"end_time";
NSString *const kLMOrderDataOrderInfoEventName = @"event_name";
NSString *const kLMOrderDataOrderInfoTotalMoney = @"totalMoney";
NSString *const kLMOrderDataOrderInfoStartTime = @"start_time";
NSString *const kLMOrderDataOrderInfoEventAddress = @"event_address";
NSString *const kLMOrderDataOrderInfoAveragePrice = @"average_price";
NSString *const kLMOrderDataOrderInfoJoinNumber = @"join_number";
NSString *const kLMOrderDataOrderInfoOrderNumber = @"order_number";
NSString *const kLMOrderDataOrderInfoEventUuid = @"event_uuid";
NSString *const kLMOrderDataOrderInfoOrderUuid = @"order_uuid";


@interface LMOrderDataOrderInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMOrderDataOrderInfo

@synthesize endTime = _endTime;
@synthesize eventName = _eventName;
@synthesize totalMoney = _totalMoney;
@synthesize startTime = _startTime;
@synthesize eventAddress = _eventAddress;
@synthesize averagePrice = _averagePrice;
@synthesize joinNumber = _joinNumber;
@synthesize orderNumber = _orderNumber;
@synthesize eventUuid = _eventUuid;
@synthesize orderUuid = _orderUuid;


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
            self.endTime = [self objectOrNilForKey:kLMOrderDataOrderInfoEndTime fromDictionary:dict];
            self.eventName = [self objectOrNilForKey:kLMOrderDataOrderInfoEventName fromDictionary:dict];
            self.totalMoney = [self objectOrNilForKey:kLMOrderDataOrderInfoTotalMoney fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kLMOrderDataOrderInfoStartTime fromDictionary:dict];
            self.eventAddress = [self objectOrNilForKey:kLMOrderDataOrderInfoEventAddress fromDictionary:dict];
            self.averagePrice = [self objectOrNilForKey:kLMOrderDataOrderInfoAveragePrice fromDictionary:dict];
            self.joinNumber = [[self objectOrNilForKey:kLMOrderDataOrderInfoJoinNumber fromDictionary:dict] doubleValue];
            self.orderNumber = [self objectOrNilForKey:kLMOrderDataOrderInfoOrderNumber fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMOrderDataOrderInfoEventUuid fromDictionary:dict];
            self.orderUuid = [self objectOrNilForKey:kLMOrderDataOrderInfoOrderUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.endTime forKey:kLMOrderDataOrderInfoEndTime];
    [mutableDict setValue:self.eventName forKey:kLMOrderDataOrderInfoEventName];
    [mutableDict setValue:self.totalMoney forKey:kLMOrderDataOrderInfoTotalMoney];
    [mutableDict setValue:self.startTime forKey:kLMOrderDataOrderInfoStartTime];
    [mutableDict setValue:self.eventAddress forKey:kLMOrderDataOrderInfoEventAddress];
    [mutableDict setValue:self.averagePrice forKey:kLMOrderDataOrderInfoAveragePrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.joinNumber] forKey:kLMOrderDataOrderInfoJoinNumber];
    [mutableDict setValue:self.orderNumber forKey:kLMOrderDataOrderInfoOrderNumber];
    [mutableDict setValue:self.eventUuid forKey:kLMOrderDataOrderInfoEventUuid];
    [mutableDict setValue:self.orderUuid forKey:kLMOrderDataOrderInfoOrderUuid];

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

    self.endTime = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoEndTime];
    self.eventName = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoEventName];
    self.totalMoney = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoTotalMoney];
    self.startTime = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoStartTime];
    self.eventAddress = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoEventAddress];
    self.averagePrice = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoAveragePrice];
    self.joinNumber = [aDecoder decodeDoubleForKey:kLMOrderDataOrderInfoJoinNumber];
    self.orderNumber = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoOrderNumber];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoEventUuid];
    self.orderUuid = [aDecoder decodeObjectForKey:kLMOrderDataOrderInfoOrderUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_endTime forKey:kLMOrderDataOrderInfoEndTime];
    [aCoder encodeObject:_eventName forKey:kLMOrderDataOrderInfoEventName];
    [aCoder encodeObject:_totalMoney forKey:kLMOrderDataOrderInfoTotalMoney];
    [aCoder encodeObject:_startTime forKey:kLMOrderDataOrderInfoStartTime];
    [aCoder encodeObject:_eventAddress forKey:kLMOrderDataOrderInfoEventAddress];
    [aCoder encodeObject:_averagePrice forKey:kLMOrderDataOrderInfoAveragePrice];
    [aCoder encodeDouble:_joinNumber forKey:kLMOrderDataOrderInfoJoinNumber];
    [aCoder encodeObject:_orderNumber forKey:kLMOrderDataOrderInfoOrderNumber];
    [aCoder encodeObject:_eventUuid forKey:kLMOrderDataOrderInfoEventUuid];
    [aCoder encodeObject:_orderUuid forKey:kLMOrderDataOrderInfoOrderUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMOrderDataOrderInfo *copy = [[LMOrderDataOrderInfo alloc] init];
    
    if (copy) {

        copy.endTime = [self.endTime copyWithZone:zone];
        copy.eventName = [self.eventName copyWithZone:zone];
        copy.totalMoney = [self.totalMoney copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.eventAddress = [self.eventAddress copyWithZone:zone];
        copy.averagePrice = [self.averagePrice copyWithZone:zone];
        copy.joinNumber = self.joinNumber;
        copy.orderNumber = [self.orderNumber copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.orderUuid = [self.orderUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
