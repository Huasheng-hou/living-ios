//
//  LMEventDetailLeavingMessages.m
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMEventDetailLeavingMessages.h"


NSString *const kLMEventDetailLeavingMessagesCommentContent = @"comment_content";
NSString *const kLMEventDetailLeavingMessagesReplyTime = @"reply_time";
NSString *const kLMEventDetailLeavingMessagesReplyUuid = @"reply_uuid";
NSString *const kLMEventDetailLeavingMessagesUserUuid = @"user_uuid";
NSString *const kLMEventDetailLeavingMessagesCommentTime = @"comment_time";
NSString *const kLMEventDetailLeavingMessagesCommentUuid = @"comment_uuid";
NSString *const kLMEventDetailLeavingMessagesNickName = @"nick_name";
NSString *const kLMEventDetailLeavingMessagesType = @"type";
NSString *const kLMEventDetailLeavingMessagesRespondentNickname = @"respondent_nickname";
NSString *const kLMEventDetailLeavingMessagesAvatar = @"avatar";
NSString *const kLMEventDetailLeavingMessagesAddress = @"address";
NSString *const kLMEventDetailLeavingMessagesHasPraised = @"has_praised";
NSString *const kLMEventDetailLeavingMessagesPraiseCount = @"praise_count";


@interface LMEventDetailLeavingMessages ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMEventDetailLeavingMessages

@synthesize commentContent = _commentContent;
@synthesize replyTime = _replyTime;
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
@synthesize praiseCount = _praiseCount;


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
            self.commentContent = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentContent fromDictionary:dict];
            self.replyTime = [self objectOrNilForKey:kLMEventDetailLeavingMessagesReplyTime fromDictionary:dict];
            self.replyUuid = [self objectOrNilForKey:kLMEventDetailLeavingMessagesReplyUuid fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMEventDetailLeavingMessagesUserUuid fromDictionary:dict];
            self.commentTime = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentTime fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kLMEventDetailLeavingMessagesCommentUuid fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kLMEventDetailLeavingMessagesNickName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kLMEventDetailLeavingMessagesType fromDictionary:dict];
            self.respondentNickname = [self objectOrNilForKey:kLMEventDetailLeavingMessagesRespondentNickname fromDictionary:dict];
            self.avatar = [self objectOrNilForKey:kLMEventDetailLeavingMessagesAvatar fromDictionary:dict];
            self.address = [self objectOrNilForKey:kLMEventDetailLeavingMessagesAddress fromDictionary:dict];
            self.hasPraised = [[self objectOrNilForKey:kLMEventDetailLeavingMessagesHasPraised fromDictionary:dict] boolValue];
            self.praiseCount = [[self objectOrNilForKey:kLMEventDetailLeavingMessagesPraiseCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.commentContent forKey:kLMEventDetailLeavingMessagesCommentContent];
    [mutableDict setValue:self.replyTime forKey:kLMEventDetailLeavingMessagesReplyTime];
    [mutableDict setValue:self.replyUuid forKey:kLMEventDetailLeavingMessagesReplyUuid];
    [mutableDict setValue:self.userUuid forKey:kLMEventDetailLeavingMessagesUserUuid];
    [mutableDict setValue:self.commentTime forKey:kLMEventDetailLeavingMessagesCommentTime];
    [mutableDict setValue:self.commentUuid forKey:kLMEventDetailLeavingMessagesCommentUuid];
    [mutableDict setValue:self.nickName forKey:kLMEventDetailLeavingMessagesNickName];
    [mutableDict setValue:self.type forKey:kLMEventDetailLeavingMessagesType];
    [mutableDict setValue:self.respondentNickname forKey:kLMEventDetailLeavingMessagesRespondentNickname];
    [mutableDict setValue:self.avatar forKey:kLMEventDetailLeavingMessagesAvatar];
    [mutableDict setValue:self.address forKey:kLMEventDetailLeavingMessagesAddress];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasPraised] forKey:kLMEventDetailLeavingMessagesHasPraised];
    [mutableDict setValue:[NSNumber numberWithDouble:self.praiseCount] forKey:kLMEventDetailLeavingMessagesPraiseCount];

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

    self.commentContent = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentContent];
    self.replyTime = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesReplyTime];
    self.replyUuid = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesReplyUuid];
    self.userUuid = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesUserUuid];
    self.commentTime = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentTime];
    self.commentUuid = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesCommentUuid];
    self.nickName = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesNickName];
    self.type = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesType];
    self.respondentNickname = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesRespondentNickname];
    self.avatar = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesAvatar];
    self.address = [aDecoder decodeObjectForKey:kLMEventDetailLeavingMessagesAddress];
    self.hasPraised = [aDecoder decodeBoolForKey:kLMEventDetailLeavingMessagesHasPraised];
    self.praiseCount = [aDecoder decodeDoubleForKey:kLMEventDetailLeavingMessagesPraiseCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_commentContent forKey:kLMEventDetailLeavingMessagesCommentContent];
    [aCoder encodeObject:_replyTime forKey:kLMEventDetailLeavingMessagesReplyTime];
    [aCoder encodeObject:_replyUuid forKey:kLMEventDetailLeavingMessagesReplyUuid];
    [aCoder encodeObject:_userUuid forKey:kLMEventDetailLeavingMessagesUserUuid];
    [aCoder encodeObject:_commentTime forKey:kLMEventDetailLeavingMessagesCommentTime];
    [aCoder encodeObject:_commentUuid forKey:kLMEventDetailLeavingMessagesCommentUuid];
    [aCoder encodeObject:_nickName forKey:kLMEventDetailLeavingMessagesNickName];
    [aCoder encodeObject:_type forKey:kLMEventDetailLeavingMessagesType];
    [aCoder encodeObject:_respondentNickname forKey:kLMEventDetailLeavingMessagesRespondentNickname];
    [aCoder encodeObject:_avatar forKey:kLMEventDetailLeavingMessagesAvatar];
    [aCoder encodeObject:_address forKey:kLMEventDetailLeavingMessagesAddress];
    [aCoder encodeBool:_hasPraised forKey:kLMEventDetailLeavingMessagesHasPraised];
    [aCoder encodeDouble:_praiseCount forKey:kLMEventDetailLeavingMessagesPraiseCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMEventDetailLeavingMessages *copy = [[LMEventDetailLeavingMessages alloc] init];
    
    if (copy) {

        copy.commentContent = [self.commentContent copyWithZone:zone];
        copy.replyTime = [self.replyTime copyWithZone:zone];
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
        copy.praiseCount = self.praiseCount;
    }
    
    return copy;
}


@end
