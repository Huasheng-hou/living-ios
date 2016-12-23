//
//  LMChangeHostRequest.h
//  living
//
//  Created by Ding on 2016/12/23.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMChangeHostRequest : FitBaseRequest

- (id)initWithUserId:(NSString *)userId nickname:(NSString *)nickname voice_uuid:(NSString *)voice_uuid;

@end
