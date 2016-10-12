//
//  CommentMessages.m
//
//  Created by   on 16/10/12
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCommentMessages.h"


NSString *const kCommentMessagesNickName = @"nick_name";
NSString *const kCommentMessagesCommentUuid = @"comment_uuid";
NSString *const kCommentMessagesAvatar = @"avatar";
NSString *const kCommentMessagesPraiseCount = @"praise_count";
NSString *const kCommentMessagesCommentContent = @"comment_content";
NSString *const kCommentMessagesUserUuid = @"user_uuid";
NSString *const kCommentMessagesCommentTime = @"comment_time";
NSString *const kCommentMessagesHasPraised = @"has_praised";


@interface LMCommentMessages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCommentMessages

@synthesize nickName = _nickName;
@synthesize commentUuid = _commentUuid;
@synthesize avatar = _avatar;
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
            self.nickName = [self objectOrNilForKey:kCommentMessagesNickName fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kCommentMessagesCommentUuid fromDictionary:dict];
            self.avatar = [self objectOrNilForKey:kCommentMessagesAvatar fromDictionary:dict];
            self.praiseCount = [[self objectOrNilForKey:kCommentMessagesPraiseCount fromDictionary:dict] doubleValue];
            self.commentContent = [self objectOrNilForKey:kCommentMessagesCommentContent fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kCommentMessagesUserUuid fromDictionary:dict];
            self.commentTime = [self objectOrNilForKey:kCommentMessagesCommentTime fromDictionary:dict];
            self.hasPraised = [[self objectOrNilForKey:kCommentMessagesHasPraised fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nickName forKey:kCommentMessagesNickName];
    [mutableDict setValue:self.commentUuid forKey:kCommentMessagesCommentUuid];
    [mutableDict setValue:self.avatar forKey:kCommentMessagesAvatar];
    [mutableDict setValue:[NSNumber numberWithDouble:self.praiseCount] forKey:kCommentMessagesPraiseCount];
    [mutableDict setValue:self.commentContent forKey:kCommentMessagesCommentContent];
    [mutableDict setValue:self.userUuid forKey:kCommentMessagesUserUuid];
    [mutableDict setValue:self.commentTime forKey:kCommentMessagesCommentTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kCommentMessagesHasPraised];

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

    self.nickName = [aDecoder decodeObjectForKey:kCommentMessagesNickName];
    self.commentUuid = [aDecoder decodeObjectForKey:kCommentMessagesCommentUuid];
    self.avatar = [aDecoder decodeObjectForKey:kCommentMessagesAvatar];
    self.praiseCount = [aDecoder decodeDoubleForKey:kCommentMessagesPraiseCount];
    self.commentContent = [aDecoder decodeObjectForKey:kCommentMessagesCommentContent];
    self.userUuid = [aDecoder decodeObjectForKey:kCommentMessagesUserUuid];
    self.commentTime = [aDecoder decodeObjectForKey:kCommentMessagesCommentTime];
    self.hasPraised = [aDecoder decodeBoolForKey:kCommentMessagesHasPraised];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_nickName forKey:kCommentMessagesNickName];
    [aCoder encodeObject:_commentUuid forKey:kCommentMessagesCommentUuid];
    [aCoder encodeObject:_avatar forKey:kCommentMessagesAvatar];
    [aCoder encodeDouble:_praiseCount forKey:kCommentMessagesPraiseCount];
    [aCoder encodeObject:_commentContent forKey:kCommentMessagesCommentContent];
    [aCoder encodeObject:_userUuid forKey:kCommentMessagesUserUuid];
    [aCoder encodeObject:_commentTime forKey:kCommentMessagesCommentTime];
    [aCoder encodeBool:_hasPraised forKey:kCommentMessagesHasPraised];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCommentMessages *copy = [[LMCommentMessages alloc] init];
    
    if (copy) {

        copy.nickName = [self.nickName copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
        copy.praiseCount = self.praiseCount;
        copy.commentContent = [self.commentContent copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.commentTime = [self.commentTime copyWithZone:zone];
        copy.hasPraised = self.hasPraised;
    }
    
    return copy;
}


@end
