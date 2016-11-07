//
//  LMBalanceList.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMBalanceList.h"
#import "LMBalanceMonthofbalance.h"


NSString *const kLMBalanceListMonthofbalance = @"monthofbalance";
NSString *const kLMBalanceListMonth = @"month";


@interface LMBalanceList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMBalanceList

@synthesize monthofbalance = _monthofbalance;
@synthesize month = _month;


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
    NSObject *receivedLMBalanceMonthofbalance = [dict objectForKey:kLMBalanceListMonthofbalance];
    NSMutableArray *parsedLMBalanceMonthofbalance = [NSMutableArray array];
    if ([receivedLMBalanceMonthofbalance isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMBalanceMonthofbalance) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMBalanceMonthofbalance addObject:[LMBalanceMonthofbalance modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMBalanceMonthofbalance isKindOfClass:[NSDictionary class]]) {
       [parsedLMBalanceMonthofbalance addObject:[LMBalanceMonthofbalance modelObjectWithDictionary:(NSDictionary *)receivedLMBalanceMonthofbalance]];
    }

    self.monthofbalance = [NSArray arrayWithArray:parsedLMBalanceMonthofbalance];
            self.month = [self objectOrNilForKey:kLMBalanceListMonth fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMonthofbalance = [NSMutableArray array];
    for (NSObject *subArrayObject in self.monthofbalance) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMonthofbalance addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMonthofbalance addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMonthofbalance] forKey:kLMBalanceListMonthofbalance];
    [mutableDict setValue:self.month forKey:kLMBalanceListMonth];

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

    self.monthofbalance = [aDecoder decodeObjectForKey:kLMBalanceListMonthofbalance];
    self.month = [aDecoder decodeObjectForKey:kLMBalanceListMonth];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_monthofbalance forKey:kLMBalanceListMonthofbalance];
    [aCoder encodeObject:_month forKey:kLMBalanceListMonth];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMBalanceList *copy = [[LMBalanceList alloc] init];
    
    if (copy) {

        copy.monthofbalance = [self.monthofbalance copyWithZone:zone];
        copy.month = [self.month copyWithZone:zone];
    }
    
    return copy;
}


@end
