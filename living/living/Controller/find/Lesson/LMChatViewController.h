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

@interface LMChatViewController : FitStatefulTableViewController <STOMPClientDelegate>

@property (nonatomic,strong)NSString *voiceUuid;
@property (nonatomic,strong)NSString *sign;
@property (nonatomic,strong)NSString *roles;

@property (assign, nonatomic)   NSInteger               total;
@property (assign, nonatomic)   FitMessageTableState    state;

@end
