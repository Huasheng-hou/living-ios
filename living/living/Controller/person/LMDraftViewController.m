//
//  LMDraftViewController.m
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMDraftViewController.h"
#import "DraftCell.h"
#import "DataBase.h"
#import "LMPublicArticleController.h"
#import "LMWriteReviewController.h"
#import "LMPublishViewController.h"
#import "LMPublicEventController.h"
#import "LMPulicVoicViewController.h"

@interface LMDraftViewController ()<DraftCellDelegate>

@property (nonatomic, strong) DataBase *db;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *tip;
@end

@implementation LMDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    [self createUI];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //数据库查询
    _db = [DataBase sharedDataBase];
    NSArray *array = [_db queryFromDraft];
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:array];
    if (_dataSource.count > 0) {
        //有数据，刷新列表
        _tip.hidden = YES;
        [self.tableView reloadData];
    } else {
        //没数据，提示信息‘暂无草稿’
        if (!_tip) {
            _tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 40)];
            _tip.text = @"暂无草稿";
            _tip.textColor = TEXT_COLOR_LEVEL_2;
            _tip.font = TEXT_FONT_LEVEL_1;
            _tip.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:_tip];
        } else {
            _tip.hidden = NO;
        }
    }
}
- (void)createUI {
    [super createUI];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.navigationItem.title = @"草稿箱";
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (_dataSource.count > indexPath.row) {
        NSDictionary *dataDic = _dataSource[indexPath.row];
        [cell setData:dataDic];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSource.count > indexPath.row) {
        NSDictionary *dataDic = _dataSource[indexPath.row];
        if ([dataDic[@"type"] isEqualToString:@"article"]) {
            //文章
            LMPublicArticleController *articleVC = [[LMPublicArticleController alloc] init];
            articleVC.hidesBottomBarWhenPushed = YES;
            articleVC.draftDic = dataDic;
            [self.navigationController pushViewController:articleVC animated:YES];
        } else if ([dataDic[@"type"] isEqualToString:@"review"]) {
            //回顾
            LMWriteReviewController *reviewVC = [[LMWriteReviewController alloc] init];
            reviewVC.hidesBottomBarWhenPushed = YES;
            reviewVC.draftDic = dataDic;
            [self.navigationController pushViewController:reviewVC animated:YES];
        } else if ([dataDic[@"type"] isEqualToString:@"activity"]) {
            //活动
            LMPublishViewController *activityVC = [[LMPublishViewController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            activityVC.draftDic = dataDic;
            [self.navigationController pushViewController:activityVC animated:YES];
        } else if ([dataDic[@"type"] isEqualToString:@"event"]) {
            //项目
            LMPublicEventController *eventVC = [[LMPublicEventController alloc] init];
            eventVC.hidesBottomBarWhenPushed = YES;
            eventVC.draftDic = dataDic;
            [self.navigationController pushViewController:eventVC animated:YES];
        } else if ([dataDic[@"type"] isEqualToString:@"class"]) {
            //课程
            LMPulicVoicViewController *classVC = [[LMPulicVoicViewController alloc] init];
            classVC.hidesBottomBarWhenPushed = YES;
            classVC.draftDic = dataDic;
            [self.navigationController pushViewController:classVC animated:YES];
        }
        
        
    }
}

#pragma mark - 删除指定草稿
- (void)deleteItemWithTag:(NSInteger)index {
    NSDictionary *dataDic = _dataSource[index];
    _db = [DataBase sharedDataBase];
    
    BOOL isOK = [_db deleteFromDraftWithID:dataDic[@"id"]];
    if (isOK) {
        [self textStateHUD:@"删除成功"];
        [_dataSource removeObjectAtIndex:index];
        [self.tableView reloadData];
    } else {
        [self textStateHUD:@"删除失败"];
    }
    
    //[_db deleteTableWithName:@"article"];
}


#pragma mark - 清空草稿箱
- (void)clearAll:(UIBarButtonItem *)item {
    _db = [DataBase sharedDataBase];
    
    BOOL isOK = [_db deleteAllDataFromDraft];
    if (isOK) {
        [self textStateHUD:@"清空成功"];
        [_dataSource removeAllObjects];
        [self.tableView reloadData];
    } else {
        [self textStateHUD:@"清空失败"];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"草稿箱--内存预警");
}

@end
