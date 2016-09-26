//
//  RequiredQuestion.m
//
//  Created by   on 16/8/31
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "RequiredQuestion.h"


NSString *const kRequiredQuestionGender = @"gender";
NSString *const kRequiredQuestionRequiredAt = @"required_at";
NSString *const kRequiredQuestionContent = @"content";
NSString *const kRequiredQuestionQuestionUuid = @"question_uuid";
NSString *const kRequiredQuestionCreatedAt = @"created_at";
NSString *const kRequiredQuestionUserUuid = @"user_uuid";
NSString *const kRequiredQuestionUpdatedAt = @"updated_at";
NSString *const kRequiredQuestionImageUrls = @"image_urls";
NSString *const kRequiredQuestionTickets = @"tickets";


@interface RequiredQuestion ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RequiredQuestion

@synthesize gender = _gender;
@synthesize requiredAt = _requiredAt;
@synthesize content = _content;
@synthesize questionUuid = _questionUuid;
@synthesize createdAt = _createdAt;
@synthesize userUuid = _userUuid;
@synthesize updatedAt = _updatedAt;
@synthesize imageUrls = _imageUrls;
@synthesize tickets = _tickets;


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
            self.gender = [[self objectOrNilForKey:kRequiredQuestionGender fromDictionary:dict] doubleValue];
            self.requiredAt = [self objectOrNilForKey:kRequiredQuestionRequiredAt fromDictionary:dict];
            self.content = [self objectOrNilForKey:kRequiredQuestionContent fromDictionary:dict];
            self.questionUuid = [self objectOrNilForKey:kRequiredQuestionQuestionUuid fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kRequiredQuestionCreatedAt fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kRequiredQuestionUserUuid fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kRequiredQuestionUpdatedAt fromDictionary:dict];
            self.imageUrls = [self objectOrNilForKey:kRequiredQuestionImageUrls fromDictionary:dict];
            self.tickets = [[self objectOrNilForKey:kRequiredQuestionTickets fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kRequiredQuestionGender];
    [mutableDict setValue:self.requiredAt forKey:kRequiredQuestionRequiredAt];
    [mutableDict setValue:self.content forKey:kRequiredQuestionContent];
    [mutableDict setValue:self.questionUuid forKey:kRequiredQuestionQuestionUuid];
    [mutableDict setValue:self.createdAt forKey:kRequiredQuestionCreatedAt];
    [mutableDict setValue:self.userUuid forKey:kRequiredQuestionUserUuid];
    [mutableDict setValue:self.updatedAt forKey:kRequiredQuestionUpdatedAt];
    NSMutableArray *tempArrayForImageUrls = [NSMutableArray array];
    for (NSObject *subArrayObject in self.imageUrls) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForImageUrls addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForImageUrls addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForImageUrls] forKey:kRequiredQuestionImageUrls];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tickets] forKey:kRequiredQuestionTickets];

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

    self.gender = [aDecoder decodeDoubleForKey:kRequiredQuestionGender];
    self.requiredAt = [aDecoder decodeObjectForKey:kRequiredQuestionRequiredAt];
    self.content = [aDecoder decodeObjectForKey:kRequiredQuestionContent];
    self.questionUuid = [aDecoder decodeObjectForKey:kRequiredQuestionQuestionUuid];
    self.createdAt = [aDecoder decodeObjectForKey:kRequiredQuestionCreatedAt];
    self.userUuid = [aDecoder decodeObjectForKey:kRequiredQuestionUserUuid];
    self.updatedAt = [aDecoder decodeObjectForKey:kRequiredQuestionUpdatedAt];
    self.imageUrls = [aDecoder decodeObjectForKey:kRequiredQuestionImageUrls];
    self.tickets = [aDecoder decodeDoubleForKey:kRequiredQuestionTickets];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_gender forKey:kRequiredQuestionGender];
    [aCoder encodeObject:_requiredAt forKey:kRequiredQuestionRequiredAt];
    [aCoder encodeObject:_content forKey:kRequiredQuestionContent];
    [aCoder encodeObject:_questionUuid forKey:kRequiredQuestionQuestionUuid];
    [aCoder encodeObject:_createdAt forKey:kRequiredQuestionCreatedAt];
    [aCoder encodeObject:_userUuid forKey:kRequiredQuestionUserUuid];
    [aCoder encodeObject:_updatedAt forKey:kRequiredQuestionUpdatedAt];
    [aCoder encodeObject:_imageUrls forKey:kRequiredQuestionImageUrls];
    [aCoder encodeDouble:_tickets forKey:kRequiredQuestionTickets];
}

- (id)copyWithZone:(NSZone *)zone
{
    RequiredQuestion *copy = [[RequiredQuestion alloc] init];
    
    if (copy) {

        copy.gender = self.gender;
        copy.requiredAt = [self.requiredAt copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.questionUuid = [self.questionUuid copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.imageUrls = [self.imageUrls copyWithZone:zone];
        copy.tickets = self.tickets;
    }
    
    return copy;
}


@end
