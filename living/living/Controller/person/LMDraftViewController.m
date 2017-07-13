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
- (void)createUI {
    [super createUI];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.navigationItem.title = @"草稿箱";
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //数据库查询
    _db = [DataBase sharedDataBase];
    NSArray *array = [_db queryFromDraft];
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
            
        } else if ([dataDic[@"type"] isEqualToString:@"review"]) {
            
        } else if ([dataDic[@"type"] isEqualToString:@"activity"]) {
            
        } else if ([dataDic[@"type"] isEqualToString:@"event"]) {
            
        } else if ([dataDic[@"type"] isEqualToString:@"class"]) {
            
        }
        
        
        
        
        
        
    }
}

#pragma mark - 删除指定草稿
- (void)deleteItemWithTag:(NSInteger)index {
    NSDictionary *dataDic = _dataSource[index];
    _db = [DataBase sharedDataBase];
    [_db deleteTableWithName:@"article"];
}


#pragma mark - 清空草稿箱


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"草稿箱--内存预警");
}

@end
