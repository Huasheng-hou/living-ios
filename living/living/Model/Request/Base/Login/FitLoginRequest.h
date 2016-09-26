
//
//  FitLoginRequest.h
//  Baby
//
//  Created by Huasheng on 15/12/26.
//  Copyright © 2015年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"
@interface FitLoginRequest : FitBaseRequest

- (id)initWithPhone:(NSString *)phone
        andPassword:(NSString *)password
         andCaptcha:(NSString *)captcha;

@end
