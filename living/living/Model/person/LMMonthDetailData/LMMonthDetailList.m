//
//  LMMonthDetailList.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMMonthDetailList.h"


NSString *const kLMMonthDetailListAmount = @"amount";
NSString *const kLMMonthDetailListBalanceUuid = @"balanceUuid";
NSString *const kLMMonthDetailListTitle = @"title";
NSString *const kLMMonthDetailListDatetime = @"datetime";
NSString *const kLMMonthDetailListName = @"name";


@interface LMMonthDetailList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMMonthDetailList

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
            self.amount = [self objectOrNilForKey:kLMMonthDetailListAmount fromDictionary:dict];
            self.balanceUuid = [self objectOrNilForKey:kLMMonthDetailListBalanceUuid fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMMonthDetailListTitle fromDictionary:dict];
            self.datetime = [self objectOrNilForKey:kLMMonthDetailListDatetime fromDictionary:dict];
            self.name = [self objectOrNilForKey:kLMMonthDetailListName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.amount forKey:kLMMonthDetailListAmount];
    [mutableDict setValue:self.balanceUuid forKey:kLMMonthDetailListBalanceUuid];
    [mutableDict setValue:self.title forKey:kLMMonthDetailListTitle];
    [mutableDict setValue:self.datetime forKey:kLMMonthDetailListDatetime];
    [mutableDict setValue:self.name forKey:kLMMonthDetailListName];

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

    self.amount = [aDecoder decodeObjectForKey:kLMMonthDetailListAmount];
    self.balanceUuid = [aDecoder decodeObjectForKey:kLMMonthDetailListBalanceUuid];
    self.title = [aDecoder decodeObjectForKey:kLMMonthDetailListTitle];
    self.datetime = [aDecoder decodeObjectForKey:kLMMonthDetailListDatetime];
    self.name = [aDecoder decodeObjectForKey:kLMMonthDetailListName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_amount forKey:kLMMonthDetailListAmount];
    [aCoder encodeObject:_balanceUuid forKey:kLMMonthDetailListBalanceUuid];
    [aCoder encodeObject:_title forKey:kLMMonthDetailListTitle];
    [aCoder encodeObject:_datetime forKey:kLMMonthDetailListDatetime];
    [aCoder encodeObject:_name forKey:kLMMonthDetailListName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMMonthDetailList *copy = [[LMMonthDetailList alloc] init];
    
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
