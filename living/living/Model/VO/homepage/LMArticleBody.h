//
//  ArticleBody.h
//
//  Created by   on 16/10/12
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMArticleBody : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double articlePraiseNum;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleContent;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, assign) double commentNum;
@property (nonatomic, assign) double fakaid;
@property (nonatomic, strong) NSString *articleName;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *articleUuid;
@property (nonatomic, strong) NSArray *articleImgs;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
