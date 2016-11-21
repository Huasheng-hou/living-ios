//
//  LMEventDetailViewController.m
//  living
//
//  Created by Ding on 2016/11/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMEventDetailViewController.h"
#import "LMEventMsgCell.h"
#import "LMLeavemessagecell.h"
#import "UIView+frame.h"
#import "LMActivityheadCell.h"
#import "LMActivityMsgCell.h"
#import "LMMapViewCell.h"

#import "LMActivityDetailRequest.h"

#import "LMEventCommentVO.h"
#import "LMEventBodyVO.h"
#import "LMProjectBodyVO.h"

#import "LMEventJoinRequest.h"
#import "LMEventLivingMsgRequest.h"
#import "LMEventpraiseRequest.h"
#import "LMEventCommitReplyRequset.h"
#import "APChooseView.h"
#import "UIImageView+WebCache.h"
#import "LMActivityDeleteRequest.h"

#import "LMBesureOrderViewController.h"
#import "FitNavigationController.h"

#import "LMEventCommentRequest.h"
#import "LMEventReplydeleteRequest.h"
#import "ImageHelpTool.h"

#import "SYPhotoBrowser.h"
#import "LMEventEndRequest.h"
#import "LMEventStartRequest.h"

//地图导航
#import "LMNavMapViewController.h"
static CGRect oldframe;
@interface LMEventDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LMActivityheadCellDelegate,
LMLeavemessagecellDelegate,
LMEventMsgCellDelegate,
LMActivityMsgCellDelegate
>
{
    UILabel  *tipLabel;
    UIButton *zanButton;
    UITextView *suggestTF;
    UIView *headerView;
    NSMutableArray *msgArray;
    NSMutableArray *eventArray;
    LMEventBodyVO *eventDic;
    UIView *commentsView;
    UITextView *commentText;
    UIView *backView;
    NSString *commitUUid;
    NSMutableDictionary *orderDic;
    
    NSString *latitude;
    NSString *longitude;
    
    NSMutableArray *imageArray;
    
    NSString *status;
    UIBarButtonItem *rightItem;
    
    NSString *vipString;
    NSInteger hiddenIndex;
}

@end

@implementation LMEventDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动详情";
    hiddenIndex =2;
    [self creatUI];
    [self getEventListDataRequest];
    
    msgArray = [NSMutableArray new];
    eventArray = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
}

- (void)creatUI
{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 10)
                                                   style:UITableViewStyleGrouped];
    
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.keyboardDismissMode      = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset             = UIEdgeInsetsMake(0, 0, 12, 0);
    
    [self.view addSubview:self.tableView];
    
    headerView = [UIView new];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    headerView.hidden=YES;
    
    [self.view addSubview:headerView];
}

- (void)creatHeaderView
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
    
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [joinButton setTitle:_type forState:UIControlStateNormal];
    joinButton.userInteractionEnabled = NO;
    
    
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

- (void)getEventListDataRequest
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
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)getEventListDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]) {
        
        if ([headDic[@"sign"] isEqual:@"menber"]) {
            vipString = @"vipString";
        }
    }
    
    if (!bodyDic) {
        
        [self textStateHUD:@"获取详情数据失败"];
        return;
    }
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self hideStateHud];
        
        latitude= bodyDic[@"event_body"][@"latitude"];
        
        longitude=bodyDic[@"event_body"][@"longitude"];
        
        NSMutableArray *array = bodyDic[@"leaving_messages"];
        
        msgArray    = [NSMutableArray new];
        eventArray  = [NSMutableArray new];
        imageArray  = [NSMutableArray new];
        
        for (int i = 0; i < array.count; i++) {
            
            LMEventCommentVO *list = [LMEventCommentVO LMEventCommentVOWithDictionary:array[i]];
            [msgArray addObject:list];
        }
        
        NSArray *eveArray =[LMProjectBodyVO LMProjectBodyVOListWithArray:bodyDic[@"event_projects_body"]];
        
        for (LMProjectBodyVO *vo in eveArray) {
            
            [eventArray addObject:vo];
        }
        for (int i = 0; i < eveArray.count; i++) {
            
            LMProjectBodyVO *Projectslist=eveArray[i];
            
            if (Projectslist.projectImgs && [Projectslist.projectImgs isKindOfClass:[NSString class]] && ![Projectslist.projectImgs isEqual:@""]) {
                
                [imageArray addObject: Projectslist.projectImgs];
            }
        }
        
        eventDic =[[LMEventBodyVO alloc] initWithDictionary:bodyDic[@"event_body"]];
        
        orderDic = [bodyDic objectForKey:@"event_body"];
        
        if (eventDic.status==3||eventDic.status==4) {
            status = @"结束";
        }
        if (eventDic.status==1||eventDic.status==2) {
            status = @"开始";
        }
        
        
        if ([eventDic.userUuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
            
            if (eventDic.totalNumber==0) {
                rightItem  = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
            
            if (eventDic.totalNumber>0&&[status isEqual:@"开始"]) {
                rightItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(startActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
                
            }
            
            if (eventDic.totalNumber>0&&[status isEqual:@"结束"]) {
                rightItem = [[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStylePlain target:self action:@selector(endActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
        }
        
        [self creatHeaderView];
        [self.tableView reloadData];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60+kScreenWidth*3/5;
    }
    if (indexPath.section==1) {
        CGFloat _cellHight;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        _cellHight = [eventDic.address boundingRectWithSize:CGSizeMake(kScreenWidth-59, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        return 150+200;
    }
    
    if (indexPath.section==2) {
        LMProjectBodyVO *list = eventArray[indexPath.row];
        NSString *string = list.projectTitle;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        
        NSString *string2 = list.projectDsp;
        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGFloat conHigh2 = [string2 boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes2 context:nil].size.height;
        
        if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
            if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                return 30 + conHigh;
            }else{
                return 50 + conHigh + conHigh2;
            }
            
        } else {
            if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                return list.height*(kScreenWidth-30)/list.width + conHigh+30;
            }else{
                return list.height*(kScreenWidth-30)/list.width + conHigh + conHigh2+50;
            }
            
            
        }
    }
    if (indexPath.section==3) {
        
        
        if (msgArray.count > indexPath.row) {
            
            LMEventCommentVO *list = msgArray[indexPath.row];
            
            if (list && [list isKindOfClass:[LMEventCommentVO class]]) {
                
                return [LMLeavemessagecell cellHigth:list.commentContent];
            }
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
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
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return eventArray.count;
    }
    if (section==3) {
        return msgArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"cellIdd";
        
        LMActivityheadCell *cell = [[LMActivityheadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setValue:eventDic];
        cell.joinButton.titleLabel.text =_type;
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
        
        cell.delegate = self;
        
        UITapGestureRecognizer   *hintLblTap     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTelephone)];
        [cell.numberLabel addGestureRecognizer:hintLblTap];
        
        UITapGestureRecognizer   *tapMap     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transitionMapView)];
        [cell.addressLabel addGestureRecognizer:tapMap];
        
        [cell.mapButton addTarget:self action:@selector(transitionMapView) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.section==2) {
        
        static NSString *cellId = @"cellId";
        
        LMEventMsgCell *cell = [[LMEventMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LMProjectBodyVO *list = eventArray[indexPath.row];
        
        if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
            
            cell.index = 1;
        }
        cell.tag = indexPath.row;
        
        cell.delegate = self;
        
        [cell setValue:list];
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        return cell;
    }
    
    
    return nil;
}

#pragma mark 拨打电话

- (void)callTelephone
{
    if (!eventDic.contactPhone) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"是否拨打：%@",eventDic.contactPhone]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                
                                                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",eventDic.contactPhone];
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark 跳转到地图

-(void)transitionMapView
{
    
    if (!eventDic.address&&![eventDic.address isEqualToString:@""]) {
        return;
    }
    
    if ([latitude floatValue]<=0||[longitude floatValue]<=0){
        return;
    }
    
    if (!latitude||!longitude){
        return;
    }
    
    LMNavMapViewController *mapVC=[[LMNavMapViewController alloc]init];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [dic setObject:eventDic.address forKey:@"addressName"];
    [dic setObject:latitude forKey:@"latitude"];
    [dic setObject:longitude forKey:@"longitude"];
    mapVC.infoDic=dic;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 230-64) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        self.navigationController.navigationBar.hidden=YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        headerView.hidden=NO;
        
    }else{
        if (hiddenIndex==2) {
            [UIApplication sharedApplication].statusBarHidden = NO;
        }
        
        if (hiddenIndex==1) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
        
        self.navigationController.navigationBar.hidden=NO;
        headerView.hidden=YES;
    }
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

#pragma mark 删除活动  LMActivityDeleteRequest

- (void)deleteActivity
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"是否删除"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self deleteActivityRequest];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteActivityRequest
{
    LMActivityDeleteRequest *request = [[LMActivityDeleteRequest alloc] initWithEvent_uuid:_eventUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(deleteActivityResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)deleteActivityResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"删除成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent" object:nil];
        });
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

#pragma mark --删除评论

- (void)deletCellAction:(UILongPressGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    
    LMEventCommentVO *list= msgArray[index];
    if (![list.userUuid isEqual:[FitUserManager sharedUserManager].uuid]) {
        
        return;
        
    } else {
        
        if (tap.state == UIGestureRecognizerStateEnded) {
            
            if ([list.type isEqual:@"comment"]){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除您的评论"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction*action) {
                                                            
                                                            [self deleteCommentdata:list.commentUuid];
                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            if ([list.type isEqual:@"reply"]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除您的回复"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction*action) {
                                                            
                                                            [self deleteArticleReply:list.replyUuid];
                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } else {
            
        }
    }
}

- (void)deleteCommentdata:(NSString *)uuid
{
    LMEventCommentRequest *request = [[LMEventCommentRequest alloc] initWithCommentUUid:uuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteArticlecommentResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getdeleteArticlecommentResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"删除失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"删除成功"];
            
            [self getEventListDataRequest];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

-(void)deleteArticleReply:(NSString *)uuid
{
    
    LMEventReplydeleteRequest *request = [[LMEventReplydeleteRequest alloc] initWithCommentUUid:uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteArticlereplyResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}
-(void)getdeleteArticlereplyResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"删除失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"删除成功"];
            
            [self getEventListDataRequest];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark -活动大图

- (void)cellClickImage:(LMActivityheadCell *)cell
{
    
    if (cell.imageV.image) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [ImageHelpTool showImage:cell.imageV];
    }else{
        
    }
    
    
}

#pragma mark --项目大图

-(void)cellProjectImage:(LMEventMsgCell *)cell
{
    NSMutableArray *array = [NSMutableArray new];
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageArray delegate:self];
    for (int i = 0; i<cell.tag+1; i++) {
        LMProjectBodyVO *vo = eventArray[i];
        if ([vo.projectImgs isEqual:@""]) {
            [array addObject:vo.projectImgs];
        }
        
    }
    NSLog(@"%lu",(unsigned long)array.count);
    
    photoBrowser.initialPageIndex = cell.tag-array.count;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    hiddenIndex=2;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
}


-(void)closeComment
{
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark  --开始活动
-(void)startActivity
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LMEventStartRequest *request = [[LMEventStartRequest alloc] initWithEvent_uuid:_eventUuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getstartEventResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"开始活动失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

-(void)getstartEventResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"活动开启失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"活动开启成功"];
            
            [self getEventListDataRequest];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark   --结束活动

- (void)endActivity
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMEventEndRequest *request = [[LMEventEndRequest alloc] initWithEvent_uuid:_eventUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getendEventResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"活动结束失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getendEventResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"活动结束失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"活动结束成功"];
            
            [self getEventListDataRequest];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

//活动举报按钮
- (void)cellWillreport:(LMActivityMsgCell *)cell
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否举报该活动"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self textStateHUD:@"您已经举报了该活动"];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showImage:(UIImageView *)avatarImageView{
    [UIApplication sharedApplication].statusBarHidden = YES;
    hiddenIndex =1;
    [self scrollViewDidScroll:self.tableView];
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    [UIApplication sharedApplication].statusBarHidden = NO;
    hiddenIndex =2;
    [self scrollViewDidScroll:self.tableView];
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
        
    }];
}

@end
