//
//  LMChoosehostViewController.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitTableViewController.h"

@protocol LMhostchooseProtocol <NSObject>

-(void)backhostName:(NSString *)liveRoom andId:(NSString *)userId;

@end
@interface LMChoosehostViewController :FitTableViewController

@property (nonatomic,strong) NSString *keyWord;


@property (nonatomic,retain) NSMutableArray *listData;


@property(nonatomic,assign)id<LMhostchooseProtocol>delegate;

@end
