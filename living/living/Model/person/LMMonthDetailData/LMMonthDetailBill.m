//
//  LMMonthDetailBill.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMMonthDetailBill.h"


NSString *const kLMMonthDetailBillRecharges = @"recharges";
NSString *const kLMMonthDetailBillExpenditure = @"expenditure";
NSString *const kLMMonthDetailBillEventsBill = @"events_bill";
NSString *const kLMMonthDetailBillRechargesBill = @"recharges_bill";
NSString *const kLMMonthDetailBillRefundsBill = @"refunds_bill";


@interface LMMonthDetailBill ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMMonthDetailBill

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
            self.recharges = [self objectOrNilForKey:kLMMonthDetailBillRecharges fromDictionary:dict];
            self.expenditure = [self objectOrNilForKey:kLMMonthDetailBillExpenditure fromDictionary:dict];
            self.eventsBill = [self objectOrNilForKey:kLMMonthDetailBillEventsBill fromDictionary:dict];
            self.rechargesBill = [self objectOrNilForKey:kLMMonthDetailBillRechargesBill fromDictionary:dict];
            self.refundsBill = [self objectOrNilForKey:kLMMonthDetailBillRefundsBill fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.recharges forKey:kLMMonthDetailBillRecharges];
    [mutableDict setValue:self.expenditure forKey:kLMMonthDetailBillExpenditure];
    [mutableDict setValue:self.eventsBill forKey:kLMMonthDetailBillEventsBill];
    [mutableDict setValue:self.rechargesBill forKey:kLMMonthDetailBillRechargesBill];
    [mutableDict setValue:self.refundsBill forKey:kLMMonthDetailBillRefundsBill];

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

    self.recharges = [aDecoder decodeObjectForKey:kLMMonthDetailBillRecharges];
    self.expenditure = [aDecoder decodeObjectForKey:kLMMonthDetailBillExpenditure];
    self.eventsBill = [aDecoder decodeObjectForKey:kLMMonthDetailBillEventsBill];
    self.rechargesBill = [aDecoder decodeObjectForKey:kLMMonthDetailBillRechargesBill];
    self.refundsBill = [aDecoder decodeObjectForKey:kLMMonthDetailBillRefundsBill];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_recharges forKey:kLMMonthDetailBillRecharges];
    [aCoder encodeObject:_expenditure forKey:kLMMonthDetailBillExpenditure];
    [aCoder encodeObject:_eventsBill forKey:kLMMonthDetailBillEventsBill];
    [aCoder encodeObject:_rechargesBill forKey:kLMMonthDetailBillRechargesBill];
    [aCoder encodeObject:_refundsBill forKey:kLMMonthDetailBillRefundsBill];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMMonthDetailBill *copy = [[LMMonthDetailBill alloc] init];
    
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
