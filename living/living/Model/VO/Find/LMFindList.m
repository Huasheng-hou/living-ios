//
//  LMFindList.m
//
//  Created by   on 16/10/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMFindList.h"


NSString *const kLMFindListNumberOfVotes = @"number_of_votes";
NSString *const kLMFindListDescrition = @"descrition";
NSString *const kLMFindListTitle = @"title";
NSString *const kLMFindListFindUuid = @"find_uuid";


@interface LMFindList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMFindList

@synthesize numberOfVotes = _numberOfVotes;
@synthesize descrition = _descrition;
@synthesize title = _title;
@synthesize findUuid = _findUuid;


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
            self.numberOfVotes = [[self objectOrNilForKey:kLMFindListNumberOfVotes fromDictionary:dict] doubleValue];
            self.descrition = [self objectOrNilForKey:kLMFindListDescrition fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMFindListTitle fromDictionary:dict];
            self.findUuid = [self objectOrNilForKey:kLMFindListFindUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.numberOfVotes] forKey:kLMFindListNumberOfVotes];
    [mutableDict setValue:self.descrition forKey:kLMFindListDescrition];
    [mutableDict setValue:self.title forKey:kLMFindListTitle];
    [mutableDict setValue:self.findUuid forKey:kLMFindListFindUuid];

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

    self.numberOfVotes = [aDecoder decodeDoubleForKey:kLMFindListNumberOfVotes];
    self.descrition = [aDecoder decodeObjectForKey:kLMFindListDescrition];
    self.title = [aDecoder decodeObjectForKey:kLMFindListTitle];
    self.findUuid = [aDecoder decodeObjectForKey:kLMFindListFindUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_numberOfVotes forKey:kLMFindListNumberOfVotes];
    [aCoder encodeObject:_descrition forKey:kLMFindListDescrition];
    [aCoder encodeObject:_title forKey:kLMFindListTitle];
    [aCoder encodeObject:_findUuid forKey:kLMFindListFindUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMFindList *copy = [[LMFindList alloc] init];
    
    if (copy) {

        copy.numberOfVotes = self.numberOfVotes;
        copy.descrition = [self.descrition copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.findUuid = [self.findUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
