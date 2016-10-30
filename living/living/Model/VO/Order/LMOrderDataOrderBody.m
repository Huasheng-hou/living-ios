//
//  LMOrderDataOrderBody.m
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMOrderDataOrderBody.h"


NSString *const kLMOrderDataOrderBodyNumber = @"number";
NSString *const kLMOrderDataOrderBodyEventName = @"event_name";
NSString *const kLMOrderDataOrderBodyTotalMoney = @"totalMoney";
NSString *const kLMOrderDataOrderBodyPrice = @"price";
NSString *const kLMOrderDataOrderBodyOrderUuid = @"order_uuid";
NSString *const kLMOrderDataOrderBodyEventUuid = @"event_uuid";
NSString *const kLMOrderDataOrderBodyOrderTime = @"order_time";


@interface LMOrderDataOrderBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMOrderDataOrderBody

@synthesize number = _number;
@synthesize eventName = _eventName;
@synthesize totalMoney = _totalMoney;
@synthesize price = _price;
@synthesize orderUuid = _orderUuid;
@synthesize eventUuid = _eventUuid;
@synthesize orderTime = _orderTime;


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
            self.number = [[self objectOrNilForKey:kLMOrderDataOrderBodyNumber fromDictionary:dict] doubleValue];
            self.eventName = [self objectOrNilForKey:kLMOrderDataOrderBodyEventName fromDictionary:dict];
            self.totalMoney = [self objectOrNilForKey:kLMOrderDataOrderBodyTotalMoney fromDictionary:dict];
            self.price = [self objectOrNilForKey:kLMOrderDataOrderBodyPrice fromDictionary:dict];
            self.orderUuid = [self objectOrNilForKey:kLMOrderDataOrderBodyOrderUuid fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMOrderDataOrderBodyEventUuid fromDictionary:dict];
            self.orderTime = [self objectOrNilForKey:kLMOrderDataOrderBodyOrderTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kLMOrderDataOrderBodyNumber];
    [mutableDict setValue:self.eventName forKey:kLMOrderDataOrderBodyEventName];
    [mutableDict setValue:self.totalMoney forKey:kLMOrderDataOrderBodyTotalMoney];
    [mutableDict setValue:self.price forKey:kLMOrderDataOrderBodyPrice];
    [mutableDict setValue:self.orderUuid forKey:kLMOrderDataOrderBodyOrderUuid];
    [mutableDict setValue:self.eventUuid forKey:kLMOrderDataOrderBodyEventUuid];
    [mutableDict setValue:self.orderTime forKey:kLMOrderDataOrderBodyOrderTime];

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

    self.number = [aDecoder decodeDoubleForKey:kLMOrderDataOrderBodyNumber];
    self.eventName = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyEventName];
    self.totalMoney = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyTotalMoney];
    self.price = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyPrice];
    self.orderUuid = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyOrderUuid];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyEventUuid];
    self.orderTime = [aDecoder decodeObjectForKey:kLMOrderDataOrderBodyOrderTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_number forKey:kLMOrderDataOrderBodyNumber];
    [aCoder encodeObject:_eventName forKey:kLMOrderDataOrderBodyEventName];
    [aCoder encodeObject:_totalMoney forKey:kLMOrderDataOrderBodyTotalMoney];
    [aCoder encodeObject:_price forKey:kLMOrderDataOrderBodyPrice];
    [aCoder encodeObject:_orderUuid forKey:kLMOrderDataOrderBodyOrderUuid];
    [aCoder encodeObject:_eventUuid forKey:kLMOrderDataOrderBodyEventUuid];
    [aCoder encodeObject:_orderTime forKey:kLMOrderDataOrderBodyOrderTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMOrderDataOrderBody *copy = [[LMOrderDataOrderBody alloc] init];
    
    if (copy) {

        copy.number = self.number;
        copy.eventName = [self.eventName copyWithZone:zone];
        copy.totalMoney = [self.totalMoney copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.orderUuid = [self.orderUuid copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.orderTime = [self.orderTime copyWithZone:zone];
    }
    
    return copy;
}


@end
