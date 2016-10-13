//
//  LMRegisterRequest.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMRegisterRequest : FitBaseRequest
- (id)initWithNickname:(NSString *)nickname
             andGender:(NSString *)gender
             andAvatar:(NSString *)avatar
           andBirtyday:(NSString *)birthday
           andProvince:(NSString *)province
               andCity:(NSString *)city;

@end
