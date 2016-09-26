//
//  DYloginRequest.h
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"

@interface DYloginRequest : FitBaseRequest

- (id)initWithPhone:(NSString *)phone
            andCode:(NSString *)code
        andPassword:(NSString *)password;

@end
