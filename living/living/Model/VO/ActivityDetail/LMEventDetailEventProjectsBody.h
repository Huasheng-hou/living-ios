//
//  LMEventDetailEventProjectsBody.h
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMEventDetailEventProjectsBody : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *projectTitle;
@property (nonatomic, strong) NSString *projectImgs;
@property (nonatomic, strong) NSString *eventProjectUuid;
@property (nonatomic, strong) NSString *projectDsp;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
