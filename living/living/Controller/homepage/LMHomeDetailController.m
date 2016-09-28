//
//  LMHomeDetailController.m
//  living
//
//  Created by Ding on 16/9/27.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHomeDetailController.h"
#import "LMCommentCell.h"

@interface LMHomeDetailController ()<UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    
}


@end

@implementation LMHomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    [self getHomeDataRequest];
    
}

-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
    
    
}



-(void)getHomeDataRequest
{
    
    
}

-(void)getHomeDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        NSLog(@"%@",bodyDic);
        
        
        
        [_tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return [LMCommentCell cellHigth:@"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定"];
    }
    return 100;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        commentLabel.textColor = [UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        commentLabel.text = @"评论列表";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =[UIColor colorWithRed:0/255.0 green:130/255.0 blue:230.0/255.0 alpha:1.0];
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
    
        headView.backgroundColor = [UIColor clearColor];
        return headView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.font = TEXT_FONT_LEVEL_1;
            titleLabel.numberOfLines=0;
            titleLabel.text = @"首页详情这是标题标题首页详情这是标题标题首页详情这是标题标题首页详情这是标题标题";
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            CGFloat conHigh = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(15, 15, kScreenWidth-30, conHigh);
            [cell.contentView addSubview:titleLabel];
            
            UILabel *nameLabel = [UILabel new];
            nameLabel.font = TEXT_FONT_LEVEL_3;
            nameLabel.text = @"作者名";
            [nameLabel sizeToFit];
            nameLabel.frame = CGRectMake(15, conHigh+20, nameLabel.bounds.size.width, nameLabel.bounds.size.height);
            [cell.contentView addSubview:nameLabel];
            
            
            
            
        }
        
        return cell;
 
    }
    if (indexPath.section==1) {
        static NSString *cellId = @"cellId";
        LMCommentCell *cell = [[LMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSelectionStyleDefault;

        
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        [cell setTitleString:@"果然我问问我吩咐我跟我玩嗡嗡图文无关的身份和她和热稳定"];
        return cell;
    }
    
    
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
