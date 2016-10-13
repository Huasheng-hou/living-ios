//
//  LMEventDetailLeavingMessages.m
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMEventDetailLeavingMessages.h"


NSString *const kLMEventDetailLeavingMessagesAvatar = @"avatar";
NSString *const kLMEventDetailLeavingMessagesNickName = @"nick_name";
NSString *const kLMEventDetailLeavingMessagesCommentUuid = @"comment_uuid";
NSString *const kLMEventDetailLeavingMessagesAddress = @"address";
NSString *const kLMEventDetailLeavingMessagesPraiseCount = @"praise_count";
NSString *const kLMEventDetailLeavingMessagesCommentContent = @"comment_content";
NSString *const kLMEventDetailLeavingMessagesUserUuid = @"user_uuid";
NSString *const kLMEventDetailLeavingMessagesCommentTime = @"comment_time";
NSString *const kLMEventDetailLeavingMessagesHasPraised = @"has_praised";


@interface LMEventDetailLeavingMessages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMEventDetailLeavingMessages

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
            self.avatar = [self objectOrNilForKey:kLMEventDetailLeavingMessagesAvatar fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kLMEventDetailLeavingMessagesNickName fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentUuid fromDictionary:dict];
            self.address = [self objectOrNilForKey:kLMEventDetailLeavingMessagesAddress fromDictionary:dict];
            self.praiseCount = [[self objectOrNilForKey:kLMEventDetailLeavingMessagesPraiseCount fromDictionary:dict] doubleValue];
            self.commentContent = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentContent fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMEventDetailLeavingMessagesUserUuid fromDictionary:dict];
            self.commentTime = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentTime fromDictionary:dict];
            self.hasPraised = [[self objectOrNilForKey:kLMEventDetailLeavingMessagesHasPraised fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kLMEventDetailLeavingMessagesAvatar];
    [mutableDict setValue:self.nickName forKey:kLMEventDetailLeavingMessagesNickName];
    [mutableDict setValue:self.commentUuid forKey:kLMEventDetailLeavingMessagesCommentUuid];
    [mutableDict setValue:self.address forKey:kLMEventDetailLeavingMessagesAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.praiseCount] forKey:kLMEventDetailLeavingMessagesPraiseCount];
    [mutableDict setValue:self.commentContent forKey:kLMEventDetailLeavingMessagesCommentContent];
    [mutableDict setValue:self.userUuid forKey:kLMEventDetailLeavingMessagesUserUuid];
    [mutableDict setValue:self.commentTime forKey:kLMEventDetailLeavingMessagesCommentTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kLMEventDetailLeavingMessagesHasPraised];

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

    self.avatar = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesAvatar];
    self.nickName = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesNickName];
    self.commentUuid = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentUuid];
    self.address = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesAddress];
    self.praiseCount = [aDecoder decodeDoubleForKey:kLMEventDetailLeavingMessagesPraiseCount];
    self.commentContent = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentContent];
    self.userUuid = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesUserUuid];
    self.commentTime = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentTime];
    self.hasPraised = [aDecoder decodeBoolForKey:kLMEventDetailLeavingMessagesHasPraised];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kLMEventDetailLeavingMessagesAvatar];
    [aCoder encodeObject:_nickName forKey:kLMEventDetailLeavingMessagesNickName];
    [aCoder encodeObject:_commentUuid forKey:kLMEventDetailLeavingMessagesCommentUuid];
    [aCoder encodeObject:_address forKey:kLMEventDetailLeavingMessagesAddress];
    [aCoder encodeDouble:_praiseCount forKey:kLMEventDetailLeavingMessagesPraiseCount];
    [aCoder encodeObject:_commentContent forKey:kLMEventDetailLeavingMessagesCommentContent];
    [aCoder encodeObject:_userUuid forKey:kLMEventDetailLeavingMessagesUserUuid];
    [aCoder encodeObject:_commentTime forKey:kLMEventDetailLeavingMessagesCommentTime];
    [aCoder encodeBool:_hasPraised forKey:kLMEventDetailLeavingMessagesHasPraised];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMEventDetailLeavingMessages *copy = [[LMEventDetailLeavingMessages alloc] init];
    
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
