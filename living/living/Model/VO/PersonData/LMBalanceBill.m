//
//  LMBalanceBill.m
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMBalanceBill.h"


NSString *const kLMBalanceBillRecharges = @"recharges";
NSString *const kLMBalanceBillExpenditure = @"expenditure";
NSString *const kLMBalanceBillEventsBill = @"events_bill";
NSString *const kLMBalanceBillRechargesBill = @"recharges_bill";
NSString *const kLMBalanceBillRefundsBill = @"refunds_bill";


@interface LMBalanceBill ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMBalanceBill

@synthesize recharges = _recharges;
@synthesize expenditure = _expenditure;
@synthesize eventsBill = _eventsBill;
@synthesize rechargesBill = _rechargesBill;
@synthesize refundsBill = _refundsBill;


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
            self.recharges = [self objectOrNilForKey:kLMBalanceBillRecharges fromDictionary:dict];
            self.expenditure = [self objectOrNilForKey:kLMBalanceBillExpenditure fromDictionary:dict];
            self.eventsBill = [self objectOrNilForKey:kLMBalanceBillEventsBill fromDictionary:dict];
            self.rechargesBill = [self objectOrNilForKey:kLMBalanceBillRechargesBill fromDictionary:dict];
            self.refundsBill = [self objectOrNilForKey:kLMBalanceBillRefundsBill fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.recharges forKey:kLMBalanceBillRecharges];
    [mutableDict setValue:self.expenditure forKey:kLMBalanceBillExpenditure];
    [mutableDict setValue:self.eventsBill forKey:kLMBalanceBillEventsBill];
    [mutableDict setValue:self.rechargesBill forKey:kLMBalanceBillRechargesBill];
    [mutableDict setValue:self.refundsBill forKey:kLMBalanceBillRefundsBill];

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

    self.recharges = [aDecoder decodeObjectForKey:kLMBalanceBillRecharges];
    self.expenditure = [aDecoder decodeObjectForKey:kLMBalanceBillExpenditure];
    self.eventsBill = [aDecoder decodeObjectForKey:kLMBalanceBillEventsBill];
    self.rechargesBill = [aDecoder decodeObjectForKey:kLMBalanceBillRechargesBill];
    self.refundsBill = [aDecoder decodeObjectForKey:kLMBalanceBillRefundsBill];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_recharges forKey:kLMBalanceBillRecharges];
    [aCoder encodeObject:_expenditure forKey:kLMBalanceBillExpenditure];
    [aCoder encodeObject:_eventsBill forKey:kLMBalanceBillEventsBill];
    [aCoder encodeObject:_rechargesBill forKey:kLMBalanceBillRechargesBill];
    [aCoder encodeObject:_refundsBill forKey:kLMBalanceBillRefundsBill];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMBalanceBill *copy = [[LMBalanceBill alloc] init];
    
    if (copy) {

        copy.recharges = [self.recharges copyWithZone:zone];
        copy.expenditure = [self.expenditure copyWithZone:zone];
        copy.eventsBill = [self.eventsBill copyWithZone:zone];
        copy.rechargesBill = [self.rechargesBill copyWithZone:zone];
        copy.refundsBill = [self.refundsBill copyWithZone:zone];
    }
    
    return copy;
}


@end
