//
//  DYRegisterRequest.h
//  dirty
//
//  Created by Ding on 16/8/25.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"

@interface DYRegisterRequest : FitBaseRequest

- (id)initWithNickname:(NSString *)nickname
           andPassword:(NSString *)password
             andGender:(NSString *)gender
             andAvatar:(NSString *)avatar
              andPhone:(NSString *)phone
           andBirtyday:(NSString *)birthday
           andProvince:(NSString *)province
               andCity:(NSString *)city;


@end
