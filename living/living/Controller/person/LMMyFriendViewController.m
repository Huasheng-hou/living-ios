//
//  LMMyFriendViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMyFriendViewController.h"
#import "LMFriendListRequest.h"
#import "LMFriendCell.h"

@interface LMMyFriendViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSMutableArray *listArray;
    UIView *homeImage;
}
@property (nonatomic,retain)UITableView *tableView;


@end

@implementation LMMyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getFriendListRequest];
    
}

-(void)createUI
{
    self.title = @"我的好友";
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    listArray = [NSMutableArray new];

}

-(void)getFriendListRequest
{
    LMFriendListRequest *request = [[LMFriendListRequest alloc] initWithPageIndex:1 andPageSize:20];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getFriendListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取通知列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)getFriendListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    NSLog(@"%@",bodyDic);
    if (!bodyDic) {
        [self textStateHUD:@"获取好友列表失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            listArray = [bodyDic objectForKey:@"lsit"];
            if (listArray.count==0) {
                homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, kScreenHeight/2-160, 300, 100)];
                
                UIImageView *homeImg = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 90, 75)];
                homeImg.image = [UIImage imageNamed:@"NO-friend"];
                [homeImage addSubview:homeImg];
                UILabel *imageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 300, 60)];
                imageLb.numberOfLines = 0;
                imageLb.text = @"手牵手，一起走，如此优秀可爱的你\n怎么可以这么孤单呢";
                imageLb.textColor = TEXT_COLOR_LEVEL_3;
                imageLb.font = TEXT_FONT_LEVEL_2;
                imageLb.textAlignment = NSTextAlignmentCenter;
                [homeImage addSubview:imageLb];
                
                [_tableView addSubview:homeImage];
            }
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];

        }
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    LMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LMFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    return cell;
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
