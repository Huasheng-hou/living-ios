//
//  LMFindList.m
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMFindList.h"


NSString *const kLMFindListNumberOfVotes = @"number_of_votes";
NSString *const kLMFindListHasPraised = @"has_praised";
NSString *const kLMFindListDescrition = @"descrition";
NSString *const kLMFindListTitle = @"title";
NSString *const kLMFindListFindUuid = @"find_uuid";
NSString *const kLMFindListImages = @"images";


@interface LMFindList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMFindList

@synthesize numberOfVotes = _numberOfVotes;
@synthesize hasPraised = _hasPraised;
@synthesize descrition = _descrition;
@synthesize title = _title;
@synthesize findUuid = _findUuid;
@synthesize images = _images;


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
            self.hasPraised = [[self objectOrNilForKey:kLMFindListHasPraised fromDictionary:dict] boolValue];
            self.descrition = [self objectOrNilForKey:kLMFindListDescrition fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMFindListTitle fromDictionary:dict];
            self.findUuid = [self objectOrNilForKey:kLMFindListFindUuid fromDictionary:dict];
            self.images = [self objectOrNilForKey:kLMFindListImages fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.numberOfVotes] forKey:kLMFindListNumberOfVotes];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kLMFindListHasPraised];
    [mutableDict setValue:self.descrition forKey:kLMFindListDescrition];
    [mutableDict setValue:self.title forKey:kLMFindListTitle];
    [mutableDict setValue:self.findUuid forKey:kLMFindListFindUuid];
    [mutableDict setValue:self.images forKey:kLMFindListImages];

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
    self.hasPraised = [aDecoder decodeBoolForKey:kLMFindListHasPraised];
    self.descrition = [aDecoder decodeObjectForKey:kLMFindListDescrition];
    self.title = [aDecoder decodeObjectForKey:kLMFindListTitle];
    self.findUuid = [aDecoder decodeObjectForKey:kLMFindListFindUuid];
    self.images = [aDecoder decodeObjectForKey:kLMFindListImages];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_numberOfVotes forKey:kLMFindListNumberOfVotes];
    [aCoder encodeBool:_hasPraised forKey:kLMFindListHasPraised];
    [aCoder encodeObject:_descrition forKey:kLMFindListDescrition];
    [aCoder encodeObject:_title forKey:kLMFindListTitle];
    [aCoder encodeObject:_findUuid forKey:kLMFindListFindUuid];
    [aCoder encodeObject:_images forKey:kLMFindListImages];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMFindList *copy = [[LMFindList alloc] init];
    
    if (copy) {

        copy.numberOfVotes = self.numberOfVotes;
        copy.hasPraised = self.hasPraised;
        copy.descrition = [self.descrition copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.findUuid = [self.findUuid copyWithZone:zone];
        copy.images = [self.images copyWithZone:zone];
    }
    
    return copy;
}


@end
