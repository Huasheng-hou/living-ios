//
//  LMFindBody.m
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMFindBody.h"
#import "LMFindList.h"


NSString *const kLMFindBodyResult = @"result";
NSString *const kLMFindBodyList = @"list";
NSString *const kLMFindBodyDescription = @"description";
NSString *const kLMFindBodyTotal = @"total";
NSString *const kLMFindBodyPage = @"page";


@interface LMFindBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMFindBody

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
            self.result = [self objectOrNilForKey:kLMFindBodyResult fromDictionary:dict];
    NSObject *receivedLMFindList = [dict objectForKey:kLMFindBodyList];
    NSMutableArray *parsedLMFindList = [NSMutableArray array];
    if ([receivedLMFindList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMFindList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMFindList addObject:[LMFindList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMFindList isKindOfClass:[NSDictionary class]]) {
       [parsedLMFindList addObject:[LMFindList modelObjectWithDictionary:(NSDictionary *)receivedLMFindList]];
    }

    self.list = [NSArray arrayWithArray:parsedLMFindList];
            self.bodyDescription = [self objectOrNilForKey:kLMFindBodyDescription fromDictionary:dict];
            self.total = [[self objectOrNilForKey:kLMFindBodyTotal fromDictionary:dict] doubleValue];
            self.page = [[self objectOrNilForKey:kLMFindBodyPage fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMFindBodyResult];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMFindBodyList];
    [mutableDict setValue:self.bodyDescription forKey:kLMFindBodyDescription];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kLMFindBodyTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.page] forKey:kLMFindBodyPage];

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

    self.result = [aDecoder decodeObjectForKey:kLMFindBodyResult];
    self.list = [aDecoder decodeObjectForKey:kLMFindBodyList];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMFindBodyDescription];
    self.total = [aDecoder decodeDoubleForKey:kLMFindBodyTotal];
    self.page = [aDecoder decodeDoubleForKey:kLMFindBodyPage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMFindBodyResult];
    [aCoder encodeObject:_list forKey:kLMFindBodyList];
    [aCoder encodeObject:_bodyDescription forKey:kLMFindBodyDescription];
    [aCoder encodeDouble:_total forKey:kLMFindBodyTotal];
    [aCoder encodeDouble:_page forKey:kLMFindBodyPage];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMFindBody *copy = [[LMFindBody alloc] init];
    
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
