//
//  LMChoosehostViewController.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChoosehostViewController.h"
#import "LMHostChoiceRequest.h"
#import "UIImageView+WebCache.h"
#import "LMFriendCell.h"
#import "LMFriendVO.h"

@interface LMChoosehostViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UISearchBar *_searchBar;
    NSMutableArray *hostArray;
    NSInteger  searchIndex;
}

@end

@implementation LMChoosehostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择主持";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSearchBar];
    searchIndex = 0;
}

- (void)createSearchBar
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"检索昵称或ID";
    _searchBar.searchBarStyle =UISearchBarStyleMinimal;
    [self.view addSubview:_searchBar];
    
    hostArray = [[NSMutableArray alloc]init];
    
    self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, kNaviHeight+kStatuBarHeight+50,kScreenWidth, kScreenHeight-(kNaviHeight+kStatuBarHeight+50))
                                          style:UITableViewStyleGrouped];
    
    [self.tableView setBackgroundColor:BG_GRAY_COLOR];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (void)getdatarequest
{
    LMHostChoiceRequest *request;
    if ([_keyWord intValue]>0) {
        request = [[LMHostChoiceRequest alloc] initWithUserId:_keyWord nickname:nil];
    }else{
        request = [[LMHostChoiceRequest alloc] initWithUserId:nil nickname:_keyWord];
    }
    

    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getDataRespond:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    
    [proxy start];
    
}


- (void)getDataRespond:(NSString *)resp
{
    hostArray = [NSMutableArray new];
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (bodyDict && [bodyDict objectForKey:@"result"]) {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
           NSArray *array = [LMFriendVO LMFriendVOListWithArray: [bodyDict objectForKey:@"host"]];
            [hostArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_keyWord) {
        [self getdatarequest];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _keyWord=searchText;
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.view endEditing:YES];
    _searchBar.text=nil;
    
    [self getdatarequest];
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hostArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LMFriendVO *vo = hostArray[indexPath.row];
    [cell  setData:vo];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMFriendVO *vo = hostArray[indexPath.row];
       
    [self.delegate backhostName:vo.nickname andId:vo.userId];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
