//
//  LMActivityDetailController.m
//  living
//
//  Created by Ding on 16/9/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMActivityDetailController.h"
#import "LMOrderViewController.h"
#import "LMEventMsgCell.h"
#import "LMLeavemessagecell.h"
#import "UIView+frame.h"
#import "LMActivityheadCell.h"
#import "LMActivityMsgCell.h"
#import "LMMapViewCell.h"

#import "LMActivityDetailRequest.h"
#import "LMEventDetailEventBody.h"
#import "LMEventDetailEventProjectsBody.h"
#import "LMEventDetailLeavingMessages.h"
#import "LMEventJoinRequest.h"
#import "LMEventLivingMsgRequest.h"
#import "LMEventpraiseRequest.h"
#import "LMEventCommitReplyRequset.h"
#import "LMEventReplys.h"
#import "APChooseView.h"
#import "UIImageView+WebCache.h"

#import "LMBesureOrderViewController.h"

@interface LMActivityDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
UITextViewDelegate,
LMActivityheadCellDelegate,
LMLeavemessagecellDelegate,
UIAlertViewDelegate
>
{
//    UITableView *_tableView;
    UILabel  *tipLabel;
    UIButton *zanButton;
    UITextView *suggestTF;
    UIView *headerView;
    NSMutableArray *msgArray;
    NSMutableArray *eventArray;
    LMEventDetailEventBody *eventDic;
    UIView *commentsView;
    UITextView *commentText;
    UIView *backView;
    NSString *commitUUid;
    NSMutableDictionary *orderDic;
    
    NSString *latitude;
    NSString *longitude;
    
    
}


@end

@implementation LMActivityDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self scrollViewDidScroll:self.tableView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self creatUI];
    [self getEventListDataRequest];
    msgArray = [NSMutableArray new];
    eventArray = [NSMutableArray new];
    
    //加入订单
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(joindataRequest:)
                                                name:@"purchase"
                                              object:nil];
    
}


-(void)creatUI
{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.contentInset     = UIEdgeInsetsMake(0, 0, 12, 0);
    headerView = [UIView new];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    headerView.hidden=YES;
    [self.view addSubview:headerView];
    
    
}
-(void)creatHeaderView
{
    
    //活动人头像
    UIImageView *headV = [UIImageView new];
    [headV sd_setImageWithURL:[NSURL URLWithString:eventDic.publishAvatar]];
    headV.layer.cornerRadius = 5.f;
    [headV sizeToFit];
    headV.frame = CGRectMake(15, 30, 40, 40);
    [headerView addSubview:headV];
    
    //活动人名
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = [NSString stringWithFormat:@"发布者：%@",eventDic.publishName];
    nameLabel.font = [UIFont systemFontOfSize:13.f];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel sizeToFit];
       nameLabel.frame = CGRectMake(60, 30, nameLabel.bounds.size.width, nameLabel.bounds.size.height);
    [headerView addSubview:nameLabel];
    
    //费用
    UILabel *countLabel = [UILabel new];
    countLabel.text = [NSString stringWithFormat:@"人均费用 ￥%@",eventDic.perCost];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:13.f];
    [countLabel sizeToFit];
    countLabel.frame = CGRectMake(60, 35+nameLabel.bounds.size.height, countLabel.bounds.size.width, countLabel.bounds.size.height);
    [headerView addSubview:countLabel];
    
    NSString *string = [NSString stringWithFormat:@"%.0f",eventDic.status];
    

    
    
    
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //        _topBtn.backgroundColor = _COLOR_N(red);
    if ([string isEqual:@"1"]) {
      [joinButton setTitle:@"报名" forState:UIControlStateNormal];
    }
    if ([string isEqual:@"2"]) {
        [joinButton setTitle:@"人满" forState:UIControlStateNormal];
        joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"3"]) {
        [joinButton setTitle:@"开始" forState:UIControlStateNormal];
        joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"4"]) {
        [joinButton setTitle:@"已完结" forState:UIControlStateNormal];
        joinButton.userInteractionEnabled = NO;
    }
    if ([string isEqual:@"5"]) {
        [joinButton setTitle:@"删除" forState:UIControlStateNormal];
    }

    
    [joinButton setTintColor:[UIColor whiteColor]];
    joinButton.showsTouchWhenHighlighted = YES;
    joinButton.frame = CGRectMake(kScreenWidth-70, 25, 60.f, 50.f);
    [joinButton addTarget:self action:@selector(cellWillApply:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:joinButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [line sizeToFit];
    line.frame = CGRectMake(kScreenWidth-71, 35, 1, 30);
    [headerView addSubview:line];
    
    
    
}


-(void)getEventListDataRequest
{
    [self initStateHud];
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMActivityDetailRequest *request = [[LMActivityDetailRequest alloc] initWithEvent_uuid:_eventUuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventListDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"获取列表失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}

-(void)getEventListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSLog(@"==========================活动详情:bodyDic:%@",bodyDic);
    
    if (!bodyDic) {
        [self textStateHUD:@" 获取详情数据失败"];
        return;
    }
    
    
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self hideStateHud];
        
        
      latitude= bodyDic[@"event_body"][@"latitude"];
        
        longitude=bodyDic[@"event_body"][@"longitude"];
        
        NSMutableArray *array = bodyDic[@"leaving_messages"];
        if (msgArray.count>0) {
           [msgArray removeAllObjects];
        }
        
        for (int i=0; i<array.count; i++) {
//            LMEventDetailLeavingMessages *list=[[LMEventDetailLeavingMessages alloc]initWithDictionary:array[i]];

                NSDictionary *dic = array[i][@"message"];
                [msgArray addObject:dic];
        }
        for (int i =0; i<array.count; i++) {
            NSMutableArray *replyarr = array[i][@"replys"];
            for (int j = 0; j<replyarr.count; j++) {
                NSDictionary *dic = replyarr[j];
                [msgArray addObject:dic];
            }
        }
        
        NSMutableArray *eveArray = bodyDic[@"event_projects_body"];
        [eventArray removeAllObjects];
        for (int i=0; i<eveArray.count; i++) {
            LMEventDetailEventProjectsBody *Projectslist=[[LMEventDetailEventProjectsBody alloc]initWithDictionary:eveArray[i]];
            if (![eventArray containsObject:Projectslist]) {
                [eventArray addObject:Projectslist];
            }
        }
        
        eventDic =[[LMEventDetailEventBody alloc] initWithDictionary:bodyDic[@"event_body"]];
        
        orderDic = [bodyDic objectForKey:@"event_body"];
        
    
        [self creatHeaderView];
        
        [self.tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 230;
    }
    if (indexPath.section==1) {
        return 190+200;
    }
    
    if (indexPath.section==2) {
         LMEventDetailEventProjectsBody *list = eventArray[indexPath.row];
            NSString *string = list.projectTitle;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            
            NSString *string2 = list.projectDsp;
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
            CGFloat conHigh2 = [string2 boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
        
        if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
            return 60+conHigh+conHigh2;
        }else{
            return 270+conHigh+conHigh2;
        }
            
            
        
        
    }
    if (indexPath.section==3) {

        
        if (msgArray.count>0) {
            
            if (msgArray[indexPath.row][@"comment_content"]){
                LMEventDetailLeavingMessages *list = [[LMEventDetailLeavingMessages alloc] initWithDictionary:msgArray[indexPath.row]];
                return [LMLeavemessagecell cellHigth:list.commentContent];
                
            }

            if (msgArray[indexPath.row][@"replyContent"]){
                LMEventReplys *list = [[LMEventReplys alloc] initWithDictionary:msgArray[indexPath.row]];
                return [LMLeavemessagecell cellHigth:list.replyContent];
            }
            
            
        }

        
    }
    
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1){
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        
        commentLabel.textColor = TEXT_COLOR_LEVEL_2;
        commentLabel.text = @"生活馆信息";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =LIVING_COLOR;
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        headView.backgroundColor = [UIColor clearColor];
        
        
        return headView;
    }
    
    if (section==2){
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        
        commentLabel.textColor = TEXT_COLOR_LEVEL_2;
        commentLabel.text = @"活动介绍";
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 10, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =LIVING_COLOR;
        [line sizeToFit];
        line.frame =CGRectMake(0, 10+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        headView.backgroundColor = [UIColor clearColor];
        
        
        return headView;
    }


    
    
    if (section==3){
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 155)];
        commentView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:commentView];
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = [UIFont systemFontOfSize:13.f];
        
        commentLabel.textColor = TEXT_COLOR_LEVEL_2;
        commentLabel.text = @"留言列表";
        suggestTF = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 100)];
        suggestTF.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        suggestTF.layer.cornerRadius=5;
        suggestTF.textColor = TEXT_COLOR_LEVEL_3;
        suggestTF.font = TEXT_FONT_LEVEL_3;
        suggestTF.layer.borderColor = LINE_COLOR.CGColor;
        suggestTF.returnKeyType = UIReturnKeyDone;
        suggestTF.layer.borderWidth = 0.5;
        suggestTF.delegate = self;
        [commentView addSubview:suggestTF];
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-50, 20)];
        tipLabel.text = @"给点留言或建议...";
        tipLabel.textColor = TEXT_COLOR_LEVEL_3;
        tipLabel.font = TEXT_FONT_LEVEL_3;
        [suggestTF addSubview:tipLabel];
        
        UIButton *besureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [besureButton setTitle:@"确认" forState:UIControlStateNormal];
        [besureButton setTintColor:LIVING_COLOR];
        besureButton.layer.cornerRadius = 3;
        besureButton.layer.borderWidth = 0.5;
        besureButton.layer.borderColor = LIVING_COLOR.CGColor;
        besureButton.showsTouchWhenHighlighted = YES;
        besureButton.frame = CGRectMake(kScreenWidth-85, 70, 50.f, 25.f);
        [besureButton addTarget:self action:@selector(besureAction:) forControlEvents:UIControlEventTouchUpInside];
        [suggestTF addSubview:besureButton];
        
        
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(15, 120, commentLabel.bounds.size.width, commentLabel.bounds.size.height);
        [commentView addSubview:commentLabel];
        
        
        UIView *line = [UIView new];
        line.backgroundColor =LIVING_COLOR;
        [line sizeToFit];
        line.frame =CGRectMake(0, 120+1, 3.f, commentLabel.bounds.size.height-2);
        [commentView addSubview:line];
        
        headView.backgroundColor = [UIColor clearColor];
        
        
        return headView;
    }
    return nil;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0.01;
    }
    
    if (section==1) {
        return 40;
    }
    if (section==2) {
        return 40;
    }
    if (section==3) {
        return 150;
    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return eventArray.count;
    }
    if (section==3) {
        return msgArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        static NSString *cellId = @"cellIdd";
        
        LMActivityheadCell *cell = [[LMActivityheadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setValue:eventDic];
        
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        cell.delegate = self;
        return cell;
        }
    
    //生活馆信息   //地图展示
    if (indexPath.section==1) {
        static NSString *cellId = @"cellIddd";
        
        LMActivityMsgCell *cell = [[LMActivityMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setValue:eventDic andLatitude:latitude andLongtitude:longitude];
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        UITapGestureRecognizer   *hintLblTap     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTelephone)];
        [cell.numberLabel addGestureRecognizer:hintLblTap];
        
        return cell;
    }
    
    
    
        if (indexPath.section==2) {
            static NSString *cellId = @"cellId";
            
            LMEventMsgCell *cell = [[LMEventMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LMEventDetailEventProjectsBody *list = eventArray[indexPath.row];
            
            
           if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
                cell.index = 1;
            }
            
            [cell setValue:list];
            
            NSLog(@"%@",list.projectImgs);
            [cell setXScale:self.xScale yScale:self.yScaleNoTab];

            return cell;
        }
        
        
    if (indexPath.section==3) {
        static NSString *cellId = @"cellId";
        
        LMLeavemessagecell *cell = [[LMLeavemessagecell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
//        LMEventDetailLeavingMessages *msgData = msgArray[indexPath.row];
        [cell setValue:msgArray andIndex:indexPath.row];
        cell.tag = indexPath.row;
        
//        cell.commentUUid = msgData.commentUuid;
        cell.delegate = self;
        
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        return cell;
    }
    
    return nil;
    
}

-(void)callTelephone
{
    if (!eventDic.contactPhone) {
        return;
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打：%@",eventDic.contactPhone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert=nil;
    
   }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
         NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",eventDic.contactPhone];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
}

#pragma mark - LMLeavemessagecell delegate -点赞
- (void)cellWillComment:(LMLeavemessagecell *)cell
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
  
    LMEventpraiseRequest *request = [[LMEventpraiseRequest alloc] initWithEvent_uuid:_eventUuid CommentUUid:cell.commentUUid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSDictionary *bodyDic = [VOUtil parseBody:resp];
                                                   if (!bodyDic) {
                                                       [self textStateHUD:@"点赞失败"];
                                                   }else{
                                                       
                                                       
                                                       if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
                                                           [self textStateHUD:@"点赞成功"];
                                                           [self getEventListDataRequest];
                                                           NSArray *indexPaths = @[[NSIndexPath indexPathForRow:cell.tag inSection:3]];
                                                           [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                                                           
                                                           
                                                       }else{
                                                           NSString *str = [bodyDic objectForKey:@"description"];
                                                           [self textStateHUD:str];
                                                       }
                                                   }

                                               });
        
                                              
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"点赞失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
    
}
-(void)getEventpraiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"点赞失败"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"点赞成功"];
            
            
        }else{
            NSString *str = [bodyDic objectForKey:@"description"];
            [self textStateHUD:str];
        }
    }
}


//回复
-(void)cellWillReply:(LMLeavemessagecell *)cell
{
    NSLog(@"**********回复");
    
    commitUUid = cell.commentUUid;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self showCommentText];
    [UIView commitAnimations];
 
}
- (void)showCommentText {
    [self createCommentsView];
    [commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}
- (void)createCommentsView {
    if (!commentsView) {
        commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kScreenHeight - 180 - 180.0, kScreenWidth, 180.0)];
        commentsView.backgroundColor = [UIColor whiteColor];
        commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 20.0)];
        commentText.layer.borderWidth   = 0.5;
        commentText.layer.borderColor   = LINE_COLOR.CGColor;
        commentText.layer.cornerRadius  = 5.0;
        commentText.layer.masksToBounds = YES;
        commentText.inputAccessoryView  = commentsView;
        commentText.backgroundColor     = [UIColor whiteColor];
        commentText.returnKeyType       = UIReturnKeyDone;
        commentText.delegate	        = self;
        commentText.font		        = [UIFont systemFontOfSize:15.0];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureButton.frame = CGRectMake(kScreenWidth-90, 160-60, 72, 24);
        sureButton.layer.cornerRadius = 5;
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        sureButton.backgroundColor = BLUE_COLOR;
        sureButton.tintColor = [UIColor whiteColor];
        [sureButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [commentText addSubview:sureButton];
        [commentsView addSubview:commentText];
    }
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来
}

-(void)sendComment
{
    NSLog(@"************");
    if ([commentText.text isEqualToString:@""]) {
        [self textStateHUD:@"回答内容不能为空"];
        return;
    }
    [self commitDataRequest];

    
    [commentText resignFirstResponder];
}

-(void)commitDataRequest
{
    
    NSLog(@"%@",_eventUuid);
    NSLog(@"%@",commitUUid);
    NSLog(@"%@",commentText.text);
    
    LMEventCommitReplyRequset *request = [[LMEventCommitReplyRequset alloc] initWithEvent_uuid:_eventUuid CommentUUid:commitUUid Reply_content:commentText.text];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventcommitResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"回复失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

}
-(void)getEventcommitResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"回复失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"回复成功"];
        [self getEventListDataRequest];
         [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
    
}



#pragma mark - LMActivityheadCell delegate -活动报名
- (void)cellWillApply:(LMActivityheadCell *)cell
{
    
    
    APChooseView *infoView = [[APChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    infoView.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 30, 150, 30)];
    infoView.titleLabel.text = @"￥:0";
    infoView.titleLabel.textColor = LIVING_REDCOLOR;
    infoView.titleLabel.font = [UIFont systemFontOfSize:17];
    [infoView.bottomView addSubview:infoView.titleLabel];
    
    infoView.title2 = [UILabel new];
    infoView.title2.text = @"￥:0";
    infoView.title2.textColor = TEXT_COLOR_LEVEL_2;
    infoView.title2.font = [UIFont systemFontOfSize:15];

    [infoView.bottomView addSubview:infoView.title2];
    
    
    

    if ([[FitUserManager sharedUserManager].vipString isEqual:@"menber"]) {
        [infoView.titleLabel sizeToFit];
        infoView.titleLabel.text = [NSString stringWithFormat:@"￥:%@", eventDic.discount];
        infoView.titleLabel.frame = CGRectMake(150, 30, infoView.titleLabel.bounds.size.width, 30);
        [infoView.title2 sizeToFit];
        infoView.title2.text = [NSString stringWithFormat:@"￥:%@", eventDic.perCost];
        infoView.title2.frame = CGRectMake(160+infoView.titleLabel.bounds.size.width, 30, infoView.title2.bounds.size.width, 30);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(160+infoView.titleLabel.bounds.size.width, 45, infoView.title2.bounds.size.width, 0.5)];
        
        [infoView.bottomView addSubview:line];
        
    }else{
       infoView.titleLabel.text = [NSString stringWithFormat:@"￥:%@", eventDic.perCost];
    }
    
    
    infoView.inventory.text = [NSString stringWithFormat:@"活动人数 %.0f/%.0f人",eventDic.totalNumber,eventDic.totalNum];
    
    [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
    
    infoView.orderInfo = orderDic;

    [self.view addSubview:infoView];
    
    UIView *view = [infoView viewWithTag:1000];
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, kScreenHeight-465,self.view.bounds.size.width, 465);
    }];
    
    
    

}

-(void)joindataRequest:(NSNotification *)notice
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"暂不能报名"];
        return;
    }
    NSMutableDictionary *orderNum=notice.object;
    NSLog(@"%@",orderNum[@"num"]);
    
    NSString *num = [NSString stringWithFormat:@"%@",orderNum[@"num"]];
    
    LMEventJoinRequest *request = [[LMEventJoinRequest alloc] initWithEvent_uuid:_eventUuid order_nums:num];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventjoinDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"报名参加活动失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    

}


-(void)getEventjoinDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    NSLog(@"%@",bodyDic);
    if (!bodyDic) {
        [self textStateHUD:@"报名失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        [self textStateHUD:@"报名活动成功"];
        NSString *orderID = [bodyDic objectForKey:@"order_uuid"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LMBesureOrderViewController *OrderVC = [[LMBesureOrderViewController alloc] init];
//            [OrderVC setHidesBottomBarWhenPushed:YES];
            OrderVC.orderUUid = orderID;
            OrderVC.dict = orderDic;
            [self.navigationController pushViewController:OrderVC animated:YES];
        });

        
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}



#pragma mark UITextFieldDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length==0) {
        tipLabel.hidden=NO;
    }else{
        tipLabel.hidden=YES;
    }
}

//修改textView return键

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView  resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 230-64) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        self.navigationController.navigationBar.hidden=YES;
        
        headerView.hidden=NO;
        
        
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        
    }else{
        self.navigationController.navigationBar.hidden=NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        headerView.hidden=YES;
    }
    

    
}

#pragma mark  --活动留言或评论

-(void)besureAction:(id)sender
{
    
    [self.view endEditing:YES];
    
    if (suggestTF.text.length<=0) {
        [self textStateHUD:@"请输入内容"];
        return;
    }
    NSLog(@"*******************确认");
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMEventLivingMsgRequest *request = [[LMEventLivingMsgRequest alloc] initWithEvent_uuid:_eventUuid Commentcontent:suggestTF.text];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventLivingmsgDataResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"评论或建议失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];

    
    
}

-(void)getEventLivingmsgDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"留言失败"];
        return;
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"留言成功"];
            
            [self getEventListDataRequest];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                tipLabel.hidden=NO;
                NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:0 inSection:3];
                [[self tableView] scrollToRowAtIndexPath:indexPaths
                                        atScrollPosition:UITableViewScrollPositionTop animated:YES];;
            });
            
            


        }else{
            NSString *str = [bodyDic objectForKey:@"description"];
            [self textStateHUD:str];
        }
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:commentText]) {
        [self commitDataRequest];
    }
    
    
    [self resignCurrentFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollEditingRectToVisible:textView.frame EditingView:textView];
}

- (void)scrollEditingRectToVisible:(CGRect)rect EditingView:(UIView *)view
{
    CGFloat     keyboardHeight  = 280;
    
    if (view && view.superview) {
        rect    = [self.tableView convertRect:rect fromView:view.superview];
    }
    
    if (rect.origin.y < kScreenHeight - keyboardHeight - rect.size.height - 64) {
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - (kScreenHeight - keyboardHeight - rect.size.height)) animated:YES];
}

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
