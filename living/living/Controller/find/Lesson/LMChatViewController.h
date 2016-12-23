//
//  MainViewController.h
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "FitStatefulTableViewController.h"
typedef enum {
    kFitMessageTableStateOnLoading    =   1,
    kFitMessageTableStateIdle         =   2,
} FitMessageTableState;

@interface LMChatViewController : FitStatefulTableViewController

@property (nonatomic,strong)NSString *voiceUuid;
@property (nonatomic,strong)NSString *sign;
@property (nonatomic,strong)NSString *role;

@property (assign, nonatomic)   NSInteger               total;
@property (assign, nonatomic)   FitMessageTableState    state;


@end
