//
//  LMRewardBlanceRequest.h
//  living
//
//  Created by Ding on 2017/2/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMRewardBlanceRequest : FitBaseRequest

- (id)initWithVoice_uuid:(NSString *)voice_uuid
               user_uuid:(NSString *)user_uuid
            money_reward:(NSString *)money_reward;

@end
