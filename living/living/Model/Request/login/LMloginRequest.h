//
//  LMloginRequest.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMloginRequest : FitBaseRequest

- (id)initWithPhone:(NSString *)phone
        andPassword:(NSString *)password
         andCaptcha:(NSString *)captcha;

@end
