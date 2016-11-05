//
//  LMOrderList.m
//
//  Created by   on 16/10/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMOrderList.h"


NSString *const kLMOrderListAvatar = @"event_img";
NSString *const kLMOrderListOrderStatus = @"order_status";
NSString *const kLMOrderListEventName = @"event_name";
NSString *const kLMOrderListEventUuid = @"event_uuid";
NSString *const kLMOrderListOrderAmount = @"order_amount";
NSString *const kLMOrderListUserUuid = @"user_uuid";
NSString *const kLMOrderListPayStatus = @"pay_status";
NSString *const kLMOrderListOrderUuid = @"order_uuid";
NSString *const kLMOrderListOrderNumber = @"order_number";
NSString *const kLMOrderListOrderingTime = @"ordering_time";
NSString *const kLMOrderListNumber = @"numbers";


@interface LMOrderList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMOrderList

@synthesize avatar = _avatar;
@synthesize orderStatus = _orderStatus;
@synthesize eventName = _eventName;
@synthesize eventUuid = _eventUuid;
@synthesize orderAmount = _orderAmount;
@synthesize userUuid = _userUuid;
@synthesize payStatus = _payStatus;
@synthesize orderUuid = _orderUuid;
@synthesize orderNumber = _orderNumber;
@synthesize orderingTime = _orderingTime;
@synthesize number = _number;


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
            self.avatar = [self objectOrNilForKey:kLMOrderListAvatar fromDictionary:dict];
            self.orderStatus = [self objectOrNilForKey:kLMOrderListOrderStatus fromDictionary:dict];
            self.eventName = [self objectOrNilForKey:kLMOrderListEventName fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMOrderListEventUuid fromDictionary:dict];
            self.orderAmount = [self objectOrNilForKey:kLMOrderListOrderAmount fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMOrderListUserUuid fromDictionary:dict];
            self.payStatus = [self objectOrNilForKey:kLMOrderListPayStatus fromDictionary:dict];
            self.orderUuid = [self objectOrNilForKey:kLMOrderListOrderUuid fromDictionary:dict];
            self.orderNumber = [self objectOrNilForKey:kLMOrderListOrderNumber fromDictionary:dict];
            self.orderingTime = [self objectOrNilForKey:kLMOrderListOrderingTime fromDictionary:dict];
            self.number = [[self objectOrNilForKey:kLMOrderListNumber fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kLMOrderListAvatar];
    [mutableDict setValue:self.orderStatus forKey:kLMOrderListOrderStatus];
    [mutableDict setValue:self.eventName forKey:kLMOrderListEventName];
    [mutableDict setValue:self.eventUuid forKey:kLMOrderListEventUuid];
    [mutableDict setValue:self.orderAmount forKey:kLMOrderListOrderAmount];
    [mutableDict setValue:self.userUuid forKey:kLMOrderListUserUuid];
    [mutableDict setValue:self.payStatus forKey:kLMOrderListPayStatus];
    [mutableDict setValue:self.orderUuid forKey:kLMOrderListOrderUuid];
    [mutableDict setValue:self.orderNumber forKey:kLMOrderListOrderNumber];
    [mutableDict setValue:self.orderingTime forKey:kLMOrderListOrderingTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kLMOrderListNumber];

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

    self.avatar = [aDecoder decodeObjectForKey:kLMOrderListAvatar];
    self.orderStatus = [aDecoder decodeObjectForKey:kLMOrderListOrderStatus];
    self.eventName = [aDecoder decodeObjectForKey:kLMOrderListEventName];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMOrderListEventUuid];
    self.orderAmount = [aDecoder decodeObjectForKey:kLMOrderListOrderAmount];
    self.userUuid = [aDecoder decodeObjectForKey:kLMOrderListUserUuid];
    self.payStatus = [aDecoder decodeObjectForKey:kLMOrderListPayStatus];
    self.orderUuid = [aDecoder decodeObjectForKey:kLMOrderListOrderUuid];
    self.orderNumber = [aDecoder decodeObjectForKey:kLMOrderListOrderNumber];
    self.orderingTime = [aDecoder decodeObjectForKey:kLMOrderListOrderingTime];
    self.number = [aDecoder decodeDoubleForKey:kLMOrderListNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kLMOrderListAvatar];
    [aCoder encodeObject:_orderStatus forKey:kLMOrderListOrderStatus];
    [aCoder encodeObject:_eventName forKey:kLMOrderListEventName];
    [aCoder encodeObject:_eventUuid forKey:kLMOrderListEventUuid];
    [aCoder encodeObject:_orderAmount forKey:kLMOrderListOrderAmount];
    [aCoder encodeObject:_userUuid forKey:kLMOrderListUserUuid];
    [aCoder encodeObject:_payStatus forKey:kLMOrderListPayStatus];
    [aCoder encodeObject:_orderUuid forKey:kLMOrderListOrderUuid];
    [aCoder encodeObject:_orderNumber forKey:kLMOrderListOrderNumber];
    [aCoder encodeObject:_orderingTime forKey:kLMOrderListOrderingTime];
    [aCoder encodeDouble:_number forKey:kLMOrderListNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMOrderList *copy = [[LMOrderList alloc] init];
    
    if (copy) {

        copy.avatar = [self.avatar copyWithZone:zone];
        copy.orderStatus = [self.orderStatus copyWithZone:zone];
        copy.eventName = [self.eventName copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.orderAmount = [self.orderAmount copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.payStatus = [self.payStatus copyWithZone:zone];
        copy.orderUuid = [self.orderUuid copyWithZone:zone];
        copy.orderNumber = [self.orderNumber copyWithZone:zone];
        copy.orderingTime = [self.orderingTime copyWithZone:zone];
        copy.number = self.number;
    }
    
    return copy;
}


@end
