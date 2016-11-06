//
//  LMWXLoginRequest.h
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMWXLoginRequest : FitBaseRequest

- (id)initWithWechatResult:(NSDictionary *)dic andPassword:(NSString *)password;

@end
