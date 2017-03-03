//
//  LMNumberMessageRequest.h
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMNumberMessageRequest : FitBaseRequest

-(id)initWithCurrentIndex:(int)currentIndex  andVoiceUuid:(NSString *)voice_uuid;

@end
