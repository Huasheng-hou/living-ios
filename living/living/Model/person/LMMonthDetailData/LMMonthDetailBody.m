//
//  LMMonthDetailBody.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMMonthDetailBody.h"
#import "LMMonthDetailBill.h"
#import "LMMonthDetailList.h"


NSString *const kLMMonthDetailBodyResult = @"result";
NSString *const kLMMonthDetailBodyBill = @"bill";
NSString *const kLMMonthDetailBodyList = @"list";
NSString *const kLMMonthDetailBodyDescription = @"description";
NSString *const kLMMonthDetailBodyTotal = @"total";
NSString *const kLMMonthDetailBodyPage = @"page";


@interface LMMonthDetailBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMMonthDetailBody

@synthesize result = _result;
@synthesize bill = _bill;
@synthesize list = _list;
@synthesize bodyDescription = _bodyDescription;
@synthesize total = _total;
@synthesize page = _page;


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
            self.result = [self objectOrNilForKey:kLMMonthDetailBodyResult fromDictionary:dict];
            self.bill = [LMMonthDetailBill modelObjectWithDictionary:[dict objectForKey:kLMMonthDetailBodyBill]];
    NSObject *receivedLMMonthDetailList = [dict objectForKey:kLMMonthDetailBodyList];
    NSMutableArray *parsedLMMonthDetailList = [NSMutableArray array];
    if ([receivedLMMonthDetailList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMMonthDetailList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMMonthDetailList addObject:[LMMonthDetailList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMMonthDetailList isKindOfClass:[NSDictionary class]]) {
       [parsedLMMonthDetailList addObject:[LMMonthDetailList modelObjectWithDictionary:(NSDictionary *)receivedLMMonthDetailList]];
    }

    self.list = [NSArray arrayWithArray:parsedLMMonthDetailList];
            self.bodyDescription = [self objectOrNilForKey:kLMMonthDetailBodyDescription fromDictionary:dict];
            self.total = [[self objectOrNilForKey:kLMMonthDetailBodyTotal fromDictionary:dict] doubleValue];
            self.page = [[self objectOrNilForKey:kLMMonthDetailBodyPage fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMMonthDetailBodyResult];
    [mutableDict setValue:[self.bill dictionaryRepresentation] forKey:kLMMonthDetailBodyBill];
    NSMutableArray *tempArrayForList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.list) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMMonthDetailBodyList];
    [mutableDict setValue:self.bodyDescription forKey:kLMMonthDetailBodyDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kLMMonthDetailBodyTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.page] forKey:kLMMonthDetailBodyPage];

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

    self.result = [aDecoder decodeObjectForKey:kLMMonthDetailBodyResult];
    self.bill = [aDecoder decodeObjectForKey:kLMMonthDetailBodyBill];
    self.list = [aDecoder decodeObjectForKey:kLMMonthDetailBodyList];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMMonthDetailBodyDescription];
    self.total = [aDecoder decodeDoubleForKey:kLMMonthDetailBodyTotal];
    self.page = [aDecoder decodeDoubleForKey:kLMMonthDetailBodyPage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMMonthDetailBodyResult];
    [aCoder encodeObject:_bill forKey:kLMMonthDetailBodyBill];
    [aCoder encodeObject:_list forKey:kLMMonthDetailBodyList];
    [aCoder encodeObject:_bodyDescription forKey:kLMMonthDetailBodyDescription];
    [aCoder encodeDouble:_total forKey:kLMMonthDetailBodyTotal];
    [aCoder encodeDouble:_page forKey:kLMMonthDetailBodyPage];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMMonthDetailBody *copy = [[LMMonthDetailBody alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.bill = [self.bill copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];
        copy.bodyDescription = [self.bodyDescription copyWithZone:zone];
        copy.total = self.total;
        copy.page = self.page;
    }
    
    return copy;
}


@end
