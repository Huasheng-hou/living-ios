//
//  LMCouponBody.m
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCouponBody.h"
#import "LMCouponList.h"


NSString *const kLMCouponBodyResult = @"result";
NSString *const kLMCouponBodyList = @"list";
NSString *const kLMCouponBodyDescription = @"description";


@interface LMCouponBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCouponBody

@synthesize result = _result;
@synthesize list = _list;
@synthesize bodyDescription = _bodyDescription;


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
            self.result = [self objectOrNilForKey:kLMCouponBodyResult fromDictionary:dict];
    NSObject *receivedLMCouponList = [dict objectForKey:kLMCouponBodyList];
    NSMutableArray *parsedLMCouponList = [NSMutableArray array];
    if ([receivedLMCouponList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMCouponList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMCouponList addObject:[LMCouponList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMCouponList isKindOfClass:[NSDictionary class]]) {
       [parsedLMCouponList addObject:[LMCouponList modelObjectWithDictionary:(NSDictionary *)receivedLMCouponList]];
    }

    self.list = [NSArray arrayWithArray:parsedLMCouponList];
            self.bodyDescription = [self objectOrNilForKey:kLMCouponBodyDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMCouponBodyResult];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMCouponBodyList];
    [mutableDict setValue:self.bodyDescription forKey:kLMCouponBodyDescription];

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

    self.result = [aDecoder decodeObjectForKey:kLMCouponBodyResult];
    self.list = [aDecoder decodeObjectForKey:kLMCouponBodyList];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMCouponBodyDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMCouponBodyResult];
    [aCoder encodeObject:_list forKey:kLMCouponBodyList];
    [aCoder encodeObject:_bodyDescription forKey:kLMCouponBodyDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCouponBody *copy = [[LMCouponBody alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];
        copy.bodyDescription = [self.bodyDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
