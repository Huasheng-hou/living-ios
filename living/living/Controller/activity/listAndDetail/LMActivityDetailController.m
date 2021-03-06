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
#import "HBShareView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "PlayerViewController.h"
#import "LMWriteReviewController.h"
//地图导航
#import "LMNavMapViewController.h"
#import "LMEventClassCodeController.h"



static CGRect oldframe;
@interface LMActivityDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
UITextViewDelegate,
LMActivityheadCellDelegate,
LMLeavemessagecellDelegate,
LMEventMsgCellDelegate,
LMActivityMsgCellDelegate,
shareTypeDelegate,
APChooseViewDelegate
>
{
    UIImageView * qrCode;
    NSString * voiceCode;
    NSString * tip;
    CGFloat resultPrice;
    
    
    UILabel  *tipLabel;
    UIButton *zanButton;
    UITextView *suggestTF;
    
    // * 顶部报名横幅
    LMActivityHeaderView *headerView;
    
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
    NSInteger  hiddenIndex;
    UIView *backgroundViews;
    UIImageView *imageViews;
    UIImage *bigImage;
    
    NSString *nameString;
    NSString *phoneString;
    NSString *telephoneString;
}

@end

@implementation LMActivityDetailController

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
    
    headerView = [[LMActivityHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    headerView.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    headerView.hidden           = YES;
    headerView.delegate         = self;
    
    [self.view addSubview:headerView];
    
    //二维码图标
    qrCode = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-60, 84, 40, 40)];
    qrCode.image = [UIImage imageNamed:@"qrcode"];
    qrCode.contentMode = UIViewContentModeScaleAspectFill;
    qrCode.backgroundColor = [UIColor clearColor];
    qrCode.clipsToBounds = YES;
    qrCode.layer.cornerRadius = 20;
    qrCode.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCode:)];
    [qrCode addGestureRecognizer:tap];
    [self.view addSubview:qrCode];
    
}
#pragma mark - 进入二维码界面
- (void)tapCode:(UITapGestureRecognizer *)tap {
    
    LMEventClassCodeController * codeVC = [[LMEventClassCodeController alloc] init];
    codeVC.navigationItem.title = @"活动二维码";
    codeVC.name = eventDic.eventName;
    codeVC.codeUrl = eventDic.eventCode;
    codeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codeVC animated:YES];
}
#pragma mark - 请求活动数据
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
        if (headDic[@"telphone"]&&![headDic[@"telphone"] isEqual:@"" ]) {
            telephoneString= headDic[@"telphone"];
        }
        
        if (headDic[@"phone"]&&![headDic[@"phone"] isEqual:@"" ]) {
            phoneString = headDic[@"phone"];
        }
        
        if (headDic[@"name"]&&![headDic[@"name"] isEqual:@"" ]) {
            nameString = headDic[@"name"];
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
        
        if (msgArray&&msgArray.count>0) {
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+10);
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
        
        eventDic    = [[LMEventBodyVO alloc] initWithDictionary:bodyDic[@"event_body"]];
        orderDic    = [bodyDic objectForKey:@"event_body"];
        
        if (eventDic.status == 3) {
            
            status = @"结束";
        }
        if (eventDic.status == 4) {
            
            status = @"总结";
        }
        if (eventDic.status == 1 || eventDic.status==2) {
            status = @"开始";
        }
        
        if ([eventDic.userUuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
            
            if ([status isEqualToString:@"总结"]) {
                rightItem  = [[UIBarButtonItem alloc] initWithTitle:@"总结" style:UIBarButtonItemStylePlain target:self action:@selector(review)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
            
            if ([status isEqual:@"开始"]) {
                rightItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(startActivity)];
                self.navigationItem.rightBarButtonItem = rightItem;
                
            }
            
            if ([status isEqual:@"结束"]) {
                
                
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
#pragma mark - 编写活动回顾
- (void)review{
    
    LMWriteReviewController * reviewVC = [[LMWriteReviewController alloc] init];
    reviewVC.eventUuid = eventDic.eventUuid;
    reviewVC.eventName = eventDic.eventName;
    
    [self.navigationController pushViewController:reviewVC animated:YES];
    
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60+kScreenWidth*3/5;
    }
    if (indexPath.section==1) {
        
        if (!eventDic.latitude||[eventDic.latitude isEqual:@""] ||[eventDic.latitude intValue] ==0) {
            CGFloat _cellHight;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            _cellHight = [eventDic.address boundingRectWithSize:CGSizeMake(kScreenWidth-59, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            return 180;
        }else{
            CGFloat _cellHight;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            _cellHight = [eventDic.address boundingRectWithSize:CGSizeMake(kScreenWidth-59, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            return 150+200;
        }
        

    }
    
    if (indexPath.section==2) {
        
        if (eventArray.count > indexPath.row) {
            
            LMProjectBodyVO *list = eventArray[indexPath.row];
            
            if (list && [list isKindOfClass:[LMProjectBodyVO class]]) {
                NSString *string = list.projectTitle;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
                CGFloat conHigh = [string boundingRectWithSize:CGSizeMake(kScreenWidth-30, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                CGFloat videoHight = 0;
                if (list.coverUrl&&![list.coverUrl isEqual:@""]) {
                    videoHight =list.coverHeight*(kScreenWidth-30)/list.coverWidth+20;
                }
                
                if (list.projectImgs ==nil||!list.projectImgs||[list.projectImgs isEqual:@""]) {
                    if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                        return 30 + conHigh +videoHight;
                    }else{
                        return 50 + conHigh + [LMEventMsgCell cellHigth:list.projectDsp] +videoHight;
                    }
                    
                } else {
                    if (list.projectDsp ==nil||!list.projectDsp||[list.projectDsp isEqual:@""]) {
                        return list.height*(kScreenWidth-30)/list.width + conHigh+30 +videoHight;
                    }else{
                        return list.height*(kScreenWidth-30)/list.width + conHigh + [LMEventMsgCell cellHigth:list.projectDsp]+50 +videoHight;
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
    
    if (section == 3) {
        
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
        suggestTF.returnKeyType = UIReturnKeySend;
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
        
        LMActivityheadCell *cell = [[LMActivityheadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = 1;
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

#pragma mark - 拨打电话

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

#pragma mark - 跳转到地图

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

#pragma mark - LMLeavemessagecell delegate -点赞
- (void)cellWillComment:(LMLeavemessagecell *)cell
{

    if ([[FitUserManager sharedUserManager] isLogin]){

        if (![CheckUtils isLink]) {
            
            [self textStateHUD:@"无网络"];
            return;
        }
        
        LMEventCommentVO *list = msgArray[cell.tag];
        
        
        LMEventpraiseRequest *request = [[LMEventpraiseRequest alloc] initWithEvent_uuid:_eventUuid CommentUUid:list.commentUuid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       NSDictionary *bodyDic = [VOUtil parseBody:resp];
                                                       [self logoutAction:resp];
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
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];

    } else {
        
        [self IsLoginIn];
    }
}

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

#pragma mark - 评论
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
    NSString *string    = [commentText.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    LMEventCommitReplyRequset *request = [[LMEventCommitReplyRequset alloc] initWithEvent_uuid:_eventUuid CommentUUid:commitUUid Reply_content:string];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getEventcommitResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
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

- (void)APChooseViewClose{
    if (headerView.hidden == YES) {
        self.navigationController.navigationBar.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
}

- (void)cellWillApply:(LMActivityheadCell *)cell
{
    
    if ([[FitUserManager sharedUserManager] isLogin]){
        self.navigationController.navigationBar.hidden = YES;
        
        APChooseView *infoView = [[APChooseView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        infoView.delegate = self;
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
            
            CGFloat totalPrice = [eventDic.perCost floatValue];
            CGFloat nowPrice = [eventDic.discount floatValue];
            resultPrice = totalPrice - nowPrice;
            if (resultPrice > (NSInteger)resultPrice) {
                tip = [NSString stringWithFormat:@"会员就是任性,立减%.2f元", resultPrice];
            }else {
                tip = [NSString stringWithFormat:@"会员就是任性,立减%.f元", resultPrice];
            }
            infoView.tipLabel.text = tip;

            
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
        if (eventDic.notices==nil) {
            infoView.dspLabel.text = @"暂无报名须知";
        }else{
            infoView.dspLabel.text = eventDic.notices;
        }
       
        
//        infoView.inventory.text = [NSString stringWithFormat:@"活动人数：%d/%d人",eventDic.totalNumber, eventDic.totalNum];
        
        [infoView.productImage sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
        
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

- (void)APChooseViewSelectItem:(NSInteger)num
{
    resultPrice *= num;
    if (phoneString&&![phoneString isEqualToString:@""]) {
        if (![CheckUtils isLink]) {
            
            [self textStateHUD:@"无网络"];
            return;
        }
        
        [self initStateHud];
        
        
        NSString *nums = [NSString stringWithFormat:@"%ld",(long)num];
        
        LMEventJoinRequest *request = [[LMEventJoinRequest alloc] initWithEvent_uuid:_eventUuid order_nums:nums name:nameString phone:phoneString];
        
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getEventjoinDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }else{
        if (telephoneString&&![telephoneString isEqual:@""]) {
            NSString *nums = [NSString stringWithFormat:@"%ld",(long)num];
            
            LMEventJoinRequest *request = [[LMEventJoinRequest alloc] initWithEvent_uuid:_eventUuid order_nums:nums name:nameString phone:telephoneString];
            
            HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                                   completed:^(NSString *resp, NSStringEncoding encoding) {
                                                       
                                                       [self performSelectorOnMainThread:@selector(getEventjoinDataResponse:)
                                                                              withObject:resp
                                                                           waitUntilDone:YES];
                                                   } failed:^(NSError *error) {
                                                       
                                                       [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                              withObject:@"网络错误"
                                                                           waitUntilDone:YES];
                                                   }];
            [proxy start];
        }else{
         
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入个人信息" preferredStyle:UIAlertControllerStyleAlert];
            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取第1个输入框；
                nameString = alertController.textFields.firstObject.text;
                
                telephoneString = alertController.textFields.lastObject.text;
                
                NSString *nums = [NSString stringWithFormat:@"%ld",(long)num];
                
                LMEventJoinRequest *request = [[LMEventJoinRequest alloc] initWithEvent_uuid:_eventUuid order_nums:nums name:nameString phone:telephoneString];
                
                HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                                       completed:^(NSString *resp, NSStringEncoding encoding) {
                                                           
                                                           [self performSelectorOnMainThread:@selector(getEventjoinDataResponse:)
                                                                                  withObject:resp
                                                                               waitUntilDone:YES];
                                                       } failed:^(NSError *error) {
                                                           
                                                           [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                                  withObject:@"网络错误"
                                                                               waitUntilDone:YES];
                                                       }];
                [proxy start];
                
                
            }]];
            
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入真实姓名";
            }];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入手机号";
            }];

            
            [self presentViewController:alertController animated:true completion:nil];
        }
    }


}

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
            NSLog(@"--------%@", orderID);
            OrderVC.dict        = orderDic;
        
            if (resultPrice > (NSInteger)resultPrice) {
                OrderVC.tips = [NSString stringWithFormat:@"会员就是任性,立减%.2f元", resultPrice];
            }else {
                OrderVC.tips = [NSString stringWithFormat:@"会员就是任性,立减%.f元", resultPrice];
            }
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

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        tipLabel.hidden=NO;
    } else {
        
        tipLabel.hidden=YES;
    }
}

//修改textView return键

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        if ([textView isEqual:suggestTF]) {
            
            [suggestTF resignFirstResponder];
            [self besureAction:@""];
        }
        if ([textView isEqual:commentText]) {
            
            [commentText resignFirstResponder];
            self.tableView.userInteractionEnabled = YES;
            [self sendComment];
        }
    }
    
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
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > 220) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        self.navigationController.navigationBar.hidden=YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        headerView.hidden=NO;
        qrCode.hidden = YES;
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
        qrCode.hidden = NO;
    }
}

#pragma mark  - 活动留言或评论

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
        
        NSString *string    = [suggestTF.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        LMEventLivingMsgRequest *request = [[LMEventLivingMsgRequest alloc] initWithEvent_uuid:_eventUuid Commentcontent:string];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getEventLivingmsgDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];

    }else{
        [self IsLoginIn];
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



- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

#pragma mark - 删除活动  LMActivityDeleteRequest

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
                                                                      withObject:@"删除失败"
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

#pragma mark - 删除评论

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

#pragma mark - 活动大图

- (void)cellClickImage:(LMActivityheadCell *)cell
{
    if (cell.imageV.image) {
        bigImage =cell.imageV.image;
      [self showImage:cell.imageV];
        
    }else{
        return;
    }
    
}

#pragma mark -- 项目大图

- (void)cellProjectImage:(LMEventMsgCell *)cell
{
    NSMutableArray *array = [NSMutableArray new];
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageArray delegate:self];
    
    for (int i = 0; i<cell.tag+1; i++) {
        
        LMProjectBodyVO *vo = eventArray[i];
        
        if (!vo.projectImgs||[vo.projectImgs isEqual:@""]) {

            [array addObject:@""];
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

#pragma mark  - 开始活动

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

#pragma mark   - 结束活动

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
                                                [self endEvent];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)endEvent{
    
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

#pragma mark - 活动举报按钮
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

- (void)cellShareImage:(LMActivityheadCell *)cell
{
    HBShareView *shareView=[[HBShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.delegate=self;
    shareView.titleLabel.text = @"分享活动";
    [self.view addSubview:shareView];
}

#pragma mark = 对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 分享
- (void)shareType:(NSInteger)type
{
    NSString *urlString = [NSString stringWithFormat:ACTIVITY_SHARE_LINK_QQ, _eventUuid];

    switch (type) {
        case 1://微信好友
        {
            urlString = [NSString stringWithFormat:ACTIVITY_SHARE_LINK_WECHAT, _eventUuid];
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=eventDic.eventName;
            message.description=eventDic.notices;
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
            web.webpageUrl = urlString;
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
            urlString = [NSString stringWithFormat:ACTIVITY_SHARE_LINK_WECHAT, _eventUuid];
            WXMediaMessage *message=[WXMediaMessage message];
            message.title=eventDic.eventName;
            message.description=eventDic.notices;
            
            
            if (imageArray.count==0) {
                [message setThumbImage:[UIImage imageNamed:@"editMsg"]];
            }else{
                
                UIImageView *images = [UIImageView new];
                [images sd_setImageWithURL:[NSURL URLWithString:eventDic.eventImg]];
                
                UIImage *iconImage=[self imageWithImage:images.image scaledToSize:CGSizeMake(kScreenWidth/3, kScreenWidth/3)];
                [message setThumbImage:iconImage];
            }
            
            WXWebpageObject *web=[WXWebpageObject object];
            web.webpageUrl=urlString;
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
                
                imageUrl=eventDic.eventImg;
            }
            
            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:eventDic.eventName description:nil previewImageURL:[NSURL URLWithString:imageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到qq
            [QQApiInterface sendReq:req];
        }
            break;
        case 4://qq空间
        {
            NSString *imageUrl;
            if (imageArray.count==0) {
                imageUrl=@"http://living-2016.oss-cn-hangzhou.aliyuncs.com/1eac8bd3b16fd9bb1a3323f43b336bd7.jpg";
            }else{
                imageUrl=eventDic.eventImg;
            }
            
            QQApiNewsObject *txtObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:eventDic.eventName description:nil previewImageURL:[NSURL URLWithString:imageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
            //将内容分享到qq空间
            [QQApiInterface SendReqToQZone:req];
        }
            break;
        default:
            break;
    }
}

-(void)cellProjectVideo:(LMEventMsgCell *)cell
{
    NSString *string = [NSString new];
    for (LMProjectBodyVO *vo in eventArray) {
        if (vo.videoUrl&&![vo.videoUrl isEqual:@""]) {
            string = vo.videoUrl;
        }
    }

    if (string&&![string isEqual:@""]) {
        PlayerViewController *playVC=[[PlayerViewController alloc]initWithVideoUrl:string];
        [self presentViewController:playVC animated:NO completion:^{
        }];
        
    }else{
        [self textStateHUD:@"未获取视频文件~"];
    }
}


@end
