//
//  LMVoiceDeleteReplyRequest.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceDeleteReplyRequest : FitBaseRequest

- (id)initWithReplyUuid:(NSString *)reply_uuid;

@end
