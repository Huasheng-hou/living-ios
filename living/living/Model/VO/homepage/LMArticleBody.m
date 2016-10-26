//
//  ArticleBody.m
//
//  Created by   on 16/10/12
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMArticleBody.h"


NSString *const kArticleBodyArticlePraiseNum = @"article_praise_num";
NSString *const kArticleBodyAvatar = @"avatar";
NSString *const kArticleBodyArticleTitle = @"article_title";
NSString *const kArticleBodyArticleContent = @"article_content";
NSString *const kArticleBodyDescribe = @"describe";
NSString *const kArticleBodyHasPraised = @"has_praised";
NSString *const kArticleBodyPublishTime = @"publish_time";
NSString *const kArticleBodyCommentNum = @"comment_num";
NSString *const kArticleBodyArticleName = @"article_name";
NSString *const kArticleBodyUserUuid = @"user_uuid";
NSString *const kArticleBodyArticleUuid = @"article_uuid";
NSString *const kArticleBodyArticleImgs = @"article_imgs";

@interface LMArticleBody ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMArticleBody

@synthesize articlePraiseNum = _articlePraiseNum;
@synthesize avatar = _avatar;
@synthesize articleTitle = _articleTitle;
@synthesize articleContent = _articleContent;
@synthesize describe = _describe;
@synthesize hasPraised = _hasPraised;
@synthesize publishTime = _publishTime;
@synthesize commentNum = _commentNum;
@synthesize articleName = _articleName;
@synthesize userUuid = _userUuid;
@synthesize articleUuid = _articleUuid;
@synthesize articleImgs = _articleImgs;

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
            self.articlePraiseNum = [[self objectOrNilForKey:kArticleBodyArticlePraiseNum fromDictionary:dict] doubleValue];
            self.avatar = [self objectOrNilForKey:kArticleBodyAvatar fromDictionary:dict];
            self.articleTitle = [self objectOrNilForKey:kArticleBodyArticleTitle fromDictionary:dict];
            self.articleContent = [self objectOrNilForKey:kArticleBodyArticleContent fromDictionary:dict];
            self.describe = [self objectOrNilForKey:kArticleBodyDescribe fromDictionary:dict];
            self.hasPraised = [[self objectOrNilForKey:kArticleBodyHasPraised fromDictionary:dict] boolValue];
            self.publishTime = [self objectOrNilForKey:kArticleBodyPublishTime fromDictionary:dict];
            self.commentNum = [[self objectOrNilForKey:kArticleBodyCommentNum fromDictionary:dict] doubleValue];
            self.articleName = [self objectOrNilForKey:kArticleBodyArticleName fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kArticleBodyUserUuid fromDictionary:dict];
            self.articleUuid = [self objectOrNilForKey:kArticleBodyArticleUuid fromDictionary:dict];
            self.articleImgs = [self objectOrNilForKey:kArticleBodyArticleImgs fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.articlePraiseNum] forKey:kArticleBodyArticlePraiseNum];
    [mutableDict setValue:self.avatar forKey:kArticleBodyAvatar];
    [mutableDict setValue:self.articleTitle forKey:kArticleBodyArticleTitle];
    [mutableDict setValue:self.articleContent forKey:kArticleBodyArticleContent];
    [mutableDict setValue:self.describe forKey:kArticleBodyDescribe];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kArticleBodyHasPraised];
    [mutableDict setValue:self.publishTime forKey:kArticleBodyPublishTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentNum] forKey:kArticleBodyCommentNum];
    [mutableDict setValue:self.articleName forKey:kArticleBodyArticleName];
    [mutableDict setValue:self.userUuid forKey:kArticleBodyUserUuid];
    [mutableDict setValue:self.articleUuid forKey:kArticleBodyArticleUuid];
//    [mutableDict setValue:self.articleImgs forKey:kArticleBodyArticleImgs];
    
    
    NSMutableArray *tempArrayForList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.articleImgs) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kArticleBodyArticleImgs];

    

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

    self.articlePraiseNum = [aDecoder decodeDoubleForKey:kArticleBodyArticlePraiseNum];
    self.avatar = [aDecoder decodeObjectForKey:kArticleBodyAvatar];
    self.articleTitle = [aDecoder decodeObjectForKey:kArticleBodyArticleTitle];
    self.articleContent = [aDecoder decodeObjectForKey:kArticleBodyArticleContent];
    self.describe = [aDecoder decodeObjectForKey:kArticleBodyDescribe];
    self.hasPraised = [aDecoder decodeBoolForKey:kArticleBodyHasPraised];
    self.publishTime = [aDecoder decodeObjectForKey:kArticleBodyPublishTime];
    self.commentNum = [aDecoder decodeDoubleForKey:kArticleBodyCommentNum];
    self.articleName = [aDecoder decodeObjectForKey:kArticleBodyArticleName];
    self.userUuid = [aDecoder decodeObjectForKey:kArticleBodyUserUuid];
    self.articleUuid = [aDecoder decodeObjectForKey:kArticleBodyArticleUuid];
    self.articleImgs = [aDecoder decodeObjectForKey:kArticleBodyArticleImgs];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_articlePraiseNum forKey:kArticleBodyArticlePraiseNum];
    [aCoder encodeObject:_avatar forKey:kArticleBodyAvatar];
    [aCoder encodeObject:_articleTitle forKey:kArticleBodyArticleTitle];
    [aCoder encodeObject:_articleContent forKey:kArticleBodyArticleContent];
    [aCoder encodeObject:_describe forKey:kArticleBodyDescribe];
    [aCoder encodeBool:_hasPraised forKey:kArticleBodyHasPraised];
    [aCoder encodeObject:_publishTime forKey:kArticleBodyPublishTime];
    [aCoder encodeDouble:_commentNum forKey:kArticleBodyCommentNum];
    [aCoder encodeObject:_articleName forKey:kArticleBodyArticleName];
    [aCoder encodeObject:_userUuid forKey:kArticleBodyUserUuid];
    [aCoder encodeObject:_articleUuid forKey:kArticleBodyArticleUuid];
    [aCoder encodeObject:_articleImgs forKey:kArticleBodyArticleImgs];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMArticleBody *copy = [[LMArticleBody alloc] init];
    
    if (copy) {

        copy.articlePraiseNum = self.articlePraiseNum;
        copy.avatar = [self.avatar copyWithZone:zone];
        copy.articleTitle = [self.articleTitle copyWithZone:zone];
        copy.articleContent = [self.articleContent copyWithZone:zone];
        copy.describe = [self.describe copyWithZone:zone];
        copy.hasPraised = self.hasPraised;
        copy.publishTime = [self.publishTime copyWithZone:zone];
        copy.commentNum = self.commentNum;
        copy.articleName = [self.articleName copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.articleUuid = [self.articleUuid copyWithZone:zone];
        copy.articleImgs = [self.articleImgs copyWithZone:zone];
    }
    
    return copy;
}


@end
