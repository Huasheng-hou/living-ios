//
//  FirChangeUserInfoRequest.h
//  firefly
//
//  Created by JamHonyZ on 16/1/20.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"

@interface FirChangeUserInfoRequest : FitBaseRequest

- (instancetype)initWithAvatar:(NSString *)avatar andNickname:(NSString *)nickname andName:(NSString *)name andGender:(NSString *)gender andAddress:(NSString *)address andFirm:(NSString *)firm andContact:(NSString *)contact;

@end
