//
//  LMALLBody.m
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMALLBody.h"
#import "LMALLList.h"


NSString *const kLMALLBodyResult = @"result";
NSString *const kLMALLBodyList = @"list";
NSString *const kLMALLBodyDescription = @"description";


@interface LMALLBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMALLBody

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
            self.result = [self objectOrNilForKey:kLMALLBodyResult fromDictionary:dict];
    NSObject *receivedLMALLList = [dict objectForKey:kLMALLBodyList];
    NSMutableArray *parsedLMALLList = [NSMutableArray array];
    if ([receivedLMALLList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLMALLList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLMALLList addObject:[LMALLList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLMALLList isKindOfClass:[NSDictionary class]]) {
       [parsedLMALLList addObject:[LMALLList modelObjectWithDictionary:(NSDictionary *)receivedLMALLList]];
    }

    self.list = [NSArray arrayWithArray:parsedLMALLList];
            self.bodyDescription = [self objectOrNilForKey:kLMALLBodyDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMALLBodyResult];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMALLBodyList];
    [mutableDict setValue:self.bodyDescription forKey:kLMALLBodyDescription];

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

    self.result = [aDecoder decodeObjectForKey:kLMALLBodyResult];
    self.list = [aDecoder decodeObjectForKey:kLMALLBodyList];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMALLBodyDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMALLBodyResult];
    [aCoder encodeObject:_list forKey:kLMALLBodyList];
    [aCoder encodeObject:_bodyDescription forKey:kLMALLBodyDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMALLBody *copy = [[LMALLBody alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];
        copy.bodyDescription = [self.bodyDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
