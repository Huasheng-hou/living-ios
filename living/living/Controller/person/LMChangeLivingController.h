//
//  LMChangeLivingController.h
//  living
//
//  Created by Ding on 2016/10/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitTableViewController.h"

@protocol liveNameProtocol <NSObject>

-(void)backLiveName:(NSString *)liveRoom andLiveUuid:(NSString *)live_uuid;

@end

@interface LMChangeLivingController : FitTableViewController

@property(nonatomic,assign)id<liveNameProtocol>delegate;
@end
