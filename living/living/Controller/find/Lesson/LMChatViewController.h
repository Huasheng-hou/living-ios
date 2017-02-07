//
//  MainViewController.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "FitStatefulTableViewController.h"
#import "LMWobsocket.h"

typedef enum {
    kFitMessageTableStateOnLoading    =   1,
    kFitMessageTableStateIdle         =   2,
} FitMessageTableState;

@interface LMChatViewController : FitTableViewController <STOMPClientDelegate>

@property (nonatomic,strong)    NSString        *voiceUuid;
@property (nonatomic,strong)    NSString        *sign;
@property (nonatomic,strong)    NSString        *roles;
@property (nonatomic,retain)    NSMutableArray  *listData;

@property (assign, nonatomic)   NSInteger               total;
@property (nonatomic)           int                     max;
@property (assign, nonatomic)   FitMessageTableState    state;

@end
