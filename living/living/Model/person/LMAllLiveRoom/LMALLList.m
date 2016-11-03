//
//  LMALLList.m
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMALLList.h"


NSString *const kLMALLListLivingImage = @"living_image";
NSString *const kLMALLListLivingName = @"living_name";
NSString *const kLMALLListLivingUuid = @"living_uuid";


@interface LMALLList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMALLList

@synthesize livingImage = _livingImage;
@synthesize livingName = _livingName;
@synthesize livingUuid = _livingUuid;


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
            self.livingImage = [self objectOrNilForKey:kLMALLListLivingImage fromDictionary:dict];
            self.livingName = [self objectOrNilForKey:kLMALLListLivingName fromDictionary:dict];
            self.livingUuid = [self objectOrNilForKey:kLMALLListLivingUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.livingImage forKey:kLMALLListLivingImage];
    [mutableDict setValue:self.livingName forKey:kLMALLListLivingName];
    [mutableDict setValue:self.livingUuid forKey:kLMALLListLivingUuid];

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

    self.livingImage = [aDecoder decodeObjectForKey:kLMALLListLivingImage];
    self.livingName = [aDecoder decodeObjectForKey:kLMALLListLivingName];
    self.livingUuid = [aDecoder decodeObjectForKey:kLMALLListLivingUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_livingImage forKey:kLMALLListLivingImage];
    [aCoder encodeObject:_livingName forKey:kLMALLListLivingName];
    [aCoder encodeObject:_livingUuid forKey:kLMALLListLivingUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMALLList *copy = [[LMALLList alloc] init];
    
    if (copy) {

        copy.livingImage = [self.livingImage copyWithZone:zone];
        copy.livingName = [self.livingName copyWithZone:zone];
        copy.livingUuid = [self.livingUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
