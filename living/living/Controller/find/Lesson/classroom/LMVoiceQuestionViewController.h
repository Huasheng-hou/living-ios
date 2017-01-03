//
//  LMVoiceQuestionViewController.h
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitStatefulTableViewController.h"

@protocol LMquestionchooseProtocol <NSObject>

- (void)backDic:(NSString *)userId content:(NSString *)content questionUuid:(NSString *)questionUuid;

@end

@interface LMVoiceQuestionViewController : FitStatefulTableViewController

@property (nonatomic,strong)NSString *voiceUUid;

@property (nonatomic,strong)NSString *roleIndex;

@property (nonatomic,assign)id<LMquestionchooseProtocol>delegate;

@end
