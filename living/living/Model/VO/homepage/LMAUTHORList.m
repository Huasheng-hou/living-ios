//
//  LMAUTHORList.m
//
//  Created by   on 2016/11/1
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMAUTHORList.h"


NSString *const kLMAUTHORListArticleContent = @"article_content";
NSString *const kLMAUTHORListNickname = @"nickname";
NSString *const kLMAUTHORListTitle = @"title";
NSString *const kLMAUTHORListPublishTime = @"publish_time";
NSString *const kLMAUTHORListCover = @"cover";
NSString *const kLMAUTHORListAuthorUuid = @"author_uuid";
NSString *const kLMAUTHORListArticleUuid = @"article_uuid";


@interface LMAUTHORList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMAUTHORList

@synthesize articleContent = _articleContent;
@synthesize nickname = _nickname;
@synthesize title = _title;
@synthesize publishTime = _publishTime;
@synthesize cover = _cover;
@synthesize authorUuid = _authorUuid;
@synthesize articleUuid = _articleUuid;


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
            self.articleContent = [self objectOrNilForKey:kLMAUTHORListArticleContent fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kLMAUTHORListNickname fromDictionary:dict];
            self.title = [self objectOrNilForKey:kLMAUTHORListTitle fromDictionary:dict];
            self.publishTime = [self objectOrNilForKey:kLMAUTHORListPublishTime fromDictionary:dict];
            self.cover = [self objectOrNilForKey:kLMAUTHORListCover fromDictionary:dict];
            self.authorUuid = [self objectOrNilForKey:kLMAUTHORListAuthorUuid fromDictionary:dict];
            self.articleUuid = [self objectOrNilForKey:kLMAUTHORListArticleUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.articleContent forKey:kLMAUTHORListArticleContent];
    [mutableDict setValue:self.nickname forKey:kLMAUTHORListNickname];
    [mutableDict setValue:self.title forKey:kLMAUTHORListTitle];
    [mutableDict setValue:self.publishTime forKey:kLMAUTHORListPublishTime];
    [mutableDict setValue:self.cover forKey:kLMAUTHORListCover];
    [mutableDict setValue:self.authorUuid forKey:kLMAUTHORListAuthorUuid];
    [mutableDict setValue:self.articleUuid forKey:kLMAUTHORListArticleUuid];

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

    self.articleContent = [aDecoder decodeObjectForKey:kLMAUTHORListArticleContent];
    self.nickname = [aDecoder decodeObjectForKey:kLMAUTHORListNickname];
    self.title = [aDecoder decodeObjectForKey:kLMAUTHORListTitle];
    self.publishTime = [aDecoder decodeObjectForKey:kLMAUTHORListPublishTime];
    self.cover = [aDecoder decodeObjectForKey:kLMAUTHORListCover];
    self.authorUuid = [aDecoder decodeObjectForKey:kLMAUTHORListAuthorUuid];
    self.articleUuid = [aDecoder decodeObjectForKey:kLMAUTHORListArticleUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_articleContent forKey:kLMAUTHORListArticleContent];
    [aCoder encodeObject:_nickname forKey:kLMAUTHORListNickname];
    [aCoder encodeObject:_title forKey:kLMAUTHORListTitle];
    [aCoder encodeObject:_publishTime forKey:kLMAUTHORListPublishTime];
    [aCoder encodeObject:_cover forKey:kLMAUTHORListCover];
    [aCoder encodeObject:_authorUuid forKey:kLMAUTHORListAuthorUuid];
    [aCoder encodeObject:_articleUuid forKey:kLMAUTHORListArticleUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMAUTHORList *copy = [[LMAUTHORList alloc] init];
    
    if (copy) {

        copy.articleContent = [self.articleContent copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.publishTime = [self.publishTime copyWithZone:zone];
        copy.cover = [self.cover copyWithZone:zone];
        copy.authorUuid = [self.authorUuid copyWithZone:zone];
        copy.articleUuid = [self.articleUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
