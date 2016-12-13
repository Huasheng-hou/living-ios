//
//  LMChoosehostViewController.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChoosehostViewController.h"
#import "LMHostChoiceRequest.h"

@interface LMChoosehostViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UISearchBar *_searchBar;
    UITableView    * table;
    NSDictionary *hostDic;
}

@end

@implementation LMChoosehostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择主持";
    [self createSearchBar];
}

- (void)createSearchBar
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入ID搜索";
    [self.view addSubview:_searchBar];
    
    hostDic = [[NSMutableDictionary alloc]init];
    
    table= [[UITableView alloc]initWithFrame:CGRectMake(0, kNaviHeight+kStatuBarHeight+10+50,kScreenWidth, kScreenHeight-(kNaviHeight+kStatuBarHeight+10+64))
                                          style:UITableViewStylePlain];
    
    [table setBackgroundColor:[UIColor colorWithRed:245/255.0f
                                              green:245/255.0f
                                               blue:245/255.0f
                                              alpha:1.0f]];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    
    [table setShowsVerticalScrollIndicator:NO];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (void)getdatarequest
{
    LMHostChoiceRequest *request = [[LMHostChoiceRequest alloc] initWithUserId:_keyWord];
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
    hostDic = [NSMutableDictionary new];
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (bodyDict && [bodyDict objectForKey:@"result"]) {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            hostDic = [bodyDict objectForKey:@"host"];
            
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
    
    return 1 ;


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        
    }

    cell.textLabel.text = [hostDic objectForKey:@"nickname"];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        
            
        [self.delegate backhostName:hostDic[@"nickname"] andId:hostDic[@"userId"]];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    
}



@end
