//
//  LMActicleList.m
//
//  Created by   on 16/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMActicleList.h"


NSString *const kListArticleName = @"article_name";
NSString *const kListArticleUuid = @"article_uuid";
NSString *const kListArticleTitle = @"article_title";
NSString *const kListPublishTime = @"publish_time";
NSString *const kListUserUuid = @"user_uuid";
NSString *const kListAvatar = @"avatar";


@interface LMActicleList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMActicleList

@synthesize articleName = _articleName;
@synthesize articleUuid = _articleUuid;
@synthesize articleTitle = _articleTitle;
@synthesize publishTime = _publishTime;
@synthesize userUuid = _userUuid;
@synthesize avatar = _avatar;


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
            self.articleName = [self objectOrNilForKey:kListArticleName fromDictionary:dict];
            self.articleUuid = [self objectOrNilForKey:kListArticleUuid fromDictionary:dict];
            self.articleTitle = [self objectOrNilForKey:kListArticleTitle fromDictionary:dict];
            self.publishTime = [self objectOrNilForKey:kListPublishTime fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kListUserUuid fromDictionary:dict];
            self.avatar = [self objectOrNilForKey:kListAvatar fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.articleName forKey:kListArticleName];
    [mutableDict setValue:self.articleUuid forKey:kListArticleUuid];
    [mutableDict setValue:self.articleTitle forKey:kListArticleTitle];
    [mutableDict setValue:self.publishTime forKey:kListPublishTime];
    [mutableDict setValue:self.userUuid forKey:kListUserUuid];
    [mutableDict setValue:self.avatar forKey:kListAvatar];

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

    self.articleName = [aDecoder decodeObjectForKey:kListArticleName];
    self.articleUuid = [aDecoder decodeObjectForKey:kListArticleUuid];
    self.articleTitle = [aDecoder decodeObjectForKey:kListArticleTitle];
    self.publishTime = [aDecoder decodeObjectForKey:kListPublishTime];
    self.userUuid = [aDecoder decodeObjectForKey:kListUserUuid];
    self.avatar = [aDecoder decodeObjectForKey:kListAvatar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_articleName forKey:kListArticleName];
    [aCoder encodeObject:_articleUuid forKey:kListArticleUuid];
    [aCoder encodeObject:_articleTitle forKey:kListArticleTitle];
    [aCoder encodeObject:_publishTime forKey:kListPublishTime];
    [aCoder encodeObject:_userUuid forKey:kListUserUuid];
    [aCoder encodeObject:_avatar forKey:kListAvatar];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMActicleList *copy = [[LMActicleList alloc] init];
    
    if (copy) {

        copy.articleName = [self.articleName copyWithZone:zone];
        copy.articleUuid = [self.articleUuid copyWithZone:zone];
        copy.articleTitle = [self.articleTitle copyWithZone:zone];
        copy.publishTime = [self.publishTime copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
    }
    
    return copy;
}


@end
