//
//  FitTableViewController.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "FitConsts.h"
#import "FitProtocols.h"
#import "FitNotificationNames.h"
#import "VOUtil.h"
#import "HTTPProxy.h"
#import "HeadVO.h"
#import "CheckUtils.h"
#import "FitUserManager.h"
#import "UIView+frame.h"
#import "FitTabbarController.h"
//#import <UMengAnalytics/UMMobClick/MobClick.h>

@interface FitTableViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
MBProgressHUDDelegate
>
{
    MBProgressHUD *stateHud;
}

@property   (retain, nonatomic)     UITableView         *tableView;
@property   (assign, nonatomic)     UITableViewStyle    style;


- (id)initWithStyle:(UITableViewStyle)style;

// * 切换到主线程，并刷新表视图
//
- (void)refreshData;

- (void)createUI;
- (void)popSelf;
- (void)textStateHUD:(NSString *)text;
- (void)initStateHud;
- (void)hideStateHud;
- (void)resignCurrentFirstResponder;

// * 在利用Keyboard、PickerView等组件编辑内容时，将某一区域滚动到可视范围内，防止被编辑控件遮挡
//
- (void)scrollEditingRectToVisible:(CGRect)rect EditingView:(UIView *)view;

@end
