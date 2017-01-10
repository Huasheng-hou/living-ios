//
//  MainViewController.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "LMChatViewController.h"
#import "CustomToolbar.h"
#import "KeyBoardAssistView.h"
#import "MoreFunctionView.h"
#import "ChattingCell.h"
#import "LMChatRecordsRequest.h"
#import "WebsocketStompKit.h"
#import "MssageVO.h"
#import "LMVoiceQuestionViewController.h"
#import "FirUploadImageRequest.h"
#import "ImageHelpTool.h"
#import "FirUploadVoiceRequest.h"
#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SYPhotoBrowser.h"
#import "LMChoosehostViewController.h"
#import "LMChangeHostRequest.h"
#import "LMShieldstudentRequest.h"
#import "LMVoiceEndRequest.h"
#import "LMCloseQuestionRequest.h"

#import "LGAudioKit.h"
#import "Masonry.h"
#import "LMVoiceChangeTextRequest.h"
#import "LMWobsocket.h"

#define assistViewHeight  200
#define toobarHeight 50
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@interface LMChatViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextViewDelegate,
selectItemDelegate,
assistViewSelectItemDelegate,
moreSelectItemDelegate,
STOMPClientDelegate,
ChattingCellDelegate,
LMhostchooseProtocol,
LMquestionchooseProtocol,
AVAudioPlayerDelegate,
UIToolbarDelegate,
AVAudioRecorderDelegate,
LGSoundRecorderDelegate,
LGAudioPlayerDelegate
>
{
    NSTimeInterval _visiableTime;
    
    CustomToolbar *toorbar;
    KeyBoardAssistView *assistView;
    MoreFunctionView *moreView;
    
    NSMutableArray *cellListArray;
    NSString *name;
    STOMPClient *client;
    NSString *avartar;
    NSString *currentIndex;
    BOOL ifloadMoreData;
    NSInteger reloadCount;
    AVAudioPlayer *player;
    NSMutableArray *imageArray;
    UIView *bootView;
    NSInteger roleIndex;
    NSInteger signIndex;
    UIBarButtonItem * rightItem;
    int duration;
    
    BOOL  isfirst;
    BOOL hasShield;
    BOOL isShieldReload;
    NSArray *titleArray;
    NSArray *iconArray;
    
    NSInteger hostId;
    NSInteger playIndex;
    LGVoicePlayState voicePlayState;
    NSMutableArray *listArray;
    NSMutableArray *messageArray;
    NSInteger playTag;
    NSString *_role;
    CGFloat toolBarChangeH;
    NSInteger stopTag;
    UIActivityIndicatorView *activity;
    UIView *headView;
    
    UIView *changeView;
    
}
@property (nonatomic, weak) NSTimer *timerOf60Second;

@end

@implementation LMChatViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        self.ifAddPullToRefreshControl      = NO;
        self.ifLoadReverse                  = YES;
        self.ifProcessLoadFirst             = YES;
        ifloadMoreData =YES;
        isfirst = YES;
        hasShield = NO;
        isShieldReload = NO;
        
        
        [self createWebSocket];
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    moreView.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [player stop];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    moreView.hidden = YES;
    
    [self extraBottomViewVisiable:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self botttomView];
    currentIndex = nil;
//    [self setupRefresh];
    [self loadNewer];
    listArray = [NSMutableArray new];
    messageArray = [NSMutableArray new];
    reloadCount =0;
    [LGAudioPlayer sharePlayer].delegate = self;
    toolBarChangeH=0;
    
    NSLog(@"***********%@",_voiceUuid);
}

#pragma mark 初始化视图静态界面
- (void)createUI
{
    self.title=@"语音教室";
    
    [super createUI];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight)];
    if ([_roles isEqualToString:@"student"]) {
        _role = @"student";
    }
    if ([_roles isEqualToString:@"host"]) {
        _role = @"host";
    }
    if ([_roles isEqualToString:@"teacher"]) {
        _role = @"teacher";
    }
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //导航栏右边按钮
    NSLog(@"*********************%@",_role);
    if (_role && [_role isKindOfClass:[NSString class]] && ![_role isEqualToString:@"student"]) {
        
        if ([_sign isEqualToString:@"1"]) {
        
            titleArray  = @[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
        } else {
            
            titleArray  = @[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
        }
        
        roleIndex   = 2;
        iconArray   = @[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
    }
    
    if (_role && [_role isKindOfClass:[NSString class]] && [_role isEqualToString:@"student"]){
        
        titleArray  = @[@"屏蔽",@"问题"];
        roleIndex   = 1;
        iconArray   = @[@"moreShieldIcon",@"moreQuestionIcon"];
    }
    
    [self addrightItem];
}

-(void)backAction
{
    
    [client disconnect];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addrightItem
{
    rightItem   = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navRightIcon"]
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(functionAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    moreView=[[MoreFunctionView alloc]initWithContentArray:titleArray andImageArray:iconArray];
    moreView.delegate=self;
    [moreView setHidden:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}


- (FitBaseRequest *)request
{
    
    LMChatRecordsRequest    *request    = [[LMChatRecordsRequest alloc] initWithPageIndex:currentIndex andPageSize:10 voice_uuid:_voiceUuid];
    return request;
}

#pragma mark --屏蔽学员

- (void)getShieldstudentData
{
    NSMutableArray *shieldArray = [NSMutableArray new];
    [listArray addObjectsFromArray:self.listData];
    for (MssageVO *vo in self.listData) {
        
        NSLog(@"*****************%@",vo.role);
        if (vo.role &&![vo.role isEqualToString:@"student"]) {
            [shieldArray addObject:vo];
        }
    }
    reloadCount=1;
    
    [self.listData removeAllObjects];
    [self.listData addObjectsFromArray:shieldArray];
    [self reLoadTableViewCell];
    

}


- (NSArray *)parseResponse:(NSString *)resp
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
        
        if (headDic[@"nick_name"]&&![headDic[@"nick_name"] isEqual:@""]) {
            name = headDic[@"nick_name"];
        }
        if (headDic[@"avatar"]&&![headDic[@"avatar"] isEqual:@""]) {
            avartar = headDic[@"avatar"];
        }
    }
    
    NSString    *result = [bodyDic objectForKey:@"result"];
    NSString    *total  = [bodyDic objectForKey:@"count"];
    
    self.max = ceil([total floatValue] / 10) - 1;
    imageArray = [NSMutableArray new];
    
    if (result && [result isEqualToString:@"0"]) {
        
        NSArray *tempArr    = [MssageVO MssageVOListWithArray:[bodyDic objectForKey:@"list"]];
        
        if (tempArr.count > 0) {
            MssageVO   *vo     = [tempArr objectAtIndex:0];
            NSLog(@"**********==========*******%d",[currentIndex intValue] - [vo.currentIndex intValue]);
            NSLog(@"%@>>>>>>>>>>",currentIndex);
            NSLog(@"%@^^^^^^^^^^^^",vo.currentIndex);
            NSLog(@"******    ******* %@",total);
            if ([total intValue]<10) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ifloadMoreData =NO;
                });
                
            }else if([currentIndex intValue] !=[vo.currentIndex intValue]){
                currentIndex = [NSString stringWithFormat:@"%d",[vo.currentIndex intValue]];
                NSLog(@"***********%@",currentIndex);
                reloadCount = reloadCount+1;
                [activity stopAnimating];
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self textStateHUD:@"没有更多消息~"];
                [activity stopAnimating];
            });
        }
        
        return tempArr;
    }
    return nil;
    
}

- (void)firstPageLoadedProcess
{
    [self scrollTableToFoot:NO];
}

#pragma mark 初始化自定义工具条及附加功能视图（选择照片及提问）
- (void)botttomView
{
    if ([_role isEqualToString:@"student"]) {
        if (_sign&&[_sign isEqualToString:@"1"]) {
            [self creatToolbarView];
            bootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-toobarHeight, kScreenWidth, toobarHeight)];
            bootView.backgroundColor = [UIColor whiteColor];
            UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, toobarHeight)];
            textLable.text = @"已禁言";
            textLable.font = TEXT_FONT_LEVEL_2;
            textLable.textAlignment = NSTextAlignmentCenter;
            textLable.textColor = LIVING_COLOR;
            [bootView addSubview:textLable];
            [self.view addSubview:bootView];
        }
        if (_sign&&[_sign isEqualToString:@"2"]){
            [self creatToolbarView];
        }
        
    }else{
        [self creatToolbarView];
        
    }
    
}

- (void)creatToolbarView
{
    toorbar=[[CustomToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-toobarHeight, kScreenWidth, toobarHeight)];
    toorbar.backgroundColor = BG_GRAY_COLOR;
    toorbar.inputTextView.delegate = self;
    [toorbar setDelegate:self];
    [self.view addSubview:toorbar];
    
    assistView=[[KeyBoardAssistView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    assistView.delegate=self;
    [self.view addSubview:assistView];
}

#pragma mark 导航栏右边按钮执行方法
-(void)functionAction
{
    [moreView setHidden:NO];
}

#pragma mark 导航栏右边按钮的子按钮执行方法
-(void)moreViewSelectItem:(NSInteger)item
{
    
    if (roleIndex == 1) {
        if (item == 0) {
            NSString *tipString;
            if (hasShield == NO) {
                tipString = @"是否屏蔽该课程学员发言";
                isShieldReload =NO;
            }else{
                tipString = @"是否取消屏蔽";
                isShieldReload =YES;
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipString
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction*action) {
                                                        
                                                        
                                                        if (hasShield == NO &&isShieldReload ==NO) {
                                                            
                                                            [self getShieldstudentData];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                titleArray=@[@"已屏蔽",@"问题"];
                                                            iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                                                                [self addrightItem];
                                                                
                                                                hasShield = YES;
                                                            });
                                                            
                                                        }
                                                        
                                                        if (hasShield == YES &&isShieldReload ==YES){
                                                        
                                                            [self.listData removeAllObjects];
                                                            [self.listData addObjectsFromArray:listArray];
                                                            listArray = [NSMutableArray new];
                                                            [self reLoadTableViewCell];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                titleArray=@[@"屏蔽",@"问题"];
                                                                iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                                                                [self addrightItem];
                                                                
                                                                hasShield = NO;
                                                            });
                                                        }
                                                        
                                                    }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        if (item == 1) {
            LMVoiceQuestionViewController *questVC = [[LMVoiceQuestionViewController alloc] init];
            questVC.hidesBottomBarWhenPushed = YES;
            questVC.voiceUUid = _voiceUuid;
            questVC.roleIndex = @"1";
            questVC.delegate = self;
            [self.navigationController pushViewController:questVC animated:YES];
        }
        
        
    }
    if (roleIndex == 2) {
        
        //禁言
        if (item == 0) {
            
            if (_sign&&[_sign isEqualToString:@"1"]) {
                NSDictionary *dics = @{@"type":@"gag",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"sign":@"2"};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
            }
            
            if (_sign&&[_sign isEqualToString:@"2"]) {
                NSDictionary *dics = @{@"type":@"gag",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"sign":@"1"};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
            }
            
        }
        //问题列表
        if (item == 1) {
            LMVoiceQuestionViewController *questVC = [[LMVoiceQuestionViewController alloc] init];
            questVC.hidesBottomBarWhenPushed = YES;
            questVC.voiceUUid = _voiceUuid;
            questVC.roleIndex = @"2";
            questVC.delegate = self;
            [self.navigationController pushViewController:questVC animated:YES];
        }
        //屏蔽
        if (item == 2) {
            NSString *tipString;
            if (hasShield == NO) {
                tipString = @"是否屏蔽该课程学员发言";
                isShieldReload =NO;
            }else{
                tipString = @"是否取消屏蔽";
                isShieldReload =YES;
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipString
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction*action) {
                                                        
                                                        if (hasShield == NO) {
                                                            [self getShieldstudentData];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                titleArray=@[@"禁言",@"问题",@"已屏蔽",@"主持",@"关闭"];
                                                                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                                                                [self addrightItem];
                                                                hasShield = YES;
                                                                
                                                            });
                                                            
                                                        }
                                                        if (hasShield == YES&&isShieldReload ==YES) {
                                                            [self.listData removeAllObjects];
                                                            [self.listData addObjectsFromArray:listArray];
                                                            [self reLoadTableViewCell];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                                                                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                                                                [self addrightItem];
                                                                
                                                                hasShield =NO;
                                                            });
                                                        }
                                                        
                                                    }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        //选择主持人
        
        if (item == 3) {
            LMChoosehostViewController    *typeVC     = [[LMChoosehostViewController alloc] init];
            typeVC.delegate     = self;
            
            [self.navigationController pushViewController:typeVC animated:YES];
        }
        
        if (item == 4) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否结束课程"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction*action) {
                                                        [self endVoiceAction];
                                                        
                                                    }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

-(void)endVoiceAction{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    LMVoiceEndRequest *request = [[LMVoiceEndRequest alloc] initWithVoice_uuid:_voiceUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getendEventResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getendEventResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    [self logoutAction:resp];
    if (!bodyDic) {
        [self textStateHUD:@"课程结束失败请重试"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"课程结束成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload"
                 
                                                                    object:nil];
            });
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

#pragma mark -- 选择主持人代理
- (void)backhostName:(NSString *)liveRoom andId:(NSInteger)userId
{
    hostId = userId;

    LMChangeHostRequest *request = [[LMChangeHostRequest alloc] initWithUserId:hostId voice_uuid:_voiceUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getChangeHostResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)getChangeHostResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    [self logoutAction:resp];
    
    if (!bodyDic) {
    
        [self textStateHUD:@"更换主持人失败！"];
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"更换主持人成功！"];
            
            NSDictionary *dics = @{@"type":@"host",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"userId":[NSString stringWithFormat:@"%ld",(long)hostId]};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
            NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
            
            NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
            [client sendTo:urlStr body:string];
   
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MssageVO *vo = self.listData[indexPath.row];
    
    if (vo.type && ([vo.type isEqual:@"chat"] || [vo.type isEqual:@"question"])) {
        
        NSString *contentStr=vo.content;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
        
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-85, MAXFLOAT)                                           options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        if ([vo.type isEqual:@"question"]) {
            return contenSize.height+55+10+20;
        }else{
            return contenSize.height+55+10;
        }
        
    }
    
    if (vo.type && [vo.type isEqual:@"picture"]) {
        
        return 150+55+10;
    }
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        if (vo.ifchangeText ==YES) {
            return 180;
        }else{
          return 55+30+10;
        }
        
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChattingCell *cell=[ChattingCell cellWithTableView:tableView];
    
    MssageVO *vo = self.listData[indexPath.row];
    [cell setCellValue:vo role:_role];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    size.height -= 2;
    
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 34 ) {
        
        size.height = 34;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toorbar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toorbar.frame = frame;
        NSLog(@"****************************%f",toorbar.frame.size.height);
        toolBarChangeH = toorbar.frame.size.height;
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
        frame = self.tableView.frame;
        frame.size.height -= span;
        self.tableView.frame = frame;
    }
    
    [self scrollTableToFoot:YES];
}

#pragma mark 输入完成后发送消息，（数组中添加数据并重新加载cell）
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length == 0 || [textView.text isEqual:@""]) {
            
            [self textStateHUD:@"请输入文字"];
            return NO;
        } else {
            if (client.connected==YES) {

            if (textView.text.length>5&&[[textView.text substringToIndex:5] isEqualToString:@"#问题# "]) {
                NSString *strings  = [toorbar.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings ,@"has_profile":@"false"};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
                [self textStateHUD:@"问题提交成功~"];
                
                toorbar.inputTextView.text=@"";
            } else {
                
                NSString *strings  = [toorbar.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dics = @{@"type":@"chat",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
                
                toorbar.inputTextView.text=@"";
            }
            }else{
                [self textStateHUD:@"发送失败~"];
            }
            
            [self reLoadTableViewCell];
            
            return NO;
        }
    }
    return YES;
}

#pragma mark 重新加载cell，并让cell自动滑到最底端
-(void)reLoadTableViewCell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [self scrollTableToFoot:YES];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    moreView.hidden = YES;
    [changeView removeFromSuperview];
    NSTimeInterval timeValue;
    
    if (_visiableTime) {
        
        timeValue = _visiableTime;
    } else {
        
        timeValue=0.2f;
    }
    
    [UIView animateWithDuration:timeValue animations:^{
    
        if (toolBarChangeH>50) {
            self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
            
            [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
            [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        }else{
            self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
            
            [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
            [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        }

    }];
}

#pragma mark 语音说话及加号的执行方法（语音收缩、增加展示）

- (void)selectItem:(NSInteger)item
{
    [self.view endEditing:YES];
    
    switch (item) {
            
        case 0://语音
        {
            [self extraBottomViewVisiable:NO];
            
        }
            break;
            
        case 1://增加
        {
            [self extraBottomViewVisiable:YES];
        }
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark 选择照片及提问的执行方法
- (void)assistViewSelectItem:(NSInteger)item
{
    if (item == 1) {//照片
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalTransitionStyle = UIModalPresentationCustom;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    
    if (item == 2) {//提问
        
        toorbar.inputTextView.text = @"#问题# ";
        [toorbar.inputTextView becomeFirstResponder];
    }
}

#pragma mark 选择照片后添加数组 重新加载cell
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self getImageURL:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];
    request.imageData   = UIImageJPEGRepresentation(image, 1);
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                       //                                                       _imgURL=imgUrl;
                                                       NSLog(@"%@",imgUrl);
                                                       
                                                       NSDictionary *dics = @{@"type":@"picture",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl};
                                                       
                                                       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                                                       NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                                                       NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                                                       if (client.connected ==YES) {
                                                           [client sendTo:urlStr body:string];
                                                           
                                                       }else{
                                                           dispatch_async(dispatch_get_main_queue()
                                                                          , ^{
                                                                              [self textStateHUD:@"发送失败~"];
                                                                          });
                                                           
                                                       }
                                                       
                                                       
                                                       [self reLoadTableViewCell];
                                                       
                                                       
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

#pragma mark 确定执行方法

- (void)saveUserInfoResponse:(NSString *)resp
{
    NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
    
    if (!bodyDict)
    {
        [self textStateHUD:@"保存失败"];
        return;
    }
    
    if (bodyDict && [bodyDict objectForKey:@"result"]
        && [[bodyDict objectForKey:@"result"] isKindOfClass:[NSString class]])
    {
        if ([[bodyDict objectForKey:@"result"] isEqualToString:@"0"]){
            
            [self textStateHUD:@"保存成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else{
            [self textStateHUD:[bodyDict objectForKey:@"description"]];
        }
    }
}

#pragma mark 附加功能（选择照片，提问）展示或者收缩
- (void)extraBottomViewVisiable:(BOOL)state
{
    moreView.hidden = YES;
    toorbar.inputTextView.text = @"";
    NSTimeInterval timeValue;
    if (_visiableTime) {
        timeValue=_visiableTime;
    }else{
        timeValue=0.2f;
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        if (state) {
        
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight-assistViewHeight);
                [self scrollTableToFoot:YES];
                if (toolBarChangeH>50) {
                    [toorbar setFrame:CGRectMake(0, kScreenHeight-assistViewHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
                }else{
                    [toorbar setFrame:CGRectMake(0, kScreenHeight-assistViewHeight-toobarHeight,kScreenWidth, toobarHeight)];
                }
                
                [assistView setFrame:CGRectMake(0, kScreenHeight-assistViewHeight, kScreenWidth, assistViewHeight)];
            } ];
            
        } else {
            
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
                [self scrollTableToFoot:YES];
                if (toolBarChangeH>50) {
                    [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
                }else{
                    [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
                }
                
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            }];
        }
//    });
}

#pragma mark Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification
{
    moreView.hidden = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _visiableTime=animationDuration;
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
            
            if (toolBarChangeH>50) {
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH-keyboardRect.size.height, kScreenWidth, toolBarChangeH)];
            }else{
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight-keyboardRect.size.height, kScreenWidth, toobarHeight)];
            }
            

            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyboardRect.size.height - toobarHeight);
            
            [assistView setFrame:CGRectMake(0, kScreenHeight-keyboardRect.size.height, kScreenWidth, assistViewHeight)];
            [self scrollTableToFoot:YES];
        }];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _visiableTime=animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        if (toolBarChangeH>50) {
            [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
            [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            self.tableView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toolBarChangeH);
        }else{
            [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
            [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            self.tableView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toobarHeight);
        }

    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

#pragma mark   滚动表格到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s < 1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    
    if (r < 1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark -- 获取websocket数据

- (void)createWebSocket
{
    
//    client=[[STOMPClient alloc]initWithURL:websocketUrl webSocketHeaders:nil useHeartbeat:NO];
    
    client = [LMWobsocket shareWebsocket];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(websocketConnect) userInfo:nil repeats:YES];
    
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Cookie",@"session=random", nil];
    
    [client connectWithHeaders:dict completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
        if (error) {
            NSLog(@"================连接失败=============%@", error);
            return;
        }
        if (client.connected == NO) {
            [self textStateHUD:@"连接失败，请返回主页后重试~"];
            NSLog(@"连接失败，请返回主页后重试~");
        }
        
        NSString *string = [NSString stringWithFormat:@"/topic/room/%@",_voiceUuid];
        
        [client subscribeTo:string messageHandler:^(STOMPMessage *message) {
            NSLog(@"=========topic/greetings===订阅消息=============%@",message.body);
            NSString *resp = [NSString stringWithFormat:@"%@",message.body];
            
            NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSDictionary *respDict = [NSJSONSerialization
                                      JSONObjectWithData:respData
                                      options:NSJSONReadingMutableLeaves
                                      error:nil];
            
            MssageVO *vo = [MssageVO MssageVOWithDictionary:respDict];
            
            if (vo.type&&([vo.type isEqual:@"chat"]||[vo.type isEqual:@"question"])) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                NSMutableArray *array = [NSMutableArray new];
                NSString *content = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [dic setObject:content forKey:@"content"];
                [dic setObject:vo.time forKey:@"time"];
                [dic setObject:vo.name forKey:@"name"];
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
                [dic setObject:vo.role forKey:@"role"];

                if ([vo.type isEqual:@"question"]) {
                    [dic setObject:@"question" forKey:@"type"];
                    if (vo.questionUuid&&![vo.questionUuid isEqualToString:@""]) {
                       [dic setObject:vo.questionUuid forKey:@"question_uuid"];
                    }
                }else{
                    [dic setObject:@"chat" forKey:@"type"];
                }
                [array addObject:dic];
                NSArray *array2 = [MssageVO MssageVOListWithArray:array];
                if ([vo.type isEqual:@"chat"]) {
                    if (hasShield==NO) {
                        [self.listData addObjectsFromArray:array2];
                    }else{
                        if (vo.role&&![vo.role isEqualToString:@"student"]) {
                           [self.listData addObjectsFromArray:array2];
                        }else{
                           [listArray addObjectsFromArray:array2];
                        }
                        
                    }
                    
                }else{
                    if (vo.questionUuid&&![vo.questionUuid isEqualToString:@""]) {

                        if (![vo.role isEqualToString:@"student"]) {
                            [listArray addObjectsFromArray:array2];
                            [self.listData addObjectsFromArray:array2];
                        }
                    }else{
                        [self textStateHUD:@"问题提交成功~"];
                    }
                }
                
            }
            
            if (vo.type&&([vo.type isEqual:@"picture"]||[vo.type isEqual:@"voice"])) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                NSMutableArray *array = [NSMutableArray new];
                
                if ([vo.type isEqual:@"voice"]) {
                    [dic setObject:vo.attachment forKey:@"voiceurl"];
                    [dic setObject:@"voice" forKey:@"type"];
                    [dic setObject:vo.recordingTime forKey:@"recordingTime"];
                    if (vo.transcodingUrl&&![vo.transcodingUrl isEqualToString:@""]) {
                        [dic setObject:vo.transcodingUrl forKey:@"transcodingUrl"];
                        [dic setObject:vo.currentIndex forKey:@"currentIndex"];
                    }
                    
                    if ([vo.user_uuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
                        NSMutableArray *statusArray = [NSMutableArray new];
                        NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readStatus"];
                        [statusArray addObjectsFromArray:palyArray];
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        [dic setObject:vo.attachment forKey:@"url"];
                        [dic setObject:@"1" forKey:@"status"];
                        if (![statusArray containsObject:dic]) {
                            [statusArray addObject:dic];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:statusArray forKey:@"readStatus"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }  
                    
                }
                if ([vo.type isEqual:@"picture"]) {
                    
                    if (vo.attachment) {
                      [dic setObject:vo.attachment forKey:@"imageurl"];
                    }
                    
                    [dic setObject:@"picture" forKey:@"type"];
                }
                [dic setObject:vo.time forKey:@"time"];
                [dic setObject:vo.name forKey:@"name"];
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
                [dic setObject:vo.role forKey:@"role"];
                [array addObject:dic];
                NSArray *array2 = [MssageVO MssageVOListWithArray:array];
                
                if (hasShield==NO) {
                    [self.listData addObjectsFromArray:array2];
                }else{
                    if (vo.role&&![vo.role isEqualToString:@"student"]) {
                        [self.listData addObjectsFromArray:array2];
                    }else{
                        [listArray addObjectsFromArray:array2];
                    }
                }
                
            }
            
            if (vo.type&&[vo.type isEqual:@"host"]) {
 
                if (_role&&![_role isEqualToString:@"student"]) {
                    
                    if ([_sign isEqualToString:@"1"]) {
                        titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }else{
                        titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }
                    
                    roleIndex = 2;
                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [bootView removeFromSuperview];
                }
                if (_role&&[_role isEqualToString:@"student"]){
                    
                    if ([[FitUserManager sharedUserManager].uuid isEqualToString:vo.host_uuid]) {
                        if ([_sign isEqualToString:@"1"]) {
                            titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                        }else{
                            titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                        }
                        
                        roleIndex = 2;
                        iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                        [bootView removeFromSuperview];
                    }else{
                        titleArray=@[@"屏蔽",@"问题"];
                        roleIndex = 1;
                        iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                    }
                    
 
                    
                }
                [self addrightItem];
            }
            
            if (vo.type&&[vo.sign isEqual:@"1"]&&[vo.type isEqualToString:@"gag"]) {
                
                [self textStateHUD:@"已禁言"];
                
                if ([_role isEqual:@"student"]) {
                    
                    [moreView removeFromSuperview];
                    
                    titleArray=@[@"屏蔽",@"问题"];
                    iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                    [self addrightItem];
                    
                    bootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-toobarHeight, kScreenWidth, toobarHeight)];
                    bootView.backgroundColor = [UIColor whiteColor];
                    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, toobarHeight)];
                    textLable.text = @"已禁言";
                    textLable.font = TEXT_FONT_LEVEL_2;
                    textLable.textAlignment = NSTextAlignmentCenter;
                    textLable.textColor = LIVING_COLOR;
                    [bootView addSubview:textLable];
                    [self.view addSubview:bootView];
                    _sign = @"1";
                }else{
                    [moreView removeFromSuperview];
                    
                    titleArray=@[@"已禁言",@"问题",@"已屏蔽",@"主持",@"关闭"];
                    iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [self addrightItem];
                    
                    _sign = @"1";
                }
                
            }
            if (vo.type&&([vo.sign isEqual:@"2"]&&[vo.type isEqualToString:@"gag"])) {
                
                [self textStateHUD:@"禁言解除"];
                if ([_role isEqual:@"student"]) {
                    
                    [moreView removeFromSuperview];
                    
                    titleArray=@[@"屏蔽",@"问题"];
                    iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                    [self addrightItem];
                    [bootView removeFromSuperview];
                    _sign = @"2";
                }else{
                    [moreView removeFromSuperview];
                    titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [self addrightItem];
                    _sign = @"2";
                }
            }
            [self reLoadTableViewCell];
            
        }];
        
    }];
    
    if (client.connected==NO) {
        
//        [self textStateHUD:@"连接失败，请返回主页后重试~"];
        NSLog(@"&*&*^&^&^^&^&^未连接");
    }
    
    
}

- (void)websocketConnect
{
    if (client.connected ==NO) {
        NSLog(@"连接失败");
        
        
    }else{
        NSLog(@"连接成功");
    }
}

#pragma mark ---下拉加载数据

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [changeView removeFromSuperview];
    if (!self.ifLoadReverse) {
        if (fabs(self.tableView.contentSize.height - (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame))) < 44.0
            && self.statefulState == FitStatefulTableViewControllerStateIdle
            && [self canLoadMore]) {
            [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
        }
    } else {
        if (-64 == self.tableView.contentOffset.y && self.statefulState == FitStatefulTableViewControllerStateIdle) {
            
            [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
        }
    }
}


- (void)loadNextPage
{
    [self loadActivity];
    if (ifloadMoreData==NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self textStateHUD:@"没有更多消息~"];
            [activity removeFromSuperview];
        });
        
        return;
    }
    
    if (self.statefulState == FitStatefulTableViewControllerStateLoadingNextPage) return;
    
        
        self.statefulState = FitStatefulTableViewControllerStateLoadingNextPage;
        
        //        切换页码到下一页
        
        FitBaseRequest * req = [self request];
        table_proxy = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
            
            NSArray * items = [self parseResponse:resp];
            
            if (items && [items count]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activity removeFromSuperview];
                    if (!self.ifLoadReverse) {
                        [self.listData addObjectsFromArray:items];
                        
                        [self.tableView reloadData];
                    } else {
                        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.listData];
                        [self.listData removeAllObjects];
                        [self.listData addObjectsFromArray:items];
                        [self.listData addObjectsFromArray:tempArr];
                        NSMutableArray *messageArr = [NSMutableArray arrayWithArray:listArray];
                        [listArray removeAllObjects];
                        [listArray addObjectsFromArray:items];
                        [listArray addObjectsFromArray:messageArr];
                        if (hasShield==YES) {
                            NSMutableArray *shieldArray = [NSMutableArray new];
                            for (MssageVO *vo in self.listData) {
                                
                                NSLog(@"*****************%@",vo.role);
                                if (vo.role &&![vo.role isEqualToString:@"student"]) {
                                    [shieldArray addObject:vo];
                                }
                            }
                            reloadCount=1;
                            [self.listData removeAllObjects];
                            [self.listData addObjectsFromArray:shieldArray];
                            [self.tableView reloadData];
                        }else{
                            [self.tableView reloadData];
                            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        }
                        
                        

                    }
                    
                });
            }
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        } failed:^(NSError *error) {
            
            self.statefulState = FitStatefulTableViewControllerStateIdle;
        }];
        
        [table_proxy start];
}




- (void)cellClickVoice:(ChattingCell *)cell
{
    
    for (MssageVO *vo in self.listData) {
        vo.ifStopAnimal = YES;
    }
    
    [player stop];
    moreView.hidden = YES;
    MssageVO *vo = self.listData[cell.tag];
    if ([cell.playStatus isEqualToString:@"play"]) {
        [player stop];
        [cell setVoicePlayState:LGVoicePlayStateCancel];
        return;
    }
    
    vo.ifStopAnimal = NO;
    if (vo.ifStopAnimal == NO) {
        [cell setVoicePlayState:LGVoicePlayStatePlaying];
    }else{
        [cell setVoicePlayState:LGVoicePlayStateCancel];
    }
    [self.tableView reloadData];
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        
        
        NSString *urlStr = vo.voiceurl;
        playIndex = [vo.currentIndex integerValue];
        playTag = cell.tag;
        //播放本地音乐
        AVAudioSession *audioSessions = [AVAudioSession sharedInstance];
        
        NSError *audioError = nil;
        BOOL successs = [audioSessions overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
        NSLog(@"%d",successs);
        //播放本地音乐
        [self lianxuPlay:urlStr];
        
        NSMutableArray *urlArray = [NSMutableArray new];
        NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readStatus"];
        for (NSDictionary *dic in palyArray) {
            [urlArray addObject:dic[@"url"]];
            
        }
        
        if ([urlArray containsObject:vo.voiceurl]) {
            [cell.bootomView setHidden:YES];
            [self.tableView reloadData];
        }
  
    }
}

- (void)cellClickImage:(ChattingCell *)cell
{
    moreView.hidden = YES;
    NSMutableArray *array = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    MssageVO *message=self.listData[cell.tag];
    if (!message.imageurl) {
        return;
    }
    
    
    for (int i = 0; i < self.listData.count; i++) {
        
        MssageVO *Projectslist=self.listData[i];
        
        if (Projectslist.imageurl && [Projectslist.imageurl isKindOfClass:[NSString class]] && ![Projectslist.imageurl isEqual:@""]) {
            
            [imageArray addObject: Projectslist.imageurl];
        }
    }
    if (imageArray.count>0) {
        SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageArray delegate:self];
        
        for (int j = 0; j<cell.tag+1; j++) {
            
            MssageVO *vo = self.listData[j];
            
            if (!vo.imageurl||[vo.imageurl isEqual:@""]) {
                
                [array addObject:@""];
            }
        }
        
        photoBrowser.initialPageIndex = cell.tag-array.count;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }

}

#pragma mark --问题列表返回问题

- (void)backDic:(NSString *)userId content:(NSString *)content questionUuid:(NSString *)questionUuid
{
    
    NSLog(@"***********%@",questionUuid);
    NSString *strings  = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings ,@"has_profile":@"false",@"question_uuid":questionUuid};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
    [client sendTo:urlStr body:string];
}

- (void)startRecord
{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecord {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 61) {
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecord {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecord {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecord {
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}

- (void)sixtyTimeStopSendVodio {
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 59 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 60) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [toorbar.sayLabel sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

#pragma mark  --录制结束上传音频

- (void)sendSound
{
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    
    NSString *filePath = [[LGSoundRecorder shareInstance] soundFilePath];
    NSData *imageData = [NSData dataWithContentsOfFile: filePath];
    
    duration = [[LGSoundRecorder shareInstance] soundRecordTime];
    
    FirUploadVoiceRequest *request = [[FirUploadVoiceRequest alloc] initWithFileName:@"file"];
    
    request.fileData = imageData;
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"outputFileOSSUrl"];
                                                     NSString    *voiceUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                       
                                                       NSDictionary *dics = @{@"type":@"voice",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl,@"recordingTime":[NSString stringWithFormat:@"%d",duration],@"transcodingUrl":voiceUrl};
                                                       
                                                       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                                                       NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                                                       NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                                                       if (client.connected ==YES) {
                                                           [client sendTo:urlStr body:string];
                                                           
                                                       }else{
                                                           [self textStateHUD:@"发送失败~"];
                                                       }
                                                       
                                                       [self reLoadTableViewCell];
                                                       
                                                       
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

#pragma mark - LGSoundRecorderDelegate

- (void)showSoundRecordFailed
{
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

- (void)didStopSoundRecord {
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    
    ChattingCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playTag    inSection:0]];
    [cell setVoicePlayState:LGVoicePlayStateCancel];
    [cell.animalImage stopAnimating];
    
    //播放结束时执行的动作
    NSMutableArray *urlArray = [NSMutableArray new];
    NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readStatus"];
    
    for (NSDictionary *dic in palyArray) {
    
        [urlArray addObject:dic[@"url"]];
    }
    
    NSMutableArray *newArray = [NSMutableArray new];
    
    NSMutableArray *voArray = [NSMutableArray new];
    
    for (int i = 0; i < self.listData.count; i++) {
        
        MssageVO *vo = self.listData[i];
        
        if (vo.type && [vo.type isEqualToString:@"voice"]) {
            
            if ([vo.currentIndex integerValue]>playIndex) {
    
                if ([urlArray containsObject:vo.voiceurl]) {
                    NSLog(@"*********8已播放");
                } else {
                    NSLog(@"******888未播放");
                    [voArray addObject:vo];
                    NSString *string = [NSString stringWithFormat:@"%d",i];
                    [newArray addObject:string];
                }
            }
        }
    }
    
    if (voArray.count > 0) {
        
        MssageVO *vo = voArray[0];
        [self lianxuPlay:vo.voiceurl];
        playTag = [newArray[0] integerValue];
        ChattingCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playTag    inSection:0]];
        [cell setVoicePlayState:LGVoicePlayStatePlaying];
        cell.bootomView.hidden = YES;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error
{
    //解码错误执行的动作
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player
{
    //处理中断的代码
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player
{
    //处理中断结束的代码
}

- (void)lianxuPlay:(NSString *)urlString
{
    NSMutableArray *statusArray = [NSMutableArray new];
    NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readStatus"];
    [statusArray addObjectsFromArray:palyArray];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:urlString forKey:@"url"];
    [dic setObject:@"1" forKey:@"status"];
    if (![statusArray containsObject:dic]) {
       [statusArray addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:statusArray forKey:@"readStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    player.delegate = self;
    [player play];
    
    
    
}

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ChattingCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:
            voicePlayState = LGVoicePlayStateNormal;
            break;
        case LGAudioPlayerStatePlaying:
            voicePlayState = LGVoicePlayStatePlaying;
            break;
        case LGAudioPlayerStateCancel:
            voicePlayState = LGVoicePlayStateCancel;
            break;
            
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [voiceMessageCell setVoicePlayState:voicePlayState];
    });
}

#pragma mark --关闭问题

- (void)cellcloseQuestion:(ChattingCell *)cell
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否关闭问题"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                              MssageVO *vo = self.listData[cell.tag];
                                                [self closeQuestion:vo.questionUuid];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)closeQuestion:(NSString *)questionUuid
{
    NSLog(@"*************关闭问题");
    
    LMCloseQuestionRequest *request = [[LMCloseQuestionRequest alloc] initWithQuestionUuid:questionUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getCloseQuestion:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}


- (void)getCloseQuestion:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"问题关闭失败"];
    }else{
        if ([bodyDic objectForKey:@"result"]&&[[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"问题关闭成功"];
            currentIndex = nil;
            [self loadNoState];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}


//原生菊花
-(void)loadActivity
{
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
    [activity setCenter:CGPointMake(kScreenWidth/2, 90)];//指定进度轮中心点
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self.view addSubview:activity];
    [activity startAnimating];
}

#pragma mark --语音转文字
-(void)cellVoiceChangeText:(ChattingCell *)cell
{


    [changeView removeFromSuperview];
    changeView = [[UIView alloc] initWithFrame:CGRectMake(55, cell.frame.origin.y-30, 100, 30)];
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"转文字";
    textLabel.font = TEXT_FONT_LEVEL_2;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.layer.cornerRadius = 4;
    textLabel.clipsToBounds = YES;
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(10, 0, textLabel.bounds.size.width+20, 30);
    textLabel.userInteractionEnabled = YES;
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(40, 25, 10, 10)];
    downView.backgroundColor = [UIColor blackColor];
    downView.layer.cornerRadius = 10;
    downView.clipsToBounds = YES;
    [changeView addSubview:downView];
    
    
    
    [changeView addSubview:textLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTextAction:)];
    changeView.tag = cell.tag;
    [changeView addGestureRecognizer:tap];
    NSLog(@"********1********%ld",(long)cell.tag);
    [self.tableView addSubview:changeView];
}

- (void)changeTextAction:(UITapGestureRecognizer *)tap
{
    [player stop];
    ChattingCell *cells = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playTag    inSection:0]];
    [cells setVoicePlayState:LGVoicePlayStateCancel];
    [cells.animalImage stopAnimating];
    [self changeTextRequest:tap.view.tag];
    NSLog(@"********2********%ld",(long)tap.view.tag);

}

- (void)changeTextRequest:(NSInteger)index
{
    [self initStateHud];
    MssageVO *vo = self.listData[index];
    NSLog(@"********3********%ld",(long)index);
    LMVoiceChangeTextRequest *request = [[LMVoiceChangeTextRequest alloc] initWithtranscodingUrl:vo.transcodingUrl andcurrentIndex:[vo.currentIndex intValue] voice_uuid:_voiceUuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getchangeTextRespond:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

- (void)getchangeTextRespond:(NSString *)resp
{
    [self hideStateHud];
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {

        [self textStateHUD:@"转文字失败~"];
    }else{
        if ([bodyDic objectForKey:@"result"]&&[[bodyDic objectForKey:@"result"] isEqual:@"0"]) {

            NSLog(@"***********%@",bodyDic);
            NSLog(@"%@",bodyDic[@"turnSound"]);
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            topView.backgroundColor = [UIColor whiteColor];
            [self.view.window addSubview:topView];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-60, kScreenHeight)];
            textLabel.numberOfLines = 0;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text =bodyDic[@"turnSound"];
            [topView addSubview:textLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTopView:)];
            [topView addGestureRecognizer:tap];
            
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

- (void)hiddenTopView:(UITapGestureRecognizer *)tap
{
    [changeView removeFromSuperview];
    [tap.view removeFromSuperview];
}


@end
