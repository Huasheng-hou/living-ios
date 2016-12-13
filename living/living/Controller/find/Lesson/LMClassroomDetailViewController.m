//
//  LMClassroomDetailViewController.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMClassroomDetailViewController.h"
#import "LMOrderViewController.h"
#import "LMVoiceProjectCell.h"
#import "LMLeavemessagecell.h"
#import "UIView+frame.h"
#import "LMVoiceDetailHeaderView.h"
#import "LMClassMessageCell.h"
#import "LMVoiceHeaderCell.h"

#import "LMVoiceDetailRequest.h"

#import "LMEventCommentVO.h"
#import "LMVoiceDetailVO.h"
#import "LMProjectsBody.h"

#import "LMEventJoinRequest.h"
#import "LMEventLivingMsgRequest.h"
#import "LMEventpraiseRequest.h"
#import "LMEventCommitReplyRequset.h"
#import "LMChooseView.h"
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
#import "HBShareView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import "LMArtcleFootView.h"

//地图导航
#import "LMNavMapViewController.h"
static CGRect oldframe;
@interface LMClassroomDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
UITextViewDelegate,
LMVoiceDetailHeaderViewDelegate,
LMLeavemessagecellDelegate,
LMVoiceProjectCellDelegate,
LMClassMessageCellDelegate,
shareTypeDelegate,
LMVoiceHeaderCellDelegate
>
{
    UILabel  *tipLabel;
    UIButton *zanButton;
    UITextView *suggestTF;
    
    // * 顶部报名横幅
    LMVoiceDetailHeaderView *headerView;
    
    NSMutableArray *msgArray;
    NSMutableArray *eventArray;
    LMVoiceDetailVO *eventDic;
    UIView *commentsView;
    UITextView *commentText;
    UIView *backView;
    NSString *commitUUid;
    NSMutableDictionary *orderDic;
    
    NSMutableArray *imageArray;
    
    NSString *status;
    UIBarButtonItem *rightItem;
    
    NSString *vipString;
    NSInteger  hiddenIndex;
    UIView *backgroundViews;
    UIImageView *imageViews;
    UIImage *bigImage;
    UIToolbar *toolBar;
    UITextView *textcView;
    CGFloat contentSize;
    NSInteger _rows;
    CGFloat bgViewY;
    LMArtcleFootView *footView;
    UIView *addView;
    UIView *blackView;
    NSMutableArray *clickArr;
    NSInteger textIndex;
}

@end

@implementation LMClassroomDetailViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [commentText resignFirstResponder];
}


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
    clickArr = [NSMutableArray new];
    
    //加入订单
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(joindataRequest:)
//                                                 name:@"purchase"
//                                               object:nil];
}

- (void)creatUI
{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                   style:UITableViewStyleGrouped];
    
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.keyboardDismissMode      = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset             = UIEdgeInsetsMake(0, 0, 12, 0);
    
    [self.view addSubview:self.tableView];
    
    headerView = [[LMVoiceDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    headerView.hidden           = YES;
    headerView.delegate         = self;
    
    [self.view addSubview:headerView];
    [self creatFootView];
    [self creatfootView2];
}


- (void)creatFootView
{
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    toolBar. barStyle = UIBarButtonItemStylePlain ;
    toolBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview :toolBar];
    
    textcView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7.5, kScreenWidth-65, 30)];
    [textcView setDelegate:self];
    textcView.font = TEXT_FONT_LEVEL_2;
    textcView.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    textcView.layer.borderWidth = 1;
    
    textcView.backgroundColor = [UIColor whiteColor];
    textcView.layer.cornerRadius    = 4;
    
    textcView.keyboardType=UIKeyboardTypeDefault;
    [textcView setReturnKeyType:UIReturnKeySend];
    
    zanButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 45)];
    zanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [zanButton setTitle:@"发送" forState:UIControlStateNormal];
    [zanButton setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
    [zanButton addTarget:self action:@selector(getCommentArticleDataRequest) forControlEvents:UIControlEventTouchUpInside];
    zanButton.titleLabel.font = TEXT_FONT_LEVEL_3;
    
    [toolBar addSubview:zanButton];
    
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth-60, 30)];
    tipLabel.text = @"说两句吧...";
    tipLabel.textColor =TEXT_COLOR_LEVEL_3;
    tipLabel.font = TEXT_FONT_LEVEL_3;
    [textcView addSubview:tipLabel];
    
    [toolBar addSubview:textcView];
    
}

- (void)creatfootView2
{
    footView = [[LMArtcleFootView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [footView addSubview:lineView];
    
    [footView.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.commentButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.zanartcle addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.shareartcle addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    
    [footView.moreartcle addTarget:self action:@selector(creatMoreView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:footView];
}

#pragma mark --课程点赞

- (void)zanButtonAction:(id)senser
{
    [self dismissSelf];
    
//    if ([[FitUserManager sharedUserManager] isLogin]) {
//        LMArtclePariseRequest *request = [[LMArtclePariseRequest alloc] initWithArticle_uuid:_artcleuuid];
//        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                               completed:^(NSString *resp, NSStringEncoding encoding) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(getarticlePraiseDataResponse:)
//                                                                          withObject:resp
//                                                                       waitUntilDone:YES];
//                                               } failed:^(NSError *error) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                          withObject:@"网络错误"
//                                                                       waitUntilDone:YES];
//                                               }];
//        [proxy start];
//    }else{
//        [self IsLoginIn];
//    }
    
}

- (void)getarticlePraiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"])
    {
        [self textStateHUD:@"点赞成功"];
        [self getEventListDataRequest];
        [self.tableView reloadData];
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

-(void)backAction
{
    [commentText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapAction
{
    [self dismissSelf];
    [textcView becomeFirstResponder];
}

#pragma mark 分享按钮

-(void)shareButton
{
    [self dismissSelf];
    
    HBShareView *shareView=[[HBShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.delegate=self;
    [self.view addSubview:shareView];
}

#pragma mark --更多按钮

- (void)creatMoreView
{
    if (footView.moreartcle.selected == NO) {
        [clickArr addObject:@"1"];
        
    }
    if (clickArr.count%2 == 1) {
        blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [self.view addSubview:blackView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        [blackView addGestureRecognizer:tap];
        
        
        addView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/3)];
        addView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:addView];
        
        [UIView animateWithDuration:0.3f animations:^{
            [addView setFrame:CGRectMake(0, kScreenHeight*2/3-45, kScreenWidth, kScreenHeight/3)];
        }];
        
        
        UILabel *type = [UILabel new];
        type.text = @"字号大小";
        type.font = TEXT_FONT_LEVEL_1;
        type.textColor =TEXT_COLOR_LEVEL_1;
        type.textAlignment = NSTextAlignmentCenter;
        [type sizeToFit];
        [addView addSubview:type];
        
//        bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [bigBtn setTitle:@"大" forState:UIControlStateNormal];
//        bigBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
//        [bigBtn sizeToFit];
//        [addView addSubview:bigBtn];
//        [bigBtn addTarget:self action:@selector(bigBtnButton) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [midBtn setTitle:@"中" forState:UIControlStateNormal];
//        midBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
//        [midBtn sizeToFit];
//        [addView addSubview:midBtn];
//        [midBtn addTarget:self action:@selector(midBtnButton) forControlEvents:UIControlEventTouchUpInside];
//        
//        smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [smallBtn setTitle:@"小" forState:UIControlStateNormal];
//        smallBtn.titleLabel.font = TEXT_FONT_LEVEL_2;
//        [smallBtn sizeToFit];
//        [addView addSubview:smallBtn];
//        [smallBtn addTarget:self action:@selector(smallBtnButton) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        type.frame = CGRectMake(15, 0, type.bounds.size.width, 45);
//        smallBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/6, 45);
//        midBtn.frame = CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/6, 45);
//        bigBtn.frame = CGRectMake(kScreenWidth*5/6, 0, kScreenWidth/6, 45);
//        
//        if (typeIndex ==1) {
//            [bigBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
//            [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//            [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//        }
//        if (typeIndex ==2) {
//            [midBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
//            [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//            [smallBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//        }
//        if (typeIndex ==3) {
//            [smallBtn setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
//            [bigBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//            [midBtn setTitleColor:TEXT_COLOR_LEVEL_3 forState:UIControlStateNormal];
//        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5)];
        lineView.backgroundColor = LINE_COLOR;
        [addView addSubview:lineView];
        
        UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [writeButton setTitle:@"作者文章空间" forState:UIControlStateNormal];
        writeButton.titleLabel.font = TEXT_FONT_LEVEL_1;
        [writeButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
        [writeButton sizeToFit];
        writeButton.frame = CGRectMake(kScreenWidth/2-80, addView.bounds.size.height/2, 160, 45);
        
        writeButton.layer.cornerRadius = 22.5;
        writeButton.layer.borderColor = LIVING_COLOR.CGColor;
        writeButton.layer.borderWidth = 0.5;
        
        [addView addSubview:writeButton];
        [writeButton addTarget:self action:@selector(WriterVC) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        [self dismissSelf];
    }
}

#pragma mark --跳转writerVC

- (void)WriterVC
{
    [self dismissSelf];
//    LMWriterViewController *VC = [[LMWriterViewController alloc] initWithUUid:articleData.userUuid];
//    VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)dismissSelf
{
    [UIView animateWithDuration:0.3f animations:^{
        blackView.alpha = 0;
        [addView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/3)];
    } completion:^(BOOL finished) {
        
        [blackView removeFromSuperview];
        [addView removeFromSuperview];
        
    }];
}





- (void)getEventListDataRequest
{
    [self initStateHud];
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    LMVoiceDetailRequest *request = [[LMVoiceDetailRequest alloc] initWithVoice_uuid:_voiceUUid];
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
        
        NSMutableArray *array = bodyDic[@"leaving_messages"];
        
        msgArray    = [NSMutableArray new];
        eventArray  = [NSMutableArray new];
        imageArray  = [NSMutableArray new];
        
        for (int i = 0; i < array.count; i++) {
            
            LMEventCommentVO *list = [LMEventCommentVO LMEventCommentVOWithDictionary:array[i]];
            [msgArray addObject:list];
        }
        
        if (msgArray&&msgArray.count>0) {
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+10);
        }
        
        NSArray *eveArray =[LMProjectBodyVO LMProjectBodyVOListWithArray:bodyDic[@"event_projects_body"]];
        
        for (LMProjectBodyVO *vo in eveArray) {
            
            [eventArray addObject:vo];
        }
        for (int i = 0; i < eveArray.count; i++) {
            
            LMProjectsBody *Projectslist=eveArray[i];
            
            if (Projectslist.projectImgs && [Projectslist.projectImgs isKindOfClass:[NSString class]] && ![Projectslist.projectImgs isEqual:@""]) {
                
                [imageArray addObject: Projectslist.projectImgs];
            }
        }
        
        eventDic    = [[LMVoiceDetailVO alloc] initWithDictionary:bodyDic[@"voice_body"]];
        orderDic    = [bodyDic objectForKey:@"voice_body"];
        
        if ([eventDic.status isEqualToString:@"ready"]) {
            
            status = @"开始";
        }
        if ([eventDic.status isEqualToString:@"closed"]) {
            status = @"结束";
        }
        
        if ([eventDic.userUuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
            
            if (eventDic.number==0) {
                rightItem  = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
            
            if (eventDic.number>0&&[status isEqual:@"开始"]) {
                rightItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(startActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
                
            }
            
            if (eventDic.number>0&&[status isEqual:@"结束"]) {
                
                
                rightItem = [[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStylePlain target:self action:@selector(endActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
        }
        [headerView setEvent:eventDic];
        [self.tableView reloadData];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [LMVoiceHeaderCell cellHigth:eventDic.voiceTitle];
    }
    if (indexPath.section==1) {
        
        return 150;
    }
    
    if (indexPath.section==2) {
        
        if (eventArray.count > indexPath.row) {
            
            LMProjectBodyVO *list = eventArray[indexPath.row];
            
            if (list && [list isKindOfClass:[LMProjectBodyVO class]]) {
                NSString *string = list.projectTitle;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
                CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                
                
                if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
                    if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                        return 30 + conHigh;
                    }else{
                        return 50 + conHigh + [LMVoiceProjectCell cellHigth:list.projectDsp];
                    }
                    
                } else {
                    if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                        return list.height*(kScreenWidth-30)/list.width + conHigh+30;
                    }else{
                        return list.height*(kScreenWidth-30)/list.width + conHigh + [LMVoiceProjectCell cellHigth:list.projectDsp]+50;
                    }
                    
                    
                }
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
        commentLabel.text = @"课堂信息";
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
        commentLabel.text = @"项目介绍";
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
    if (section==3) {
        return 150;
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
        
        LMVoiceHeaderCell *cell = [[LMVoiceHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setValue:eventDic];
        
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        cell.delegate = self;
        
        return cell;
    }
    
    //课堂信息
    if (indexPath.section==1) {
        
        static NSString *cellId = @"cellIddd";
        
        LMClassMessageCell *cell = [[LMClassMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [cell setValue:eventDic];
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        cell.delegate = self;
        
        UITapGestureRecognizer   *hintLblTap     = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTelephone)];
        [cell.numberLabel addGestureRecognizer:hintLblTap];
        
        
        return cell;
    }
    
    if (indexPath.section==2) {
        
        static NSString *cellId = @"cellId";
        
        LMVoiceProjectCell *cell = [[LMVoiceProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
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
    
    if (indexPath.section==3) {
        static NSString *cellId = @"cellId";
        
        LMLeavemessagecell *cell = [[LMLeavemessagecell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LMEventCommentVO *list = msgArray[indexPath.row];
        
        [cell setValue:list];
        cell.delegate = self;
        cell.tag = indexPath.row;
        [cell setXScale:self.xScale yScale:self.yScaleNoTab];
        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletCellAction:)];
        tap.minimumPressDuration = 1.0;
        cell.contentView.tag = indexPath.row;
        [cell.contentView addGestureRecognizer:tap];
        
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

#pragma mark - LMLeavemessagecell delegate -点赞
//- (void)cellWillComment:(LMLeavemessagecell *)cell
//{
//    
//    if ([[FitUserManager sharedUserManager] isLogin]){
//        
//        if (![CheckUtils isLink]) {
//            
//            [self textStateHUD:@"无网络"];
//            return;
//        }
//        
//        LMEventCommentVO *list = msgArray[cell.tag];
//        
//        
//        LMEventpraiseRequest *request = [[LMEventpraiseRequest alloc] initWithEvent_uuid:_eventUuid CommentUUid:list.commentUuid];
//        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                               completed:^(NSString *resp, NSStringEncoding encoding) {
//                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                       NSDictionary *bodyDic = [VOUtil parseBody:resp];
//                                                       [self logoutAction:resp];
//                                                       if (!bodyDic) {
//                                                           [self textStateHUD:@"点赞失败"];
//                                                       }else{
//                                                           
//                                                           
//                                                           if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
//                                                               [self textStateHUD:@"点赞成功"];
//                                                               [self getEventListDataRequest];
//                                                               NSArray *indexPaths = @[[NSIndexPath indexPathForRow:cell.tag inSection:3]];
//                                                               [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                                                               
//                                                               
//                                                           }else{
//                                                               NSString *str = [bodyDic objectForKey:@"description"];
//                                                               [self textStateHUD:str];
//                                                           }
//                                                       }
//                                                       
//                                                   });
//                                                   
//                                                   
//                                               } failed:^(NSError *error) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                          withObject:@"网络错误"
//                                                                       waitUntilDone:YES];
//                                               }];
//        [proxy start];
//        
//    } else {
//        
//        [self IsLoginIn];
//    }
//}

- (void)getEventpraiseDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
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
- (void)cellWillReply:(LMLeavemessagecell *)cell
{
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        
        LMEventCommentVO *list = msgArray[cell.tag];
        
        commitUUid = list.commentUuid;
        
        self.tableView.userInteractionEnabled = NO;
        [self showCommentText];
        
    }else{
        [self IsLoginIn];
    }
    
    
}

- (void)showCommentText
{
    [self createCommentsView];
    [commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

- (void)createCommentsView
{
    if (!commentsView) {
        commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kScreenHeight - 180 - 200.0, kScreenWidth, 200.0)];
        commentsView.layer.borderColor = LINE_COLOR.CGColor;
        commentsView.layer.borderWidth= 0.5;
        commentsView.backgroundColor = BG_GRAY_COLOR;
        commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 40.0)];
        commentText.layer.borderWidth   = 0.5;
        commentText.layer.borderColor   = LINE_COLOR.CGColor;
        commentText.layer.cornerRadius  = 5.0;
        commentText.layer.masksToBounds = YES;
        commentText.inputAccessoryView  = commentsView;
        commentText.backgroundColor     = [UIColor whiteColor];
        commentText.returnKeyType       = UIReturnKeySend;
        commentText.delegate	        = self;
        commentText.font		        = [UIFont systemFontOfSize:15.0];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureButton.frame = CGRectMake(kScreenWidth - 80, 160-70, 62, 24);
        sureButton.layer.cornerRadius   = 4;
        sureButton.layer.borderWidth    = .5;
        sureButton.layer.borderColor    = LIVING_COLOR.CGColor;
        
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [sureButton setTitleColor:LIVING_COLOR forState:UIControlStateNormal];
        
        sureButton.tintColor = [UIColor whiteColor];
        [sureButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [commentText addSubview:sureButton];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(kScreenWidth-38, 9, 22, 22);
        closeButton.layer.cornerRadius = 5;
        [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        closeButton.tintColor = LIVING_COLOR;
        [closeButton addTarget:self action:@selector(closeComment) forControlEvents:UIControlEventTouchUpInside];
        
        [commentsView addSubview:closeButton];
        
        [commentsView addSubview:commentText];
    }
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来
}

- (void)sendComment
{
    if ([commentText.text isEqualToString:@""]) {
        [self textStateHUD:@"回答内容不能为空"];
        return;
    }
    
    [self commitDataRequest];
    
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

- (void)commitDataRequest
{
//    NSString *string    = [commentText.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
//    LMEventCommitReplyRequset *request = [[LMEventCommitReplyRequset alloc] initWithEvent_uuid:_eventUuid CommentUUid:commitUUid Reply_content:string];
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                           completed:^(NSString *resp, NSStringEncoding encoding) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(getEventcommitResponse:)
//                                                                      withObject:resp
//                                                                   waitUntilDone:YES];
//                                           } failed:^(NSError *error) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                      withObject:@"网络错误"
//                                                                   waitUntilDone:YES];
//                                           }];
//    [proxy start];
    
}

- (void)getEventcommitResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"回复失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"回复成功"];
        
        commentText.text    = @"";
        [self getEventListDataRequest];
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

#pragma mark - LMActivityheadCell delegate -活动报名

- (void)shouldJoinActivity
{
    [self cellWillApply:nil];
}

- (void)cellWillApply:(LMVoiceHeaderCell *)cell
{
    if ([[FitUserManager sharedUserManager] isLogin]){
        
        LMChooseView *infoView = [[LMChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        infoView.event  = eventDic;
        
        infoView.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 25, 150, 30)];
        infoView.titleLabel.text = @"￥:10000";
        infoView.titleLabel.textColor = LIVING_REDCOLOR;
        infoView.titleLabel.font = [UIFont systemFontOfSize:17];
        [infoView.bottomView addSubview:infoView.titleLabel];
        
        infoView.title2 = [UILabel new];
        infoView.title2.text = @"￥:10000";
        infoView.title2.textColor = TEXT_COLOR_LEVEL_2;
        infoView.title2.font = [UIFont systemFontOfSize:15];
        
        [infoView.bottomView addSubview:infoView.title2];
        
        if ([[FitUserManager sharedUserManager].vipString isEqual:@"menber"]||[vipString isEqual:@"vipString"]) {
            
            
            infoView.titleLabel.text = [NSString stringWithFormat:@"￥%@", eventDic.discount];
            [infoView.titleLabel sizeToFit];
            infoView.titleLabel.frame = CGRectMake(145, 25, infoView.titleLabel.bounds.size.width, 30);
            
            infoView.title2.text = [NSString stringWithFormat:@"￥%@", eventDic.perCost];
            [infoView.title2 sizeToFit];
            infoView.title2.frame = CGRectMake(155+infoView.titleLabel.bounds.size.width, 25, infoView.title2.bounds.size.width, 30);
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(155+infoView.titleLabel.bounds.size.width, 40, infoView.title2.bounds.size.width+2, 1.5)];
            line.backgroundColor = TEXT_COLOR_LEVEL_3;
            [infoView.bottomView addSubview:line];
            
        }else{
            infoView.titleLabel.text = [NSString stringWithFormat:@"￥%@", eventDic.perCost];
            [infoView.titleLabel sizeToFit];
            infoView.titleLabel.frame = CGRectMake(145, 25, infoView.titleLabel.bounds.size.width, 30);
            
        }
//        if (eventDic.notices==nil) {
//            infoView.dspLabel.text = @"暂无报名须知";
//        }else{
//            infoView.dspLabel.text = eventDic.notices;
//        }
        
//        infoView.inventory.text = [NSString stringWithFormat:@"活动人数 %d/%d人",eventDic.,eventDic.totalNum];
        
        [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.image]];
        
        infoView.orderInfo = orderDic;
        
        [self.view addSubview:infoView];
        
        UIView *view = [infoView viewWithTag:1000];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            view.frame = CGRectMake(0, kScreenHeight-425,self.view.bounds.size.width, 425);
        }];
    } else {
        
        [self IsLoginIn];
    }
}

//- (void)joindataRequest:(NSNotification *)notice
//{
//    if (![CheckUtils isLink]) {
//        
//        [self textStateHUD:@"无网络"];
//        return;
//    }
//    
//    [self initStateHud];
//    
//    NSMutableDictionary *orderNum=notice.object;
//    
//    NSString *num = [NSString stringWithFormat:@"%@",orderNum[@"num"]];
//    
//    LMEventJoinRequest *request = [[LMEventJoinRequest alloc] initWithEvent_uuid:_eventUuid order_nums:num];
//    
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                           completed:^(NSString *resp, NSStringEncoding encoding) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(getEventjoinDataResponse:)
//                                                                      withObject:resp
//                                                                   waitUntilDone:YES];
//                                           } failed:^(NSError *error) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                      withObject:@"网络错误"
//                                                                   waitUntilDone:YES];
//                                           }];
//    [proxy start];
//}

- (void)getEventjoinDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
        
        [self textStateHUD:@"报名失败"];
    }
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"报名成功"];
        NSString *orderID = [bodyDic objectForKey:@"order_uuid"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            LMBesureOrderViewController *OrderVC = [[LMBesureOrderViewController alloc] init];
            
            OrderVC.orderUUid   = orderID;
            OrderVC.dict        = orderDic;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.navigationController.navigationBar.hidden  = NO;
            
            FitNavigationController     *navVC  = [[FitNavigationController alloc] initWithRootViewController:OrderVC];
            [self presentViewController:navVC animated:YES completion:nil];
        });
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 230-64) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        self.navigationController.navigationBar.hidden=YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        headerView.hidden=NO;
        hiddenIndex=2;
        
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

#pragma mark  --活动留言或评论

- (void)besureAction:(id)sender
{
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        
        [self initStateHud];
        
        [self.view endEditing:YES];
        
        if (suggestTF.text.length<=0) {
            
            [self textStateHUD:@"请输入内容"];
            return;
        }
        
        if (![CheckUtils isLink]) {
            
            [self textStateHUD:@"无网络连接"];
            return;
        }
        
//        NSString *string    = [suggestTF.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        
//        LMEventLivingMsgRequest *request = [[LMEventLivingMsgRequest alloc] initWithEvent_uuid:_eventUuid Commentcontent:string];
//        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                               completed:^(NSString *resp, NSStringEncoding encoding) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(getEventLivingmsgDataResponse:)
//                                                                          withObject:resp
//                                                                       waitUntilDone:YES];
//                                               } failed:^(NSError *error) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                          withObject:@"网络错误"
//                                                                       waitUntilDone:YES];
//                                               }];
//        [proxy start];
//        
//    }else{
//        [self IsLoginIn];
    }
    
}

- (void)getEventLivingmsgDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
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
                                                                   message:@"是否删除活动"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
//                                                [self deleteActivityRequest];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)deleteActivityRequest
//{
//    LMActivityDeleteRequest *request = [[LMActivityDeleteRequest alloc] initWithEvent_uuid:_eventUuid];
//    
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                           completed:^(NSString *resp, NSStringEncoding encoding) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(deleteActivityResponse:)
//                                                                      withObject:resp
//                                                                   waitUntilDone:YES];
//                                           } failed:^(NSError *error) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                      withObject:@"删除失败"
//                                                                   waitUntilDone:YES];
//                                           }];
//    [proxy start];
//    
//}

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
                                                                      withObject:@"删除评论失败"
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

- (void)deleteArticleReply:(NSString *)uuid
{
    
    LMEventReplydeleteRequest *request = [[LMEventReplydeleteRequest alloc] initWithCommentUUid:uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getdeleteArticlereplyResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"删除回复失败"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getdeleteArticlereplyResponse:(NSString *)resp
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

- (void)cellClickImage:(LMVoiceHeaderCell *)cell
{
    if (cell.imageV.image) {
        bigImage =cell.imageV.image;
        [self showImage:cell.imageV];
        
    }else{
        return;
    }
    
}

#pragma mark --项目大图

- (void)cellProjectImage:(LMVoiceProjectCell *)cell
{
    NSMutableArray *array = [NSMutableArray new];
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageArray delegate:self];
    
    for (int i = 0; i<cell.tag+1; i++) {
        
        LMProjectBodyVO *vo = eventArray[i];
        
        if ([vo.projectImgs isEqual:@""]) {
            
            [array addObject:vo.projectImgs];
        }
    }
    
    photoBrowser.initialPageIndex = cell.tag-array.count;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    hiddenIndex=2;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.tableView.userInteractionEnabled = YES;
}

- (void)closeComment
{
    [commentText resignFirstResponder];
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark  --开始活动

- (void)startActivity
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否开启活动"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self startEvent];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)startEvent{
    
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络"];
        return;
    }
    
//    LMEventStartRequest *request = [[LMEventStartRequest alloc] initWithEvent_uuid:_eventUuid];
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                           completed:^(NSString *resp, NSStringEncoding encoding) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(getstartEventResponse:)
//                                                                      withObject:resp
//                                                                   waitUntilDone:YES];
//                                           } failed:^(NSError *error) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                      withObject:@"开始活动失败"
//                                                                   waitUntilDone:YES];
//                                           }];
//    [proxy start];
}

- (void)getstartEventResponse:(NSString *)resp
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否结束活动"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
//                                                [self endEvent];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//-(void)endEvent{
//    
//    if (![CheckUtils isLink]) {
//        
//        [self textStateHUD:@"无网络连接"];
//        return;
//    }
//    
//    LMEventEndRequest *request = [[LMEventEndRequest alloc] initWithEvent_uuid:_eventUuid];
//    
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                           completed:^(NSString *resp, NSStringEncoding encoding) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(getendEventResponse:)
//                                                                      withObject:resp
//                                                                   waitUntilDone:YES];
//                                           } failed:^(NSError *error) {
//                                               
//                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                      withObject:@"活动结束失败"
//                                                                   waitUntilDone:YES];
//                                           }];
//    [proxy start];
//}

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
- (void)cellWillreport:(LMClassMessageCell *)cell
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
    
    UIImage *image=avatarImageView.image;
    //    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    backgroundViews=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:self.view];
    backgroundViews.backgroundColor=[UIColor blackColor];
    backgroundViews.alpha=0;
    imageViews=[[UIImageView alloc]initWithFrame:oldframe];
    imageViews.image=image;
    imageViews.tag=1;
    [backgroundViews addSubview:imageViews];
    [self.view addSubview:backgroundViews];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundViews addGestureRecognizer: tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImageView:)];
    swipe.numberOfTouchesRequired =1;
    swipe.direction =UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [backgroundViews addGestureRecognizer:swipe];
    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressAction:)];
    LongPress.minimumPressDuration = 1.0;
    [backgroundViews addGestureRecognizer:LongPress];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundViews.alpha=1;
        hiddenIndex =1;
        [self scrollViewDidScroll:self.tableView];
        self.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    hiddenIndex =2;
    [self scrollViewDidScroll:self.tableView];
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
        
    }];
}

-(void)hiddenImageView:(UISwipeGestureRecognizer*)tap{
    hiddenIndex =2;
    [self scrollViewDidScroll:self.tableView];
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
        
    }];
}

- (void)LongPressAction:(UILongPressGestureRecognizer *)longPress
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(bigImage,self,  @selector(image:didFinishSavingWithError:contextInfo:imageview:), NULL);
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo imageview:(UIImageView *)imageView

{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    hiddenIndex =2;
    [self scrollViewDidScroll:self.tableView];
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=oldframe;
        backgroundViews.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundViews removeFromSuperview];
        
    }];
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    [self textStateHUD:msg];
    [self scrollViewDidScroll:self.tableView];
    
    
}

- (void)cellShareImage
{
    HBShareView *shareView=[[HBShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.delegate=self;
    shareView.titleLabel.text = @"分享活动";
    [self.view addSubview:shareView];
}

#pragma mark 对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)shareType:(NSInteger)type
{
    NSString *urlString = @"http://yaoguo1818.com/living-web/event/detail?event_uuid=";
    
    switch (type) {
        case 1://微信好友
        {
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=eventDic.voiceTitle;
            //            message.description=eventDic.describe;
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:eventDic.image]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
//            web.webpageUrl=[NSString stringWithFormat:@"%@%@",urlString,_eventUuid];
            message.mediaObject=web;
            
            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
            req.bText=NO;
            req.message=message;
            req.scene=WXSceneSession;//好友
            [WXApi sendReq:req];
        }
            break;
        case 2://微信朋友圈
        {
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=eventDic.voiceTitle;
            //            message.description=articleData.describe;
            
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:eventDic.image]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
//            web.webpageUrl=[NSString stringWithFormat:@"%@%@",urlString,_eventUuid];
            message.mediaObject=web;
            
            SendMessageToWXReq *req=[[SendMessageToWXReq alloc]init];
            req.bText=NO;
            req.message=message;
            req.scene=WXSceneTimeline;//朋友圈
            [WXApi sendReq:req];
        }
            break;
        case 3://qq好友
        {
            NSString *imageUrl;
            
            if (imageArray.count==0) {
                
                imageUrl=@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/1eac8bd3b16fd9bb1a3323f43b336bd7.jpg";
            } else {
                
                imageUrl=eventDic.image;
            }
            
//            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,_eventUuid]] title:eventDic.image description:nil previewImageURL:[NSURL URLWithString:imageUrl]];
//            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
//            //将内容分享到qq
//            [QQApiInterface sendReq:req];
        }
            break;
        case 4://qq空间
        {
            NSString *imageUrl;
            if (imageArray.count==0) {
                imageUrl=@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/1eac8bd3b16fd9bb1a3323f43b336bd7.jpg";
            }else{
                imageUrl=eventDic.image;
            }
            
//            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,_eventUuid]] title:eventDic.eventName description:nil previewImageURL:[NSURL URLWithString:imageUrl]];
//            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
//            //将内容分享到qq空间
//            [QQApiInterface SendReqToQZone:req];
        }
            break;
            
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView isEqual:textcView]) {
        if (textView.text.length==0) {
            tipLabel.hidden=NO;
        }else{
            tipLabel.hidden=YES;
        }
        
        // numberlines用来控制输入的行数
        NSInteger numberLines = textView.contentSize.height / textView.font.lineHeight;
        if (numberLines != _rows) {
            NSLog(@"text = %@", textcView.text);
            _rows = numberLines;
            if  (_rows < 5){
                [self changeFrame:textView.contentSize.height];
            }else{
                textcView.scrollEnabled = YES;
            }
            
            [textView setContentOffset:CGPointZero animated:YES];
        }
    }
}

- (void)changeFrame:(CGFloat)height
{
    CGRect originalFrame = toolBar.frame;
    originalFrame.size.height = 30 + height ;
    originalFrame.origin.y = bgViewY - height + 30;
    CGRect textViewFrame = textcView.frame;
    textViewFrame.size.height = height;
    
    [UIView animateWithDuration:0.3 animations:^{
        toolBar.frame = originalFrame;
        textcView.frame = textViewFrame;
        contentSize = height-30;
    }];
}

//修改textView return键

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([textView isEqual:textcView]) {
            [textcView resignFirstResponder];
//            [self getCommentArticleDataRequest];
        }
        if ([textView isEqual:commentText]) {
            self.tableView.userInteractionEnabled = YES;
            [commentText resignFirstResponder];
            [self sendComment];
        }
        
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


#pragma mark  --评论课程
- (void)getCommentArticleDataRequest
{
    if ([[FitUserManager sharedUserManager] isLogin]){
        
        [self initStateHud];
        
        if (textcView.text.length <= 0) {
            
            [self textStateHUD:@"请输入评论内容"];
            return;
        }
        
//        NSString *string    = [textcView.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        
//        LMCommentArticleRequest *request = [[LMCommentArticleRequest alloc] initWithArticle_uuid:_artcleuuid Commentcontent:string];
//        
//        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
//                                               completed:^(NSString *resp, NSStringEncoding encoding) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(getCommentArticleDataResponse:)
//                                                                          withObject:resp
//                                                                       waitUntilDone:YES];
//                                               } failed:^(NSError *error) {
//                                                   
//                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
//                                                                          withObject:@"网络错误"
//                                                                       waitUntilDone:YES];
//                                               }];
//        [proxy start];
//        
//    } else {
//        
//        [self IsLoginIn];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:textcView]) {
        textIndex = 2;
    }
    if ([textView isEqual:commentText]) {
        textIndex = 1;
    }
    return YES;
}


- (void)getCommentArticleDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"评论成功"];
//        [self getHomeDetailDataRequest];
        
        textcView.text  = @"";
        tipLabel.hidden =NO;
        [textcView resignFirstResponder];
        
    } else {
        
        NSString *str = [bodyDic objectForKey:@"description"];
        
        if (str && ![str isEqual:[NSNull null]] && [str isKindOfClass:[NSString class]]) {
            
            [self textStateHUD:str];
        } else {
            
            [self textStateHUD:@"发布失败"];
        }
    }
}

#pragma mark 键盘部分

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardChangeFrame:(NSNotification *)notifi
{
    CGRect keyboardFrame = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (textIndex!=1) {
        [UIView animateWithDuration:duration animations:^{
            toolBar.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - kScreenHeight);
            bgViewY = toolBar.frame.origin.y;
            
        }];
    }
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    CGFloat curkeyBoardHeight = [[[notif userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notif userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notif userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if (textIndex!=1) {
        if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
            [UIView animateWithDuration:0.1f animations:^{
                [toolBar setFrame:CGRectMake(0, kScreenHeight-(curkeyBoardHeight+toolBar.height+contentSize), kScreenWidth, toolBar.height+contentSize)];
                
            }];
        }
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    if (textIndex!=1) {
        [UIView animateWithDuration:0.1f animations:^{
            [toolBar setFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
            NSLog(@"***keyboardWasHidden*%@",toolBar);
        }];
    }
    
}



@end
