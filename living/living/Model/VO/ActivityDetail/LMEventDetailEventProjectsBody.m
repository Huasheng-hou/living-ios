//
//  LMEventDetailEventProjectsBody.m
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMEventDetailEventProjectsBody.h"


NSString *const kLMEventDetailEventProjectsBodyProjectTitle = @"project_title";
NSString *const kLMEventDetailEventProjectsBodyProjectImgs = @"project_imgs";
NSString *const kLMEventDetailEventProjectsBodyEventProjectUuid = @"event_project_uuid";
NSString *const kLMEventDetailEventProjectsBodyProjectDsp = @"project_dsp";


@interface LMEventDetailEventProjectsBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMEventDetailEventProjectsBody

@synthesize projectTitle = _projectTitle;
@synthesize projectImgs = _projectImgs;
@synthesize eventProjectUuid = _eventProjectUuid;
@synthesize projectDsp = _projectDsp;


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
            self.projectTitle = [self objectOrNilForKey:kLMEventDetailEventProjectsBodyProjectTitle fromDictionary:dict];
            self.projectImgs = [self objectOrNilForKey:kLMEventDetailEventProjectsBodyProjectImgs fromDictionary:dict];
            self.eventProjectUuid = [self objectOrNilForKey:kLMEventDetailEventProjectsBodyEventProjectUuid fromDictionary:dict];
            self.projectDsp = [self objectOrNilForKey:kLMEventDetailEventProjectsBodyProjectDsp fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.projectTitle forKey:kLMEventDetailEventProjectsBodyProjectTitle];
    [mutableDict setValue:self.projectImgs forKey:kLMEventDetailEventProjectsBodyProjectImgs];
    [mutableDict setValue:self.eventProjectUuid forKey:kLMEventDetailEventProjectsBodyEventProjectUuid];
    [mutableDict setValue:self.projectDsp forKey:kLMEventDetailEventProjectsBodyProjectDsp];

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

    self.projectTitle = [aDecoder decodeObjectForKey:kLMEventDetailEventProjectsBodyProjectTitle];
    self.projectImgs = [aDecoder decodeObjectForKey:kLMEventDetailEventProjectsBodyProjectImgs];
    self.eventProjectUuid = [aDecoder decodeObjectForKey:kLMEventDetailEventProjectsBodyEventProjectUuid];
    self.projectDsp = [aDecoder decodeObjectForKey:kLMEventDetailEventProjectsBodyProjectDsp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_projectTitle forKey:kLMEventDetailEventProjectsBodyProjectTitle];
    [aCoder encodeObject:_projectImgs forKey:kLMEventDetailEventProjectsBodyProjectImgs];
    [aCoder encodeObject:_eventProjectUuid forKey:kLMEventDetailEventProjectsBodyEventProjectUuid];
    [aCoder encodeObject:_projectDsp forKey:kLMEventDetailEventProjectsBodyProjectDsp];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMEventDetailEventProjectsBody *copy = [[LMEventDetailEventProjectsBody alloc] init];
    
    if (copy) {

        copy.projectTitle = [self.projectTitle copyWithZone:zone];
        copy.projectImgs = [self.projectImgs copyWithZone:zone];
        copy.eventProjectUuid = [self.eventProjectUuid copyWithZone:zone];
        copy.projectDsp = [self.projectDsp copyWithZone:zone];
    }
    
    return copy;
}


@end
