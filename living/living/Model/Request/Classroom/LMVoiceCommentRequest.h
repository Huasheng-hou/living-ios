//
//  LMVoiceCommentRequest.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceCommentRequest : FitBaseRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid commentContent:(NSString *)comment_content;

@end
