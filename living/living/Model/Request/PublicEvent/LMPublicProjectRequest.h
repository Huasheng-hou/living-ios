//
//  LMPublicProjectRequest.h
//  living
//
//  Created by Ding on 16/10/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMPublicProjectRequest : FitBaseRequest


-(id)initWithEvent_uuid:(NSString *)event_uuid
          Project_title:(NSString *)project_title
           Project_dsp:(NSString *)project_dsp
              Project_imgs:(NSString *)project_imgs;

@end
