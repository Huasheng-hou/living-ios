//
//  LMLiveRoomMap.m
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMLiveRoomMap.h"


NSString *const kLMLiveRoomMapJoinNums = @"join_nums";
NSString *const kLMLiveRoomMapPublishNums = @"publish_nums";


@interface LMLiveRoomMap ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMLiveRoomMap

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
            self.joinNums = [[self objectOrNilForKey:kLMLiveRoomMapJoinNums fromDictionary:dict] doubleValue];
            self.publishNums = [[self objectOrNilForKey:kLMLiveRoomMapPublishNums fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.joinNums] forKey:kLMLiveRoomMapJoinNums];
    [mutableDict setValue:[NSNumber numberWithDouble:self.publishNums] forKey:kLMLiveRoomMapPublishNums];

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

    self.joinNums = [aDecoder decodeDoubleForKey:kLMLiveRoomMapJoinNums];
    self.publishNums = [aDecoder decodeDoubleForKey:kLMLiveRoomMapPublishNums];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_joinNums forKey:kLMLiveRoomMapJoinNums];
    [aCoder encodeDouble:_publishNums forKey:kLMLiveRoomMapPublishNums];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMLiveRoomMap *copy = [[LMLiveRoomMap alloc] init];
    
    if (copy) {

        copy.joinNums = self.joinNums;
        copy.publishNums = self.publishNums;
    }
    
    return copy;
}


@end
