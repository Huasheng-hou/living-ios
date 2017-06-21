//
//  LMEditRemarksController.m
//  living
//
//  Created by hxm on 2017/5/4.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEditRemarksController.h"
#import "FitConsts.h"
#import "LMFriendCell.h"
#import "LMRemarkRequest.h"
@interface LMEditRemarksController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMEditRemarksController
{
    UITableView * _tableView;
    UITextField * _remarksTF;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)createUI{
    
    self.navigationItem.title = @"备注信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = BG_GRAY_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete:)];
    
    
}
#pragma mark - 修改备注请求
- (void)complete:(UIBarButtonItem *)item{
    
    [_remarksTF resignFirstResponder];
    
    if ([_remarksTF.text isEqualToString:@""]) {
        [self textStateHUD:@"请填写备注信息"];
        return;
    }
    if ([_remarksTF.text isEqualToString:_friendVO.remark]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    [self initStateHud];
    LMRemarkRequest * request = [[LMRemarkRequest alloc] initWithFriendUuid:_friendVO.userUuid andRemark:_remarksTF.text];
    [self loadWithRequest:request];
    
}
- (void)requestResponse:(NSString *)resp
{
    NSData * respData = [resp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * respDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * headDic = [respDic objectForKey:@"head"];
    if (!headDic[@"returnCode"] || ![headDic[@"returnCode"] isEqualToString:@"000"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:headDic[@"returnDescription"]];
        });
        return;
    }
    
    NSDictionary * bodyDic = respDic[@"body"];
    if (!bodyDic[@"result"] || ![bodyDic[@"result"] isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textStateHUD:bodyDic[@"description"]];
        });

        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self textStateHUD:@"修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadlist" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    });

    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LMFriendCell * cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editBtn.hidden = YES;
        
        cell.isEdit = YES;
        [cell setData:_friendVO];
        
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remarksCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"备注";
        cell.textLabel.textColor = TEXT_COLOR_LEVEL_3;
        cell.textLabel.font = TEXT_FONT_LEVEL_2;
        
        _remarksTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth-70, 40)];
        _remarksTF.text = _friendVO.remark;
        _remarksTF.placeholder = @"填写备注信息";
        [_remarksTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
        _remarksTF.textColor = TEXT_COLOR_LEVEL_1;
        _remarksTF.font = TEXT_FONT_LEVEL_2;
        [_remarksTF becomeFirstResponder];
        [cell.contentView addSubview:_remarksTF];
        
        return cell;
    }
    return nil;
}


@end
