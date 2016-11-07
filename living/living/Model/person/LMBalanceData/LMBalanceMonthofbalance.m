//
//  LMBalanceMonthofbalance.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMBalanceMonthofbalance.h"


NSString *const kLMBalanceMonthofbalanceAmount = @"amount";
NSString *const kLMBalanceMonthofbalanceBalanceUuid = @"balanceUuid";
NSString *const kLMBalanceMonthofbalanceTitle = @"title";
NSString *const kLMBalanceMonthofbalanceDatetime = @"datetime";
NSString *const kLMBalanceMonthofbalanceName = @"name";


@interface LMBalanceMonthofbalance ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMBalanceMonthofbalance

@synthesize amount = _amount;
@synthesize balanceUuid = _balanceUuid;
@synthesize title = _title;
@synthesize datetime = _datetime;
@synthesize name = _name;


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
            self.amount = [self objectOrNilForKey:kLMBalanceMonthofbalanceAmount fromDictionary:dict];
            self.balanceUuid = [self objectOrNilForKey:kLMBalanceMonthofbalanceBalanceUuid fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMBalanceMonthofbalanceTitle fromDictionary:dict];
            self.datetime = [self objectOrNilForKey:kLMBalanceMonthofbalanceDatetime fromDictionary:dict];
            self.name = [self objectOrNilForKey:kLMBalanceMonthofbalanceName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.amount forKey:kLMBalanceMonthofbalanceAmount];
    [mutableDict setValue:self.balanceUuid forKey:kLMBalanceMonthofbalanceBalanceUuid];
    [mutableDict setValue:self.title forKey:kLMBalanceMonthofbalanceTitle];
    [mutableDict setValue:self.datetime forKey:kLMBalanceMonthofbalanceDatetime];
    [mutableDict setValue:self.name forKey:kLMBalanceMonthofbalanceName];

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

    self.amount = [aDecoder decodeObjectForKey:kLMBalanceMonthofbalanceAmount];
    self.balanceUuid = [aDecoder decodeObjectForKey:kLMBalanceMonthofbalanceBalanceUuid];
    self.title = [aDecoder decodeObjectForKey:kLMBalanceMonthofbalanceTitle];
    self.datetime = [aDecoder decodeObjectForKey:kLMBalanceMonthofbalanceDatetime];
    self.name = [aDecoder decodeObjectForKey:kLMBalanceMonthofbalanceName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_amount forKey:kLMBalanceMonthofbalanceAmount];
    [aCoder encodeObject:_balanceUuid forKey:kLMBalanceMonthofbalanceBalanceUuid];
    [aCoder encodeObject:_title forKey:kLMBalanceMonthofbalanceTitle];
    [aCoder encodeObject:_datetime forKey:kLMBalanceMonthofbalanceDatetime];
    [aCoder encodeObject:_name forKey:kLMBalanceMonthofbalanceName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMBalanceMonthofbalance *copy = [[LMBalanceMonthofbalance alloc] init];
    
    if (copy) {

        copy.amount = [self.amount copyWithZone:zone];
        copy.balanceUuid = [self.balanceUuid copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.datetime = [self.datetime copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
