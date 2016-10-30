//
//  LMBalanceList.m
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMBalanceList.h"


NSString *const kLMBalanceListAmount = @"amount";
NSString *const kLMBalanceListBalanceUuid = @"balanceUuid";
NSString *const kLMBalanceListTitle = @"title";
NSString *const kLMBalanceListDatetime = @"datetime";
NSString *const kLMBalanceListName = @"name";


@interface LMBalanceList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMBalanceList

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
            self.amount = [self objectOrNilForKey:kLMBalanceListAmount fromDictionary:dict];
            self.balanceUuid = [self objectOrNilForKey:kLMBalanceListBalanceUuid fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMBalanceListTitle fromDictionary:dict];
            self.datetime = [self objectOrNilForKey:kLMBalanceListDatetime fromDictionary:dict];
            self.name = [self objectOrNilForKey:kLMBalanceListName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.amount forKey:kLMBalanceListAmount];
    [mutableDict setValue:self.balanceUuid forKey:kLMBalanceListBalanceUuid];
    [mutableDict setValue:self.title forKey:kLMBalanceListTitle];
    [mutableDict setValue:self.datetime forKey:kLMBalanceListDatetime];
    [mutableDict setValue:self.name forKey:kLMBalanceListName];

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

    self.amount = [aDecoder decodeObjectForKey:kLMBalanceListAmount];
    self.balanceUuid = [aDecoder decodeObjectForKey:kLMBalanceListBalanceUuid];
    self.title = [aDecoder decodeObjectForKey:kLMBalanceListTitle];
    self.datetime = [aDecoder decodeObjectForKey:kLMBalanceListDatetime];
    self.name = [aDecoder decodeObjectForKey:kLMBalanceListName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_amount forKey:kLMBalanceListAmount];
    [aCoder encodeObject:_balanceUuid forKey:kLMBalanceListBalanceUuid];
    [aCoder encodeObject:_title forKey:kLMBalanceListTitle];
    [aCoder encodeObject:_datetime forKey:kLMBalanceListDatetime];
    [aCoder encodeObject:_name forKey:kLMBalanceListName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMBalanceList *copy = [[LMBalanceList alloc] init];
    
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
