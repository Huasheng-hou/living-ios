//
//  LMVoiceChangeTextRequest.h
//  living
//
//  Created by Ding on 2017/1/6.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceChangeTextRequest : FitBaseRequest

-(id)initWithtranscodingUrl:(NSString *)transcodingUrl andcurrentIndex:(int)currentIndex voice_uuid:(NSString *)voice_uuid;

@end
