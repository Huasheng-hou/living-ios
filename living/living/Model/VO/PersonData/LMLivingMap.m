//
//  LMLivingMap.m
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMLivingMap.h"


NSString *const kLMLivingMapJoinNums = @"join_nums";
NSString *const kLMLivingMapPublishNums = @"publish_nums";


@interface LMLivingMap ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMLivingMap

@synthesize joinNums = _joinNums;
@synthesize publishNums = _publishNums;


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
            self.joinNums = [[self objectOrNilForKey:kLMLivingMapJoinNums fromDictionary:dict] doubleValue];
            self.publishNums = [[self objectOrNilForKey:kLMLivingMapPublishNums fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.joinNums] forKey:kLMLivingMapJoinNums];
    [mutableDict setValue:[NSNumber numberWithDouble:self.publishNums] forKey:kLMLivingMapPublishNums];

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

    self.joinNums = [aDecoder decodeDoubleForKey:kLMLivingMapJoinNums];
    self.publishNums = [aDecoder decodeDoubleForKey:kLMLivingMapPublishNums];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_joinNums forKey:kLMLivingMapJoinNums];
    [aCoder encodeDouble:_publishNums forKey:kLMLivingMapPublishNums];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMLivingMap *copy = [[LMLivingMap alloc] init];
    
    if (copy) {

        copy.joinNums = self.joinNums;
        copy.publishNums = self.publishNums;
    }
    
    return copy;
}


@end
