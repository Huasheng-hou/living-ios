//
//  LMLivingLivingInfo.m
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMLivingLivingInfo.h"


NSString *const kLMLivingLivingInfoAddress = @"address";
NSString *const kLMLivingLivingInfoLivingImage = @"living_image";
NSString *const kLMLivingLivingInfoLivingName = @"living_name";
NSString *const kLMLivingLivingInfoLivingTitle = @"living_title";
NSString *const kLMLivingLivingInfoUserUuid = @"userUuid";
NSString *const kLMLivingLivingInfoLivingUuid = @"living_uuid";
NSString *const kLMLivingLivingInfoBalance = @"balance";


@interface LMLivingLivingInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMLivingLivingInfo

@synthesize address = _address;
@synthesize livingImage = _livingImage;
@synthesize livingName = _livingName;
@synthesize livingTitle = _livingTitle;
@synthesize userUuid = _userUuid;
@synthesize livingUuid = _livingUuid;
@synthesize balance = _balance;


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
            self.address = [self objectOrNilForKey:kLMLivingLivingInfoAddress fromDictionary:dict];
            self.livingImage = [self objectOrNilForKey:kLMLivingLivingInfoLivingImage fromDictionary:dict];
            self.livingName = [self objectOrNilForKey:kLMLivingLivingInfoLivingName fromDictionary:dict];
            self.livingTitle = [self objectOrNilForKey:kLMLivingLivingInfoLivingTitle fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMLivingLivingInfoUserUuid fromDictionary:dict];
            self.livingUuid = [self objectOrNilForKey:kLMLivingLivingInfoLivingUuid fromDictionary:dict];
            self.balance = [self objectOrNilForKey:kLMLivingLivingInfoBalance fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kLMLivingLivingInfoAddress];
    NSMutableArray *tempArrayForLivingImage = [NSMutableArray array];
    for (NSObject *subArrayObject in self.livingImage) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLivingImage addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLivingImage addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLivingImage] forKey:kLMLivingLivingInfoLivingImage];
    [mutableDict setValue:self.livingName forKey:kLMLivingLivingInfoLivingName];
    [mutableDict setValue:self.livingTitle forKey:kLMLivingLivingInfoLivingTitle];
    [mutableDict setValue:self.userUuid forKey:kLMLivingLivingInfoUserUuid];
    [mutableDict setValue:self.livingUuid forKey:kLMLivingLivingInfoLivingUuid];
    [mutableDict setValue:self.balance forKey:kLMLivingLivingInfoBalance];

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

    self.address = [aDecoder decodeObjectForKey:kLMLivingLivingInfoAddress];
    self.livingImage = [aDecoder decodeObjectForKey:kLMLivingLivingInfoLivingImage];
    self.livingName = [aDecoder decodeObjectForKey:kLMLivingLivingInfoLivingName];
    self.livingTitle = [aDecoder decodeObjectForKey:kLMLivingLivingInfoLivingTitle];
    self.userUuid = [aDecoder decodeObjectForKey:kLMLivingLivingInfoUserUuid];
    self.livingUuid = [aDecoder decodeObjectForKey:kLMLivingLivingInfoLivingUuid];
    self.balance = [aDecoder decodeObjectForKey:kLMLivingLivingInfoBalance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kLMLivingLivingInfoAddress];
    [aCoder encodeObject:_livingImage forKey:kLMLivingLivingInfoLivingImage];
    [aCoder encodeObject:_livingName forKey:kLMLivingLivingInfoLivingName];
    [aCoder encodeObject:_livingTitle forKey:kLMLivingLivingInfoLivingTitle];
    [aCoder encodeObject:_userUuid forKey:kLMLivingLivingInfoUserUuid];
    [aCoder encodeObject:_livingUuid forKey:kLMLivingLivingInfoLivingUuid];
    [aCoder encodeObject:_balance forKey:kLMLivingLivingInfoBalance];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMLivingLivingInfo *copy = [[LMLivingLivingInfo alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.livingImage = [self.livingImage copyWithZone:zone];
        copy.livingName = [self.livingName copyWithZone:zone];
        copy.livingTitle = [self.livingTitle copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.livingUuid = [self.livingUuid copyWithZone:zone];
        copy.balance = [self.balance copyWithZone:zone];
    }
    
    return copy;
}


@end
