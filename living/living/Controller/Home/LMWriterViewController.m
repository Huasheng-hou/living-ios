//
//  LMWriterViewController.m
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWriterViewController.h"
#import "LMhomePageCell.h"
#import "LMWriterDataRequest.h"
#import "LMActicleVO.h"
#import "MJRefresh.h"
#import "LMHomeDetailController.h"
#import "ImageHelpTool.h"

@interface LMWriterViewController ()<UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    NSMutableArray *listArray;
    NSMutableDictionary *infoDic;
    BOOL ifRefresh;
    int total;
    UIImageView *headerView;
}


@end

@implementation LMWriterViewController

-(id)initWithUUid:(NSString *)writerUUid
{
    self = [super init];
    if (self) {
        _writerUUid = writerUUid;
    }
    return self;
}

- (NSMutableArray *)taskArr
{
    if (!listArray) {
        listArray = [NSMutableArray array];
    }
    return listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TA的空间";
    [self creatUI];
    ifRefresh = YES;
    
}
-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setupRefresh];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"屏蔽"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(reportAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)reportAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否屏蔽该该作者"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self textStateHUD:@"您已经屏蔽了该作者"];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据";
    _tableView.footerRefreshingText = @"正在帮你加载...";
}

- (void)headerRereshing
{
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [_tableView headerEndRefreshing];
        ifRefresh = YES;
        self.current=1;
        [self getWriterDataList:self.current];
        ifRefresh=YES;
        
    });
}



- (void)footerRereshing
{
    
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.current = self.current+1;
        
        ifRefresh=NO;
        
        if (total<self.current) {
            [self textStateHUD:@"没有更多文章"];
        }else{
            [self getWriterDataList:self.current];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

-(void)getWriterDataList:(int)page
{
    LMWriterDataRequest *request = [[LMWriterDataRequest alloc] initWithPageIndex:page andPageSize:20 authorUuid:_writerUUid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getauthorDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)getauthorDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    total = [[bodyDic objectForKey:@"total"] intValue];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        infoDic = [bodyDic objectForKey:@"map"];
        
        if (ifRefresh) {
            
            ifRefresh=NO;
            listArray=[NSMutableArray arrayWithCapacity:0];
            
            NSArray *array = bodyDic[@"list"];
            for(int i=0;i<[array count];i++){
                
                LMActicleVO *list=[[LMActicleVO alloc]initWithDictionary:array[i]];
                if (![listArray containsObject:list]) {
                    [listArray addObject:list];
                }
            }
            
        }
        else{
            NSArray *array = bodyDic[@"list"];
            
            for(int i=0;i<[array count];i++){
                LMActicleVO *list=[[LMActicleVO alloc]initWithDictionary:array[i]];
                if (![listArray containsObject:list]) {
                    [listArray addObject:list];
                }
            }
        }
        
        [_tableView reloadData];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 20;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 40;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
        headLabel.text = @"全部文章";
        headLabel.font = TEXT_FONT_LEVEL_1;
        headLabel.textColor = LIVING_COLOR;
        [headView addSubview:headLabel];
        
        return headView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //头像
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        headerView.layer.cornerRadius = 5;
        headerView.backgroundColor = BG_GRAY_COLOR;
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.clipsToBounds = YES;
        headerView.userInteractionEnabled = YES;
        
        if (![infoDic[@"avatar"] isEqual:@""]&&infoDic[@"avatar"]) {
            [headerView setImageWithURL:[NSURL URLWithString:infoDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
            UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
            [headerView addGestureRecognizer:tapClick];
            
        }
        [cell.contentView addSubview:headerView];
        
        //nick
        UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(100,20,30,30)];
        nicklabel.font = TEXT_FONT_LEVEL_1;
        nicklabel.textColor = TEXT_COLOR_LEVEL_2;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
        NSString *str= @"";
        if (infoDic[@"nickename"]&& ![infoDic[@"nickename"] isEqual:@""]) {
            str =infoDic[@"nickename"];
        }else{
            str = @"匿名作者";
        }
        
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        [nicklabel setFrame:CGRectMake(100, 20, textSize.width, 30)];
        nicklabel.text = str;
        [cell.contentView addSubview:nicklabel];
        
        //gender icon
        UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 27, 16, 16)];
        if (infoDic[@"gender"]) {
            if ([infoDic[@"gender"] isEqual:@"男"]) {
                [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
            }else{
                [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
            }
        }
        [cell.contentView addSubview:genderImage];
        
        //地址
        UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(100, 52, 80, 20)];
        
        if (infoDic[@"address"]&&![infoDic[@"address"] isEqual:@""]) {
            question.text = [NSString stringWithFormat:@"地址：%@", infoDic[@"address"]];
        }else{
            question.text = @"地址：--";
        }
        
        
        question.font = TEXT_FONT_LEVEL_2;
        question.textColor = TEXT_COLOR_LEVEL_3;
        [question sizeToFit];
        question.frame = CGRectMake(100, 50, question.bounds.size.width, 20);
        [cell.contentView addSubview:question];
        
        return cell;
        
    }
    
    
    if (indexPath.section==1) {
        static NSString *cellIdd = @"cellIdd";
        LMhomePageCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdd];
        if (!cell) {
            cell = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdd];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LMActicleVO *list = [listArray objectAtIndex:indexPath.row];
        [cell setValue:list];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        LMActicleVO *list = [listArray objectAtIndex:indexPath.row];
        LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
        
        detailVC.artcleuuid = list.articleUuid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)headClick
{
    
    if (headerView.image) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [ImageHelpTool showImage:headerView];
    }else{
        return;
    }
}

@end
