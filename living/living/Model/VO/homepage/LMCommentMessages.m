//
//  CommentMessages.m
//
//  Created by   on 16/10/12
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCommentMessages.h"


NSString *const kMessageAvatar = @"avatar";
NSString *const kMessageNickName = @"nick_name";
NSString *const kMessageCommentUuid = @"comment_uuid";
NSString *const kMessageAddress = @"address";
NSString *const kMessagePraiseCount = @"praise_count";
NSString *const kMessageCommentContent = @"comment_content";
NSString *const kMessageUserUuid = @"user_uuid";
NSString *const kMessageCommentTime = @"comment_time";
NSString *const kMessageHasPraised = @"has_praised";


@interface LMCommentMessages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCommentMessages

@synthesize avatar = _avatar;
@synthesize nickName = _nickName;
@synthesize commentUuid = _commentUuid;
@synthesize address = _address;
@synthesize praiseCount = _praiseCount;
@synthesize commentContent = _commentContent;
@synthesize userUuid = _userUuid;
@synthesize commentTime = _commentTime;
@synthesize hasPraised = _hasPraised;


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
        self.avatar = [self objectOrNilForKey:kMessageAvatar fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kMessageNickName fromDictionary:dict];
        self.commentUuid = [self objectOrNilForKey:kMessageCommentUuid fromDictionary:dict];
        self.address = [self objectOrNilForKey:kMessageAddress fromDictionary:dict];
        self.praiseCount = [[self objectOrNilForKey:kMessagePraiseCount fromDictionary:dict] doubleValue];
        self.commentContent = [self objectOrNilForKey:kMessageCommentContent fromDictionary:dict];
        self.userUuid = [self objectOrNilForKey:kMessageUserUuid fromDictionary:dict];
        self.commentTime = [self objectOrNilForKey:kMessageCommentTime fromDictionary:dict];
        self.hasPraised = [[self objectOrNilForKey:kMessageHasPraised fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kMessageAvatar];
    [mutableDict setValue:self.nickName forKey:kMessageNickName];
    [mutableDict setValue:self.commentUuid forKey:kMessageCommentUuid];
    [mutableDict setValue:self.address forKey:kMessageAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.praiseCount] forKey:kMessagePraiseCount];
    [mutableDict setValue:self.commentContent forKey:kMessageCommentContent];
    [mutableDict setValue:self.userUuid forKey:kMessageUserUuid];
    [mutableDict setValue:self.commentTime forKey:kMessageCommentTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kMessageHasPraised];
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

    self.avatar = [aDecoder decodeObjectForKey:kMessageAvatar];
    self.nickName = [aDecoder decodeObjectForKey:kMessageNickName];
    self.commentUuid = [aDecoder decodeObjectForKey:kMessageCommentUuid];
    self.address = [aDecoder decodeObjectForKey:kMessageAddress];
    self.praiseCount = [aDecoder decodeDoubleForKey:kMessagePraiseCount];
    self.commentContent = [aDecoder decodeObjectForKey:kMessageCommentContent];
    self.userUuid = [aDecoder decodeObjectForKey:kMessageUserUuid];
    self.commentTime = [aDecoder decodeObjectForKey:kMessageCommentTime];
    self.hasPraised = [aDecoder decodeBoolForKey:kMessageHasPraised];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kMessageAvatar];
    [aCoder encodeObject:_nickName forKey:kMessageNickName];
    [aCoder encodeObject:_commentUuid forKey:kMessageCommentUuid];
    [aCoder encodeObject:_address forKey:kMessageAddress];
    [aCoder encodeDouble:_praiseCount forKey:kMessagePraiseCount];
    [aCoder encodeObject:_commentContent forKey:kMessageCommentContent];
    [aCoder encodeObject:_userUuid forKey:kMessageUserUuid];
    [aCoder encodeObject:_commentTime forKey:kMessageCommentTime];
    [aCoder encodeBool:_hasPraised forKey:kMessageHasPraised];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCommentMessages *copy = [[LMCommentMessages alloc] init];
    
    if (copy) {

        copy.avatar = [self.avatar copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.praiseCount = self.praiseCount;
        copy.commentContent = [self.commentContent copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.commentTime = [self.commentTime copyWithZone:zone];
        copy.hasPraised = self.hasPraised;
    }
    
    return copy;
}


@end
