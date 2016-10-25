//
//  LMNoticeList.m
//
//  Created by   on 2016/10/25
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMNoticeList.h"


NSString *const kLMNoticeListCommentUuid = @"comment_uuid";
NSString *const kLMNoticeListContent = @"content";
NSString *const kLMNoticeListArticleUuid = @"article_uuid";
NSString *const kLMNoticeListUserNick = @"userNick";
NSString *const kLMNoticeListNoticeTime = @"notice_time";
NSString *const kLMNoticeListUserUuid = @"user_uuid";
NSString *const kLMNoticeListType = @"type";
NSString *const kLMNoticeListEventUuid = @"event_uuid";
NSString *const kLMNoticeListNoticeUuid = @"notice_uuid";


@interface LMNoticeList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMNoticeList

@synthesize commentUuid = _commentUuid;
@synthesize content = _content;
@synthesize articleUuid = _articleUuid;
@synthesize userNick = _userNick;
@synthesize noticeTime = _noticeTime;
@synthesize userUuid = _userUuid;
@synthesize type = _type;
@synthesize eventUuid = _eventUuid;
@synthesize noticeUuid = _noticeUuid;


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
            self.commentUuid = [self objectOrNilForKey:kLMNoticeListCommentUuid fromDictionary:dict];
            self.content = [self objectOrNilForKey:kLMNoticeListContent fromDictionary:dict];
            self.articleUuid = [self objectOrNilForKey:kLMNoticeListArticleUuid fromDictionary:dict];
            self.userNick = [self objectOrNilForKey:kLMNoticeListUserNick fromDictionary:dict];
            self.noticeTime = [self objectOrNilForKey:kLMNoticeListNoticeTime fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMNoticeListUserUuid fromDictionary:dict];
            self.type = [self objectOrNilForKey:kLMNoticeListType fromDictionary:dict];
            self.eventUuid = [self objectOrNilForKey:kLMNoticeListEventUuid fromDictionary:dict];
            self.noticeUuid = [self objectOrNilForKey:kLMNoticeListNoticeUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.commentUuid forKey:kLMNoticeListCommentUuid];
    [mutableDict setValue:self.content forKey:kLMNoticeListContent];
    [mutableDict setValue:self.articleUuid forKey:kLMNoticeListArticleUuid];
    [mutableDict setValue:self.userNick forKey:kLMNoticeListUserNick];
    [mutableDict setValue:self.noticeTime forKey:kLMNoticeListNoticeTime];
    [mutableDict setValue:self.userUuid forKey:kLMNoticeListUserUuid];
    [mutableDict setValue:self.type forKey:kLMNoticeListType];
    [mutableDict setValue:self.eventUuid forKey:kLMNoticeListEventUuid];
    [mutableDict setValue:self.noticeUuid forKey:kLMNoticeListNoticeUuid];

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

    self.commentUuid = [aDecoder decodeObjectForKey:kLMNoticeListCommentUuid];
    self.content = [aDecoder decodeObjectForKey:kLMNoticeListContent];
    self.articleUuid = [aDecoder decodeObjectForKey:kLMNoticeListArticleUuid];
    self.userNick = [aDecoder decodeObjectForKey:kLMNoticeListUserNick];
    self.noticeTime = [aDecoder decodeObjectForKey:kLMNoticeListNoticeTime];
    self.userUuid = [aDecoder decodeObjectForKey:kLMNoticeListUserUuid];
    self.type = [aDecoder decodeObjectForKey:kLMNoticeListType];
    self.eventUuid = [aDecoder decodeObjectForKey:kLMNoticeListEventUuid];
    self.noticeUuid = [aDecoder decodeObjectForKey:kLMNoticeListNoticeUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_commentUuid forKey:kLMNoticeListCommentUuid];
    [aCoder encodeObject:_content forKey:kLMNoticeListContent];
    [aCoder encodeObject:_articleUuid forKey:kLMNoticeListArticleUuid];
    [aCoder encodeObject:_userNick forKey:kLMNoticeListUserNick];
    [aCoder encodeObject:_noticeTime forKey:kLMNoticeListNoticeTime];
    [aCoder encodeObject:_userUuid forKey:kLMNoticeListUserUuid];
    [aCoder encodeObject:_type forKey:kLMNoticeListType];
    [aCoder encodeObject:_eventUuid forKey:kLMNoticeListEventUuid];
    [aCoder encodeObject:_noticeUuid forKey:kLMNoticeListNoticeUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMNoticeList *copy = [[LMNoticeList alloc] init];
    
    if (copy) {

        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.articleUuid = [self.articleUuid copyWithZone:zone];
        copy.userNick = [self.userNick copyWithZone:zone];
        copy.noticeTime = [self.noticeTime copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.eventUuid = [self.eventUuid copyWithZone:zone];
        copy.noticeUuid = [self.noticeUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
