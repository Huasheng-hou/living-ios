//
//  LMAriticleCommentMessages.m
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMAriticleCommentMessages.h"


NSString *const kLMAriticleCommentMessagesReplyTime = @"reply_time";
NSString *const kLMAriticleCommentMessagesPraiseCount = @"praise_count";
NSString *const kLMAriticleCommentMessagesReplyUuid = @"reply_uuid";
NSString *const kLMAriticleCommentMessagesUserUuid = @"user_uuid";
NSString *const kLMAriticleCommentMessagesCommentTime = @"comment_time";
NSString *const kLMAriticleCommentMessagesCommentUuid = @"comment_uuid";
NSString *const kLMAriticleCommentMessagesNickName = @"nick_name";
NSString *const kLMAriticleCommentMessagesType = @"type";
NSString *const kLMAriticleCommentMessagesRespondentNickname = @"respondent_nickname";
NSString *const kLMAriticleCommentMessagesAvatar = @"avatar";
NSString *const kLMAriticleCommentMessagesAddress = @"address";
NSString *const kLMAriticleCommentMessagesHasPraised = @"has_praised";
NSString *const kLMAriticleCommentMessagesCommentContent = @"comment_content";


@interface LMAriticleCommentMessages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMAriticleCommentMessages

@synthesize replyTime = _replyTime;
@synthesize praiseCount = _praiseCount;
@synthesize replyUuid = _replyUuid;
@synthesize userUuid = _userUuid;
@synthesize commentTime = _commentTime;
@synthesize commentUuid = _commentUuid;
@synthesize nickName = _nickName;
@synthesize type = _type;
@synthesize respondentNickname = _respondentNickname;
@synthesize avatar = _avatar;
@synthesize address = _address;
@synthesize hasPraised = _hasPraised;
@synthesize commentContent = _commentContent;


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
        self.replyTime = [self objectOrNilForKey:kLMAriticleCommentMessagesReplyTime fromDictionary:dict];
        self.praiseCount = [[self objectOrNilForKey:kLMAriticleCommentMessagesPraiseCount fromDictionary:dict] doubleValue];
        self.replyUuid = [self objectOrNilForKey:kLMAriticleCommentMessagesReplyUuid fromDictionary:dict];
        self.userUuid = [self objectOrNilForKey:kLMAriticleCommentMessagesUserUuid fromDictionary:dict];
        self.commentTime = [self objectOrNilForKey:kLMAriticleCommentMessagesCommentTime fromDictionary:dict];
        self.commentUuid = [self objectOrNilForKey:kLMAriticleCommentMessagesCommentUuid fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kLMAriticleCommentMessagesNickName fromDictionary:dict];
        self.type = [self objectOrNilForKey:kLMAriticleCommentMessagesType fromDictionary:dict];
        self.respondentNickname = [self objectOrNilForKey:kLMAriticleCommentMessagesRespondentNickname fromDictionary:dict];
        self.avatar = [self objectOrNilForKey:kLMAriticleCommentMessagesAvatar fromDictionary:dict];
        self.address = [self objectOrNilForKey:kLMAriticleCommentMessagesAddress fromDictionary:dict];
        self.hasPraised = [[self objectOrNilForKey:kLMAriticleCommentMessagesHasPraised fromDictionary:dict] boolValue];
        self.commentContent = [self objectOrNilForKey:kLMAriticleCommentMessagesCommentContent fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.replyTime forKey:kLMAriticleCommentMessagesReplyTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.praiseCount] forKey:kLMAriticleCommentMessagesPraiseCount];
    [mutableDict setValue:self.replyUuid forKey:kLMAriticleCommentMessagesReplyUuid];
    [mutableDict setValue:self.userUuid forKey:kLMAriticleCommentMessagesUserUuid];
    [mutableDict setValue:self.commentTime forKey:kLMAriticleCommentMessagesCommentTime];
    [mutableDict setValue:self.commentUuid forKey:kLMAriticleCommentMessagesCommentUuid];
    [mutableDict setValue:self.nickName forKey:kLMAriticleCommentMessagesNickName];
    [mutableDict setValue:self.type forKey:kLMAriticleCommentMessagesType];
    [mutableDict setValue:self.respondentNickname forKey:kLMAriticleCommentMessagesRespondentNickname];
    [mutableDict setValue:self.avatar forKey:kLMAriticleCommentMessagesAvatar];
    [mutableDict setValue:self.address forKey:kLMAriticleCommentMessagesAddress];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kLMAriticleCommentMessagesHasPraised];
    [mutableDict setValue:self.commentContent forKey:kLMAriticleCommentMessagesCommentContent];
    
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
    
    self.replyTime = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesReplyTime];
    self.praiseCount = [aDecoder decodeDoubleForKey:kLMAriticleCommentMessagesPraiseCount];
    self.replyUuid = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesReplyUuid];
    self.userUuid = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesUserUuid];
    self.commentTime = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesCommentTime];
    self.commentUuid = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesCommentUuid];
    self.nickName = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesNickName];
    self.type = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesType];
    self.respondentNickname = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesRespondentNickname];
    self.avatar = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesAvatar];
    self.address = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesAddress];
    self.hasPraised = [aDecoder decodeBoolForKey:kLMAriticleCommentMessagesHasPraised];
    self.commentContent = [aDecoder decodeObjectForKey:kLMAriticleCommentMessagesCommentContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_replyTime forKey:kLMAriticleCommentMessagesReplyTime];
    [aCoder encodeDouble:_praiseCount forKey:kLMAriticleCommentMessagesPraiseCount];
    [aCoder encodeObject:_replyUuid forKey:kLMAriticleCommentMessagesReplyUuid];
    [aCoder encodeObject:_userUuid forKey:kLMAriticleCommentMessagesUserUuid];
    [aCoder encodeObject:_commentTime forKey:kLMAriticleCommentMessagesCommentTime];
    [aCoder encodeObject:_commentUuid forKey:kLMAriticleCommentMessagesCommentUuid];
    [aCoder encodeObject:_nickName forKey:kLMAriticleCommentMessagesNickName];
    [aCoder encodeObject:_type forKey:kLMAriticleCommentMessagesType];
    [aCoder encodeObject:_respondentNickname forKey:kLMAriticleCommentMessagesRespondentNickname];
    [aCoder encodeObject:_avatar forKey:kLMAriticleCommentMessagesAvatar];
    [aCoder encodeObject:_address forKey:kLMAriticleCommentMessagesAddress];
    [aCoder encodeBool:_hasPraised forKey:kLMAriticleCommentMessagesHasPraised];
    [aCoder encodeObject:_commentContent forKey:kLMAriticleCommentMessagesCommentContent];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMAriticleCommentMessages *copy = [[LMAriticleCommentMessages alloc] init];
    
    if (copy) {
        
        copy.replyTime = [self.replyTime copyWithZone:zone];
        copy.praiseCount = self.praiseCount;
        copy.replyUuid = [self.replyUuid copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.commentTime = [self.commentTime copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.respondentNickname = [self.respondentNickname copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.hasPraised = self.hasPraised;
        copy.commentContent = [self.commentContent copyWithZone:zone];
    }
    
    return copy;
}


@end
