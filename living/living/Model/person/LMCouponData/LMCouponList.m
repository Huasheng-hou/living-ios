//
//  LMCouponList.m
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCouponList.h"


NSString *const kLMCouponListUserUuid = @"user_uuid";
NSString *const kLMCouponListLivingUuid = @"living_uuid";
NSString *const kLMCouponListLivingName = @"living_name";


@interface LMCouponList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCouponList

@synthesize userUuid = _userUuid;
@synthesize livingUuid = _livingUuid;
@synthesize livingName = _livingName;


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
            self.userUuid = [self objectOrNilForKey:kLMCouponListUserUuid fromDictionary:dict];
            self.livingUuid = [self objectOrNilForKey:kLMCouponListLivingUuid fromDictionary:dict];
            self.livingName = [self objectOrNilForKey:kLMCouponListLivingName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userUuid forKey:kLMCouponListUserUuid];
    [mutableDict setValue:self.livingUuid forKey:kLMCouponListLivingUuid];
    [mutableDict setValue:self.livingName forKey:kLMCouponListLivingName];

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

    self.userUuid = [aDecoder decodeObjectForKey:kLMCouponListUserUuid];
    self.livingUuid = [aDecoder decodeObjectForKey:kLMCouponListLivingUuid];
    self.livingName = [aDecoder decodeObjectForKey:kLMCouponListLivingName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userUuid forKey:kLMCouponListUserUuid];
    [aCoder encodeObject:_livingUuid forKey:kLMCouponListLivingUuid];
    [aCoder encodeObject:_livingName forKey:kLMCouponListLivingName];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCouponList *copy = [[LMCouponList alloc] init];
    
    if (copy) {

        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.livingUuid = [self.livingUuid copyWithZone:zone];
        copy.livingName = [self.livingName copyWithZone:zone];
    }
    
    return copy;
}


@end
