//
//  LMNoticList.m
//
//  Created by   on 16/10/20
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMNoticList.h"


NSString *const kLMNoticListType = @"type";
NSString *const kLMNoticListEventUuid = @"event_uuid";
NSString *const kLMNoticListUserNick = @"userNick";
NSString *const kLMNoticListCommentUuid = @"comment_uuid";
NSString *const kLMNoticListContent = @"content";
NSString *const kLMNoticListUserUuid = @"user_uuid";
NSString *const kLMNoticListNoticeTime = @"notice_time";


@interface LMNoticList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMNoticList

@synthesize type = _type;
@synthesize eventUuid = _eventUuid;
@synthesize userNick = _userNick;
@synthesize commentUuid = _commentUuid;
@synthesize content = _content;
@synthesize userUuid = _userUuid;
@synthesize noticeTime = _noticeTime;


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
            self.type = [self objectOrNilForKey:kLMNoticListType fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMNoticListEventUuid fromDictionary:dict];
            self.userNick = [self objectOrNilForKey:kLMNoticListUserNick fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kLMNoticListCommentUuid fromDictionary:dict];
            self.content = [self objectOrNilForKey:kLMNoticListContent fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMNoticListUserUuid fromDictionary:dict];
            self.noticeTime = [self objectOrNilForKey:kLMNoticListNoticeTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.type forKey:kLMNoticListType];
    [mutableDict setValue:self.eventUuid forKey:kLMNoticListEventUuid];
    [mutableDict setValue:self.userNick forKey:kLMNoticListUserNick];
    [mutableDict setValue:self.commentUuid forKey:kLMNoticListCommentUuid];
    [mutableDict setValue:self.content forKey:kLMNoticListContent];
    [mutableDict setValue:self.userUuid forKey:kLMNoticListUserUuid];
    [mutableDict setValue:self.noticeTime forKey:kLMNoticListNoticeTime];

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

    self.type = [aDecoder decodeObjectForKey:kLMNoticListType];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMNoticListEventUuid];
    self.userNick = [aDecoder decodeObjectForKey:kLMNoticListUserNick];
    self.commentUuid = [aDecoder decodeObjectForKey:kLMNoticListCommentUuid];
    self.content = [aDecoder decodeObjectForKey:kLMNoticListContent];
    self.userUuid = [aDecoder decodeObjectForKey:kLMNoticListUserUuid];
    self.noticeTime = [aDecoder decodeObjectForKey:kLMNoticListNoticeTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_type forKey:kLMNoticListType];
    [aCoder encodeObject:_eventUuid forKey:kLMNoticListEventUuid];
    [aCoder encodeObject:_userNick forKey:kLMNoticListUserNick];
    [aCoder encodeObject:_commentUuid forKey:kLMNoticListCommentUuid];
    [aCoder encodeObject:_content forKey:kLMNoticListContent];
    [aCoder encodeObject:_userUuid forKey:kLMNoticListUserUuid];
    [aCoder encodeObject:_noticeTime forKey:kLMNoticListNoticeTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMNoticList *copy = [[LMNoticList alloc] init];
    
    if (copy) {

        copy.type = [self.type copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.userNick = [self.userNick copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.noticeTime = [self.noticeTime copyWithZone:zone];
    }
    
    return copy;
}


@end
