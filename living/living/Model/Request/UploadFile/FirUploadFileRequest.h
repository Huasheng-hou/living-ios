//
//  FirUploadFileRequest.h
//  firefly
//
//  Created by JamHonyZ on 16/1/29.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"

@interface FirUploadFileRequest : FitBaseRequest

- (instancetype)initWithTpye:(NSString *)type andFileName:(NSString *)fileName;

@end
