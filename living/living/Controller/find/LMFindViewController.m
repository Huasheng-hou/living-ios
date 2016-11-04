//
//  LMFindViewController.m
//  dirty
//
//  Created by Ding on 16/9/22.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "LMFindViewController.h"
#import "LMFindCell.h"
#import "WJLoopView.h"
#import "LMWebViewController.h"

@interface LMFindViewController ()<UITableViewDelegate,
UITableViewDataSource,
WJLoopViewDelegate
>
{
    UITableView *_tableView;
    NSArray *imagearray;
    NSArray *titlearray;
    NSArray *contentarray;
    NSArray *imageURLs;
    
}

@end

@implementation LMFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    
    imagearray = @[@"12.jpg",@"13.jpg",@"14.jpg"];
    titlearray = @[@"腰果 财富现金流养成记",@"腰果 语言课堂",@"腰果 商城"];
    contentarray = @[@"现金流：游戏升级打怪，财商创业思维和个人成长也需要升级，现实版的自我成长养成记，想一起来么。",@"语音课堂：想听倾心已久讲师的经典课程，邀约腰果生活，随时随地用声音传递生活。",@"商场：在商城找到帮助品质生活体验的优质商品，不用到处淘而耗费时间啦."];

    imageURLs =@[@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/9f8d96ce455e3ce4c168a1a087cfab44.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/dba0b35d39f1513507f0bbac17e90d21.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/c643d748dc1a7c128a8d052def67a92e.jpg",@"http://yaoguo.oss-cn-hangzhou.aliyuncs.com/24437ada0e0fec458a4d4b7bcd6d3b03.jpg"];
    
    
    
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
    
    WJLoopView *loopView = [[WJLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5) delegate:self imageURLs:imageURLs placeholderImage:nil timeInterval:2 currentPageIndicatorITintColor:nil pageIndicatorTintColor:nil];
    loopView.location = WJPageControlAlignmentRight;
    [headView addSubview:loopView];
    return headView;
}

#pragma mark scrollview代理函数
- (void)WJLoopView:(WJLoopView *)LoopView didClickImageIndex:(NSInteger)index
{
    NSLog(@"************");
    
    if (index==3) {
        return;
    }
    NSArray *arr = @[@"『腰·美』",@"『腰·吃』",@"『腰·活』",@"『腰·乐』"];
    NSArray *urlRrray = @[@"http://120.27.147.167/living-web/apparticle/daoshi3",@"http://120.27.147.167/living-web/apparticle/daoshi2",@"http://120.27.147.167/living-web/apparticle/daoshi1"];
    
    
    
    LMWebViewController *webView = [[LMWebViewController alloc] init];
    webView.urlString = urlRrray[index];
    webView.titleString = arr[index];
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
    
    
}
    

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenWidth*3/5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMFindCell *cell = [[LMFindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    [cell setimagearray:imagearray[indexPath.row]];
    [cell settitlearray:titlearray[indexPath.row]];
    [cell setcontentarray:contentarray[indexPath.row]];
    
//    cell.imageView.image =[UIImage imageNamed:imagearray[indexPath.row]];
//    cell.titleLabel.text = titlearray[indexPath.row];
//    cell.contentLabel.text = contentarray[indexPath.row];
    

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
