//
//  LMTypeListViewController.h
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitStatefulTableViewController.h"

@protocol LMTypeListProtocol <NSObject>

-(void)backLiveName:(NSString *)liveRoom;

@end

@interface LMTypeListViewController : FitStatefulTableViewController

+ (void)presentInViewController:(UIViewController *)viewController Animated:(BOOL)animated;

@property(nonatomic,assign)id<LMTypeListProtocol>delegate;

@end
