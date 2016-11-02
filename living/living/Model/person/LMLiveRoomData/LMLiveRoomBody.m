//
//  LMLiveRoomBody.m
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMLiveRoomBody.h"
#import "LMLiveRoomMap.h"
#import "LMLiveRoomLivingInfo.h"


NSString *const kLMLiveRoomBodyResult = @"result";
NSString *const kLMLiveRoomBodyListofUser = @"listofUser";
NSString *const kLMLiveRoomBodyMap = @"map";
NSString *const kLMLiveRoomBodyLivingInfo = @"livingInfo";
NSString *const kLMLiveRoomBodyDescription = @"description";
NSString *const kLMLiveRoomBodyList = @"list";


@interface LMLiveRoomBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMLiveRoomBody

@synthesize result = _result;
@synthesize listofUser = _listofUser;
@synthesize map = _map;
@synthesize livingInfo = _livingInfo;
@synthesize bodyDescription = _bodyDescription;
@synthesize list = _list;


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
            self.result = [self objectOrNilForKey:kLMLiveRoomBodyResult fromDictionary:dict];
            self.listofUser = [self objectOrNilForKey:kLMLiveRoomBodyListofUser fromDictionary:dict];
            self.map = [LMLiveRoomMap modelObjectWithDictionary:[dict objectForKey:kLMLiveRoomBodyMap]];
            self.livingInfo = [LMLiveRoomLivingInfo modelObjectWithDictionary:[dict objectForKey:kLMLiveRoomBodyLivingInfo]];
            self.bodyDescription = [self objectOrNilForKey:kLMLiveRoomBodyDescription fromDictionary:dict];
            self.list = [self objectOrNilForKey:kLMLiveRoomBodyList fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.result forKey:kLMLiveRoomBodyResult];
    NSMutableArray *tempArrayForListofUser = [NSMutableArray array];
    for (NSObject *subArrayObject in self.listofUser) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForListofUser addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForListofUser addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForListofUser] forKey:kLMLiveRoomBodyListofUser];
    [mutableDict setValue:[self.map dictionaryRepresentation] forKey:kLMLiveRoomBodyMap];
    [mutableDict setValue:[self.livingInfo dictionaryRepresentation] forKey:kLMLiveRoomBodyLivingInfo];
    [mutableDict setValue:self.bodyDescription forKey:kLMLiveRoomBodyDescription];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kLMLiveRoomBodyList];

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

    self.result = [aDecoder decodeObjectForKey:kLMLiveRoomBodyResult];
    self.listofUser = [aDecoder decodeObjectForKey:kLMLiveRoomBodyListofUser];
    self.map = [aDecoder decodeObjectForKey:kLMLiveRoomBodyMap];
    self.livingInfo = [aDecoder decodeObjectForKey:kLMLiveRoomBodyLivingInfo];
    self.bodyDescription = [aDecoder decodeObjectForKey:kLMLiveRoomBodyDescription];
    self.list = [aDecoder decodeObjectForKey:kLMLiveRoomBodyList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_result forKey:kLMLiveRoomBodyResult];
    [aCoder encodeObject:_listofUser forKey:kLMLiveRoomBodyListofUser];
    [aCoder encodeObject:_map forKey:kLMLiveRoomBodyMap];
    [aCoder encodeObject:_livingInfo forKey:kLMLiveRoomBodyLivingInfo];
    [aCoder encodeObject:_bodyDescription forKey:kLMLiveRoomBodyDescription];
    [aCoder encodeObject:_list forKey:kLMLiveRoomBodyList];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMLiveRoomBody *copy = [[LMLiveRoomBody alloc] init];
    
    if (copy) {

        copy.result = [self.result copyWithZone:zone];
        copy.listofUser = [self.listofUser copyWithZone:zone];
        copy.map = [self.map copyWithZone:zone];
        copy.livingInfo = [self.livingInfo copyWithZone:zone];
        copy.bodyDescription = [self.bodyDescription copyWithZone:zone];
        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
