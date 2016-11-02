//
//  LMLiveRoomLivingInfo.m
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMLiveRoomLivingInfo.h"


NSString *const kLMLiveRoomLivingInfoAddress = @"address";
NSString *const kLMLiveRoomLivingInfoLivingImage = @"living_image";
NSString *const kLMLiveRoomLivingInfoLivingName = @"living_name";
NSString *const kLMLiveRoomLivingInfoLivingTitle = @"living_title";
NSString *const kLMLiveRoomLivingInfoUserUuid = @"userUuid";
NSString *const kLMLiveRoomLivingInfoLivingUuid = @"living_uuid";
NSString *const kLMLiveRoomLivingInfoBalance = @"balance";


@interface LMLiveRoomLivingInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMLiveRoomLivingInfo

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
            self.address = [self objectOrNilForKey:kLMLiveRoomLivingInfoAddress fromDictionary:dict];
            self.livingImage = [self objectOrNilForKey:kLMLiveRoomLivingInfoLivingImage fromDictionary:dict];
            self.livingName = [self objectOrNilForKey:kLMLiveRoomLivingInfoLivingName fromDictionary:dict];
            self.livingTitle = [self objectOrNilForKey:kLMLiveRoomLivingInfoLivingTitle fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMLiveRoomLivingInfoUserUuid fromDictionary:dict];
            self.livingUuid = [self objectOrNilForKey:kLMLiveRoomLivingInfoLivingUuid fromDictionary:dict];
            self.balance = [self objectOrNilForKey:kLMLiveRoomLivingInfoBalance fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kLMLiveRoomLivingInfoAddress];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLivingImage] forKey:kLMLiveRoomLivingInfoLivingImage];
    [mutableDict setValue:self.livingName forKey:kLMLiveRoomLivingInfoLivingName];
    [mutableDict setValue:self.livingTitle forKey:kLMLiveRoomLivingInfoLivingTitle];
    [mutableDict setValue:self.userUuid forKey:kLMLiveRoomLivingInfoUserUuid];
    [mutableDict setValue:self.livingUuid forKey:kLMLiveRoomLivingInfoLivingUuid];
    [mutableDict setValue:self.balance forKey:kLMLiveRoomLivingInfoBalance];

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

    self.address = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoAddress];
    self.livingImage = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoLivingImage];
    self.livingName = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoLivingName];
    self.livingTitle = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoLivingTitle];
    self.userUuid = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoUserUuid];
    self.livingUuid = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoLivingUuid];
    self.balance = [aDecoder decodeObjectForKey:kLMLiveRoomLivingInfoBalance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kLMLiveRoomLivingInfoAddress];
    [aCoder encodeObject:_livingImage forKey:kLMLiveRoomLivingInfoLivingImage];
    [aCoder encodeObject:_livingName forKey:kLMLiveRoomLivingInfoLivingName];
    [aCoder encodeObject:_livingTitle forKey:kLMLiveRoomLivingInfoLivingTitle];
    [aCoder encodeObject:_userUuid forKey:kLMLiveRoomLivingInfoUserUuid];
    [aCoder encodeObject:_livingUuid forKey:kLMLiveRoomLivingInfoLivingUuid];
    [aCoder encodeObject:_balance forKey:kLMLiveRoomLivingInfoBalance];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMLiveRoomLivingInfo *copy = [[LMLiveRoomLivingInfo alloc] init];
    
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
