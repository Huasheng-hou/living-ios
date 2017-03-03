//
//  LMVoiceCommentReplyRequest.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceCommentReplyRequest : FitBaseRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid commentUuid:(NSString *)comment_uuid replyContent:(NSString *)reply_content;

@end
