//
//  LMPublicVoicProjectRequest.h
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMPublicVoicProjectRequest : FitBaseRequest

-(id)initWithVoice_uuid:(NSString *)voice_uuid
          Project_title:(NSString *)project_title
            Project_dsp:(NSString *)project_dsp
           Project_imgs:(NSString *)project_imgs;

@end
