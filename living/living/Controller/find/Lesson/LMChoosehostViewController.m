//
//  LMChoosehostViewController.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMChoosehostViewController.h"

@interface LMChoosehostViewController ()<UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    NSMutableArray *searchList;
    NSString *keyWord;
}

@end

@implementation LMChoosehostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
}

- (void)createSearchBar
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入关键字检索联系方式";
    [self.view addSubview:_searchBar];
    
    self.tableView   = [[UITableView alloc]initWithFrame:CGRectMake(0, kNaviHeight+kStatuBarHeight+50,kScreenWidth, kScreenHeight-(kNaviHeight+kStatuBarHeight+56+44))
                                                   style:UITableViewStylePlain];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245/255.0f
                                                       green:245/255.0f
                                                        blue:245/255.0f
                                                       alpha:1.0f]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    
    if (searchList!= nil) {
        [searchList removeAllObjects];
    }
    
    //刷新表格
    [self.tableView reloadData];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    keyWord=searchText;
}


- (void)getDataRespond:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (bodyDict && [bodyDict objectForKey:@"result"]) {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            searchList = [bodyDict objectForKey:@"host"];
            [self.tableView reloadData];
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [searchList count];

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
    cell.textLabel.text = @"测试";
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
