//
//  FirUploadEventFileRequest.h
//  firefly
//
//  Created by JamHonyZ on 16/1/29.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"

@interface FirUploadEventFileRequest : FitBaseRequest

- (instancetype)initWithFileUUID:(NSString *)fileUUID andEventUUID:(NSString *)eventUUID;

@end
