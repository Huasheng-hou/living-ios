//
//  LMBalanceBody.m
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMBalanceBody.h"
#import "LMBalanceList.h"


NSString *const kLMBalanceBodyResult = @"result";
NSString *const kLMBalanceBodyList = @"list";
NSString *const kLMBalanceBodyDescription = @"description";
NSString *const kLMBalanceBodyTotal = @"total";
NSString *const kLMBalanceBodyPage = @"page";


@interface LMBalanceBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMBalanceBody

@synthesize result = _result;
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
            self.result = [self objectOrNilForKey:kLMBalanceBodyResult fromDictionary:dict];
    NSObject *receivedLMBalanceList = [dict objectForKey:kLMBalanceBodyList];
    NSMutableArray *parsedLMBalanceList = [NSMutableArray array];
    if ([receivedLMBalanceList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMBalanceList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMBalanceList addObject:[LMBalanceList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMBalanceList isKindOfClass:[NSDictionary class]]) {
       [parsedLMBalanceList addObject:[LMBalanceList modelObjectWithDictionary:(NSDictionary *)receivedLMBalanceList]];
    }

    self.list = [NSArray arrayWithArray:parsedLMBalanceList];
            self.bodyDescription = [self objectOrNilForKey:kLMBalanceBodyDescription fromDictionary:dict];
            self.total = [[self objectOrNilForKey:kLMBalanceBodyTotal fromDictionary:dict] doubleValue];
            self.page = [[self objectOrNilForKey:kLMBalanceBodyPage fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMBalanceBodyResult];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMBalanceBodyList];
    [mutableDict setValue:self.bodyDescription forKey:kLMBalanceBodyDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kLMBalanceBodyTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.page] forKey:kLMBalanceBodyPage];

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

    self.result = [aDecoder decodeObjectForKey:kLMBalanceBodyResult];
    self.list = [aDecoder decodeObjectForKey:kLMBalanceBodyList];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMBalanceBodyDescription];
    self.total = [aDecoder decodeDoubleForKey:kLMBalanceBodyTotal];
    self.page = [aDecoder decodeDoubleForKey:kLMBalanceBodyPage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMBalanceBodyResult];
    [aCoder encodeObject:_list forKey:kLMBalanceBodyList];
    [aCoder encodeObject:_bodyDescription forKey:kLMBalanceBodyDescription];
    [aCoder encodeDouble:_total forKey:kLMBalanceBodyTotal];
    [aCoder encodeDouble:_page forKey:kLMBalanceBodyPage];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMBalanceBody *copy = [[LMBalanceBody alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];
        copy.bodyDescription = [self.bodyDescription copyWithZone:zone];
        copy.total = self.total;
        copy.page = self.page;
    }
    
    return copy;
}


@end
