//
//  MainViewController.m
//  chatting
//
//  Created by JamHonyZ on 2016/12/12.
//  Copyright © 2016年 Dlx. All rights reserved.
//

#import "LMChatViewController.h"
#import "LMVoiceQuestionViewController.h"
#import "LMChoosehostViewController.h"
#import "PlayerViewController.h"

#import "LMChatRecordsRequest.h"
#import "FirUploadImageRequest.h"
#import "LMVoiceChangeTextRequest.h"
#import "LMNumberMessageRequest.h"
#import "FirUploadVideoRequest.h"
#import "LMCloseQuestionRequest.h"
#import "FirUploadVoiceRequest.h"
#import "LMShieldstudentRequest.h"
#import "LMRewardBlanceRequest.h"
#import "LMChangeHostRequest.h"
#import "LMVoiceEndRequest.h"

#import "CustomToolbar.h"
#import "KeyBoardAssistView.h"
#import "MoreFunctionView.h"
#import "ChattingCell.h"
#import "ImageHelpTool.h"
#import "SYPhotoBrowser.h"
#import "LMKeepImageView.h"
#import "LMExceptionalView.h"
#import "LMChangeTextView.h"
#import "MssageVO.h"

#define assistViewHeight  200
#define toobarHeight 50
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface LMChatViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextViewDelegate,
AVAudioPlayerDelegate,
UIToolbarDelegate,
AVAudioRecorderDelegate,
selectItemDelegate,
assistViewSelectItemDelegate,
moreSelectItemDelegate,
STOMPClientDelegate,
ChattingCellDelegate,
LMhostchooseProtocol,
LMquestionchooseProtocol,
LGSoundRecorderDelegate,
LGAudioPlayerDelegate,
ZYQAssetPickerControllerDelegate,
LMExceptionalViewDelegate
>
{
    LGVoicePlayState voicePlayState;
    LMChangeTextView *changeView;
    LMKeepImageView *backButtonView;
    LMExceptionalView *ExceptionalView;
    CustomToolbar *toorbar;
    KeyBoardAssistView *assistView;
    MoreFunctionView *moreView;
    STOMPClient *client;

    BOOL hasShield;
    BOOL isShieldReload;
    BOOL ifloadMoreData;
    
    NSTimeInterval _visiableTime;
    NSString *name;
    NSString *avartar;
    NSString *currentIndex;
    NSInteger reloadCount;
    AVAudioPlayer *player;
    NSMutableArray *imageArray;
    UIView *bootView;
    NSInteger roleIndex;
    NSInteger signIndex;
    UIBarButtonItem * rightItem;
    NSArray *titleArray;
    NSArray *iconArray;
    NSInteger hostId;
    NSInteger playIndex;
    NSMutableArray *listArray;
    NSMutableArray *messageArray;
    NSInteger playTag;
    NSString *_role;
    CGFloat toolBarChangeH;
    UIActivityIndicatorView *activity;
    UIView *headView;
    NSString *UserID;
    NSTimer *timer;
    CGFloat koardH;
    UIImage *keepImage;
    NSInteger timerIndex;
    NSMutableArray *currentArray;
    NSString *imageString;
    NSData *videoData;
    NSString *playVoiceURL;
    NSInteger loadIndex;
    
}

@end

@implementation LMChatViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.hidesBottomBarWhenPushed   = NO;
        self.listData   = [NSMutableArray new];
        
        ifloadMoreData =YES;
        hasShield = NO;
        isShieldReload = NO;
        [self createWebSocket];
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(websocketConnect) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
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
    [timer invalidate];

    timer = nil;
    
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

    [self loadNewer];
    
    listArray       = [NSMutableArray new];
    messageArray    = [NSMutableArray new];
    reloadCount     = 0;
    
    [LGAudioPlayer sharePlayer].delegate = self;
    toolBarChangeH  = 0;
    timerIndex = 1;
    loadIndex = 1;
    
}

- (void)loadNewer
{
    
    FitBaseRequest * req = [self request];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [_listData addObjectsFromArray:items];
                NSMutableArray *new = [NSMutableArray new];
                for (int i = 0; i<_listData.count; i++) {
                    MssageVO *vo = _listData[i];
                    NSString *string = [NSString stringWithFormat:@"%@",vo.currentIndex];
                    [new addObject:string];
                }
                NSMutableArray *currentArrays = [NSMutableArray new];
                if (new.count>0) {
                    for (int j = 0; j<new.count; j++) {
                        if ([currentArrays containsObject:new[j]]) {
                            [_listData removeObjectAtIndex:j];
                        }else{
                            [currentArrays addObject:new[j]];
                        }
                    }
                }
                
                [self reLoadTableViewCell];
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    } failed:^(NSError *error) {
        
    }];
    
    [proxy start];
}

- (void)websocketDidDisconnect:(NSError *)error
{
    
}

#pragma mark 初始化视图静态界面

- (void)createUI
{
    self.title  = @"语音教室";
    
    [super createUI];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - toobarHeight)];
    
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

- (void)backAction
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

#pragma mark --屏蔽学员

- (void)getShieldstudentData
{
    NSMutableArray *shieldArray = [NSMutableArray new];
    [listArray addObjectsFromArray:self.listData];
    
    for (MssageVO *vo in self.listData) {
        
        if (vo.role &&![vo.role isEqualToString:@"student"]) {
            [shieldArray addObject:vo];
        }
    }
    
    reloadCount = 1;
    
    [self.listData removeAllObjects];
    [self.listData addObjectsFromArray:shieldArray];
    [self reLoadTableViewCell];
}

- (FitBaseRequest *)request
{
    
    LMChatRecordsRequest    *request    = [[LMChatRecordsRequest alloc] initWithPageIndex:currentIndex andPageSize:10 voice_uuid:_voiceUuid];
    return request;
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
        if (headDic[@"userId"]&&![headDic[@"userId"] isEqual:@""]) {
            UserID = headDic[@"userId"];
        }
        
    }
    
    NSString    *result = [bodyDic objectForKey:@"result"];
    NSString    *total  = [bodyDic objectForKey:@"count"];
    NSString    *hostID  = [bodyDic objectForKey:@"host_uuid"];
    NSString    *sign  = [bodyDic objectForKey:@"sign"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    if ([sign isEqualToString:@"1"]) {
        if ([hostID isEqualToString:[FitUserManager sharedUserManager].uuid]) {
            [bootView removeFromSuperview];
            
        }else if([_role isEqualToString:@"student"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self creatBootView];
            });
            
        }else if(![_role isEqualToString:@"student"]){
            [bootView removeFromSuperview];
        }
        
    }else if ([sign isEqualToString:@"2"]){
        [bootView removeFromSuperview];
        
    }
    
    self.max = ceil([total floatValue] / 10) - 1;
    imageArray = [NSMutableArray new];
    
    if (result && [result isEqualToString:@"0"]) {
        
        NSArray *tempArr    = [MssageVO MssageVOListWithArray:[bodyDic objectForKey:@"list"]];
        
        if (tempArr.count > 0) {
            MssageVO   *vo     = [tempArr objectAtIndex:0];
            if ([total intValue]<10) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ifloadMoreData =NO;
                });
                
            }else if([currentIndex intValue] !=[vo.currentIndex intValue]){
                currentIndex = [NSString stringWithFormat:@"%d",[vo.currentIndex intValue]];
                reloadCount = reloadCount+1;
                [self stopAcyivity];
                
            }
        }else{
            [self stopAcyivity];
        }
        
        if (loadIndex == 1) {
            [self messageConnect];
            
            NSMutableArray *new = [NSMutableArray new];
            for (MssageVO *vo in self.listData) {
                NSString *string = [NSString stringWithFormat:@"%@",vo.currentIndex];
                [new addObject:string];
            }
            NSMutableArray *tempArray = [NSMutableArray new];
            [tempArray addObjectsFromArray:tempArr];
            for (int i = 0; i<tempArr.count; i++) {
                MssageVO *vo = tempArr[i];
                for (int j = 0; j<new.count; j++) {
                    NSString *current =[NSString stringWithFormat:@"%@",vo.currentIndex];
                    if ([new[j] isEqualToString:current]) {
                        [tempArray removeObjectAtIndex:i];
                    }
                }
            }
            return tempArray;
        }else{
            return tempArr;
        }
    }else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {

        [self stopAcyivity];
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
    return nil;
    
}

- (void)bootViewRemove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [bootView removeFromSuperview];
    });
}

-(void)stopAcyivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [activity stopAnimating];
    });
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
            [self creatBootView];
            
        }
        if (_sign&&[_sign isEqualToString:@"2"]){
            [self creatToolbarView];
        }
        
    }else{
        
        [self creatToolbarView];
        [self bootViewRemove];
    }
    
}

- (void)creatBootView
{
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
            
            [self alertControllerView:tipString index:item];
            
        }
        
        if (item == 1) {
            LMVoiceQuestionViewController *questVC = [[LMVoiceQuestionViewController alloc] init];
            questVC.hidesBottomBarWhenPushed = YES;
            questVC.voiceUUid = _voiceUuid;
            questVC.roleIndex = @"1";
            questVC.delegate = self;
            timerIndex = 2;
            [self.navigationController pushViewController:questVC animated:YES];
        }
        
    }
    if (roleIndex == 2) {
        
        //禁言
        if (item == 0) {
            
            if (_sign&&[_sign isEqualToString:@"1"]) {
                NSDictionary *dics = @{@"type":@"gag",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"sign":@"2"};
                
                [self websocketLinke:dics type:@"gag1"];

            }
            
            if (_sign&&[_sign isEqualToString:@"2"]) {
                NSDictionary *dics = @{@"type":@"gag",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"sign":@"1"};
                [self websocketLinke:dics type:@"gag2"];

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
            
            [self alertControllerView:tipString index:item];

            
        }
        
        //选择主持人
        
        if (item == 3) {
            LMChoosehostViewController    *typeVC     = [[LMChoosehostViewController alloc] init];
            typeVC.delegate     = self;
            
            [self.navigationController pushViewController:typeVC animated:YES];
        }
        
        if (item == 4) {
            [self alertControllerView:@"是否结束课程" index:item];

        }
        
    }
    
}

-(void)alertControllerView:(NSString *)tipString index:(NSInteger)index
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipString
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                if ([tipString isEqualToString:@"是否结束课程"]) {
                                                    [self endVoiceAction];
                                                }
                                                if ([tipString isEqualToString:@"是否关闭问题"]) {
                                                    MssageVO *vo = self.listData[index];
                                                    [self closeQuestion:vo.questionUuid];
                                                }
                                                
                                                if ([tipString isEqualToString:@"是否取消屏蔽"]||[tipString isEqualToString:@"是否屏蔽该课程学员发言"]) {
                                                    if (index == 0) {
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

                                                    }
                                                    if (index == 2) {
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
                                                        
                                                    }
                                                    
                                                }
                                                
     
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    

}

-(void)endVoiceAction{
    
    [self checklinke];
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
    if (hostId==[UserID integerValue]) {
        [self textStateHUD:@"不能更换主持人为自己~"];
        return;
    }
    
    
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
        return;
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            
            NSDictionary *dics = @{@"type":@"host",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"userId":[NSString stringWithFormat:@"%ld",(long)hostId]};
            [self websocketLinke:dics type:@"host"];
            
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
        
        NSString *content = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *contentStr;
        if (content==nil) {
            contentStr = vo.content;
        }else{
            contentStr = content;
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-90, MAXFLOAT)                                           options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        if ([vo.type isEqual:@"question"]) {
            return contenSize.height+55+10+20+20;
        }else{
            return contenSize.height+55+10+20;
        }
    }
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {

        return 55+30+10+10;
    }
    
    if (vo.type&&([vo.type isEqual:@"video"] ||[vo.type isEqual:@"picture"])) {
        
        return 150+55+10+10;
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
                    [self websocketLinke:dics type:@"question1"];
                    
                    toorbar.inputTextView.text=@"";
                    
                } else {
                    
                    NSString *strings  = [toorbar.inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dics = @{@"type":@"chat",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings};
                    [self websocketLinke:dics type:@"chat"];
                    toorbar.inputTextView.text=@"";
                }
            }else{
                [self textStateHUD:@"发送失败,请重试~"];
                [self createWebSocket];
            }
            if ([toorbar.inputTextView.text isEqualToString:@""]) {
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - koardH - toobarHeight);
                [toorbar setFrame:CGRectMake(0, toorbar.frame.origin.y+(toorbar.frame.size.height-toobarHeight),kScreenWidth, toobarHeight)];
                toorbar.inputTextView.frame = CGRectMake(45, 7, kScreenWidth-45-45, 36);
            }
            [self reLoadTableViewCell];
            
            return NO;
        }
    }
    return YES;
}

#pragma mark --判断websocket连接
- (void)websocketLinke:(NSDictionary *)sendDic type:(NSString *)type
{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
    
    if (client.connected == YES) {
        
        [client sendTo:urlStr body:string];
        if ([type isEqualToString:@"question1"]) {
           [self textStateHUD:@"发送成功"];
        }else if ([type isEqualToString:@"host"]){
            [self textStateHUD:@"更换主持人成功！"];
        }
        
    } else {

         dispatch_async(dispatch_get_main_queue()
                      , ^{
                          if ([type isEqualToString:@"gag1"]) {
                              [self textStateHUD:@"禁言失败，请重试~"];
                          }else if ([type isEqualToString:@"gag2"]) {
                              [self textStateHUD:@"解禁失败，请重试~"];
                          }else if ([type isEqualToString:@"host"]) {
                              [self textStateHUD:@"更换主持人失败，请重试~"];
                          }else{
                             [self textStateHUD:@"发送失败，请重试~"];
                          }
                          [client disconnect];
                          [self createWebSocket];
                    });
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
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
        self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        if (toolBarChangeH>50) {
            
            if ([toorbar.inputTextView.text isEqualToString:@""]) {
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
                toorbar.inputTextView.frame = CGRectMake(45, 7, kScreenWidth-45-45, 36);
                
            }else{
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
            }
            
        }else{
            [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
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
    
    if (item == 1) {//小视频
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 1;
        picker.assetsFilter = [ALAssetsFilter allVideos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration < 10.5;
            } else {
                return YES;
            }
        }];
        
        timerIndex = 2;
        
        [self presentViewController:picker animated:YES completion:NULL];
        }
    
    if (item == 2) {//照片
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalTransitionStyle = UIModalPresentationCustom;
        timerIndex = 2;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    
    if (item == 3) {//提问
        
        toorbar.inputTextView.text = @"#问题# ";
        [toorbar.inputTextView becomeFirstResponder];
    }
}

#pragma mark 选择照片后添加数组 重新加载cell
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self getImageURL:image index:1];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 获取头像的url

- (void)getImageURL:(UIImage*)image index:(NSInteger)index
{
    [self initStateHud];
    [self checklinke];
    
    FirUploadImageRequest   *request    = [[FirUploadImageRequest alloc] initWithFileName:@"file"];

    
    request.imageData   = UIImageJPEGRepresentation(image, 1);
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               

                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                       if (index == 1) {

                                                           NSDictionary *dics = @{@"type":@"picture",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl};
                                                           [self websocketLinke:dics type:@"picture"];
                                                           
                                                           [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                                  withObject:nil
                                                                               waitUntilDone:YES];
                                                           
                                                           [self reLoadTableViewCell];

                                                       }else{
                                                           imageString = imgUrl;
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self sendVideo:videoData];
                                                           });
                                                           
                                                       }
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
    koardH =keyboardRect.size.height;
    _visiableTime=animationDuration;
    [UIView animateWithDuration:animationDuration animations:^{
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            if (toolBarChangeH>50) {
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight - toolBarChangeH - keyboardRect.size.height, kScreenWidth, toolBarChangeH)];
                
            } else {
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight - toobarHeight - keyboardRect.size.height, kScreenWidth, toobarHeight)];
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
    
    _visiableTime   = animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        if (toolBarChangeH > 50) {
            
            if ([toorbar.inputTextView.text isEqualToString:@""]) {
                toolBarChangeH = 45;
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
                toorbar.inputTextView.frame = CGRectMake(45, 7, kScreenWidth-45-45, 36);
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
                self.tableView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toolBarChangeH);
            }else{
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
                self.tableView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toolBarChangeH);
            }
            
        } else {
            
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
    client = [LMWobsocket shareWebsocket];
    
    dispatch_semaphore_t connected = dispatch_semaphore_create(0);
    
    [client connectWithLogin:@"1"
                    passcode:@"2"
           completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
               if (!error) {
                   dispatch_semaphore_signal(connected);
               }
               [self subscribeTopic];
           }];
    
}


- (void)subscribeTopic
{

    NSString *string = [NSString stringWithFormat:@"/topic/room/%@",_voiceUuid];
    
    [client subscribeTo:string messageHandler:^(STOMPMessage *message) {
        NSMutableArray *newNumArray = [NSMutableArray new];
        for (MssageVO *vo in self.listData) {
            if (vo.currentIndex &&[vo.currentIndex isKindOfClass:[NSNumber class]]) {
                [newNumArray addObject:vo.currentIndex];
            }
        }
        
        NSString *resp = [NSString stringWithFormat:@"%@",message.body];
        
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization
                                  JSONObjectWithData:respData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        MssageVO *vo = [MssageVO MssageVOWithDictionary:respDict];
        NSString *number = [NSString stringWithFormat:@"%@",vo.currentIndex];
        
        for (int i = 0; i<newNumArray.count; i++) {
            if ([newNumArray[i] isEqual:number]) {
                return ;
            }
        }
        
        if (vo.type && ([vo.type isEqual:@"chat"]||[vo.type isEqual:@"question"])) {
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            NSMutableArray *array = [NSMutableArray new];
            NSString *content = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (content==nil) {
                [dic setObject:vo.content forKey:@"content"];
            }else{
                [dic setObject:content forKey:@"content"];
                
            }
            [dic setObject:vo.user_uuid forKey:@"user_uuid"];
            [dic setObject:vo.time forKey:@"time"];
            if (vo.name&&![vo.name isEqual:@""]) {
                [dic setObject:vo.name forKey:@"name"];
            }else{
                [dic setObject:@"" forKey:@"name"];
            }
            
            if (vo.headimgurl&&![vo.headimgurl isEqual:@""]) {
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
            }else{
                [dic setObject:@"" forKey:@"headimgurl"];
            }
            
            if (vo.role&&![vo.role isEqual:@""]) {
                [dic setObject:vo.role forKey:@"role"];
            }else{
                [dic setObject:@"" forKey:@"role"];
            }
            
            if (vo.currentIndex&&![vo.currentIndex isEqual:@""]) {
                [dic setObject:vo.currentIndex forKey:@"currentIndex"];
            }else{
                [dic setObject:@"" forKey:@"currentIndex"];
            }

            if ([vo.type isEqual:@"chat"]) {
                [dic setObject:@"chat" forKey:@"type"];
                
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
                    
                }

            }
        
        if ([vo.type isEqual:@"question"]) {

            [dic setObject:@"question" forKey:@"type"];
            if (vo.questionUuid&&![vo.questionUuid isEqualToString:@""]) {
                [dic setObject:vo.questionUuid forKey:@"question_uuid"];
            }
            
            [array addObject:dic];
            NSArray *array2 = [MssageVO MssageVOListWithArray:array];
            
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
     
        if (vo.type&&([vo.type isEqual:@"picture"]||[vo.type isEqual:@"voice"]||[vo.type isEqual:@"video"])) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            NSMutableArray *array = [NSMutableArray new];
            
            if (vo.name&&![vo.name isEqual:@""]) {
                [dic setObject:vo.name forKey:@"name"];
            }else{
                [dic setObject:@"" forKey:@"name"];
            }
            if (vo.headimgurl&&![vo.headimgurl isEqual:@""]) {
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
            }else{
                [dic setObject:@"" forKey:@"headimgurl"];
            }
            
            if (vo.role&&![vo.role isEqual:@""]) {
                [dic setObject:vo.role forKey:@"role"];
            }else{
                [dic setObject:@"" forKey:@"role"];
            }
            
            if (vo.currentIndex&&![vo.currentIndex isEqual:@""]) {
                [dic setObject:vo.currentIndex forKey:@"currentIndex"];
            }else{
                [dic setObject:@"" forKey:@"currentIndex"];
            }
            if ([vo.type isEqual:@"voice"]) {
                [dic setObject:vo.user_uuid forKey:@"user_uuid"];
                [dic setObject:vo.attachment forKey:@"voiceurl"];
                [dic setObject:@"voice" forKey:@"type"];
                [dic setObject:vo.recordingTime forKey:@"recordingTime"];

                if (vo.transcodingUrl&&![vo.transcodingUrl isEqualToString:@""]) {
                    [dic setObject:vo.transcodingUrl forKey:@"transcodingUrl"];
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
            
            if ([vo.type isEqual:@"video"]) {
                [dic setObject:vo.user_uuid forKey:@"user_uuid"];
                if (vo.videourl&&![vo.videourl isEqualToString:@""]) {
                    [dic setObject:vo.videourl forKey:@"videourl"];
                }else{
                    if (vo.attachment&&![vo.attachment isEqualToString:@""]) {
                        [dic setObject:vo.attachment forKey:@"videourl"];
                    }
                }
                
                [dic setObject:@"video" forKey:@"type"];
                [dic setObject:vo.recordingTime forKey:@"recordingTime"];
                
                [dic setObject:vo.cover forKey:@"cover"];
                
                if ([vo.user_uuid isEqualToString:[FitUserManager sharedUserManager].uuid]) {
                    NSMutableArray *statusArray = [NSMutableArray new];
                    NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"VideoreadStatus"];
                    [statusArray addObjectsFromArray:palyArray];
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setObject:vo.videourl forKey:@"videourl"];
                    [dict setObject:@"1" forKey:@"status"];
                    if (![statusArray containsObject:dict]) {
                        [statusArray addObject:dict];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:statusArray forKey:@"VideoreadStatus"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            
            if ([vo.type isEqual:@"picture"]) {
                
                if (vo.attachment) {
                    [dic setObject:vo.attachment forKey:@"imageurl"];
                }
                
                [dic setObject:@"picture" forKey:@"type"];
            }
            [dic setObject:vo.user_uuid forKey:@"user_uuid"];
            [dic setObject:vo.time forKey:@"time"];
            
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
            [moreView removeFromSuperview];
            
            if (_role&&![_role isEqualToString:@"student"]) {
                
                if ([_role isEqualToString:@"host"]) {
                    if (![[FitUserManager sharedUserManager].uuid isEqualToString:vo.host_uuid]) {
                        titleArray=@[@"屏蔽",@"问题"];
                        roleIndex = 1;
                        iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                        _role = @"student";
                    }
                }else{
                    
                    if ([_sign isEqualToString:@"1"]) {
                        titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }else{
                        titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }
                    
                    roleIndex = 2;
                    iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [bootView removeFromSuperview];
                }
            }
            if (_role&&[_role isEqualToString:@"student"]){
                
                if ([[FitUserManager sharedUserManager].uuid isEqualToString:vo.host_uuid]) {
                    if ([_sign isEqualToString:@"1"]) {
                        titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }else{
                        titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    }
                    
                    roleIndex = 2;
                    _role = @"host";
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
            [moreView removeFromSuperview];
            _sign = @"1";
            if ([_role isEqual:@"student"]) {
                
                titleArray=@[@"屏蔽",@"问题"];
                iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                [self addrightItem];
                [self creatBootView];

            }else{
                
                titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                [self addrightItem];
                
            }
            
        }
        if (vo.type&&([vo.sign isEqual:@"2"]&&[vo.type isEqualToString:@"gag"])) {
            
            [self textStateHUD:@"禁言解除"];
            [moreView removeFromSuperview];
            _sign = @"2";
            if ([_role isEqual:@"student"]) {
                titleArray=@[@"屏蔽",@"问题"];
                iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
                [self addrightItem];
            }else{
                
                titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                [self addrightItem];

            }
            [bootView removeFromSuperview];
        }
        
        if (self.tableView.contentSize.height-self.tableView.contentOffset.y>kScreenHeight*3/2) {
            [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0];
        }else{
            [self performSelector:@selector(reLoadTableViewCell) withObject:nil afterDelay:0];
        }
        
    }];
}

-(void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)websocketConnect
{
    if (!client || ![client isKindOfClass:[STOMPClient class]]) {
        
        return;
    }
    
    if (client.connected == NO) {
        
        NSLog(@"0");
        [self createWebSocket];
        
    } else {
        
        NSLog(@"1");
    }
}

#pragma mark ---下拉加载数据

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [changeView removeFromSuperview];
    });

    if (-64 == self.tableView.contentOffset.y) {
        
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

- (void)loadNextPage
{
    loadIndex = 2;
    if (ifloadMoreData == NO) {
        return;
    }
    [self loadActivity];
    
    FitBaseRequest * req = [self request];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [activity removeFromSuperview];
                
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.listData];
                [self.listData removeAllObjects];
                [self.listData addObjectsFromArray:items];
                [self.listData addObjectsFromArray:tempArr];
                
                NSMutableArray *messageArr = [NSMutableArray arrayWithArray:listArray];
                [listArray removeAllObjects];
                [listArray addObjectsFromArray:items];
                [listArray addObjectsFromArray:messageArr];
                
                if (hasShield == YES) {
                    
                    NSMutableArray *shieldArray = [NSMutableArray new];
                    for (MssageVO *vo in self.listData) {
                        
                        if (vo.role &&![vo.role isEqualToString:@"student"]) {
                            [shieldArray addObject:vo];
                        }
                    }
                    
                    reloadCount = 1;
                    [self.listData removeAllObjects];
                    [self.listData addObjectsFromArray:shieldArray];
                    [self.tableView reloadData];
                } else {
                    
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
        }
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activity removeFromSuperview];
        });
        
        [self performSelectorOnMainThread:@selector(textStateHUD:)
                               withObject:@"网络错误"
                            waitUntilDone:YES];
    }];
    
    [proxy start];
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
        [cell setVoicePlayState:LGVoicePlayStateCancel];
        return;
    }
    vo.ifStopAnimal = NO;
    if (vo.ifStopAnimal == NO) {
        [cell setVoicePlayState:LGVoicePlayStatePlaying];
    }else{
        [cell setVoicePlayState:LGVoicePlayStateCancel];
    }
    [self reloadTableView];
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        
        NSString *urlStr = vo.voiceurl;
        playVoiceURL = urlStr;
        playIndex = [vo.currentIndex integerValue];
        playTag = cell.tag;
        //播放本地音乐
        AVAudioSession *audioSessions = [AVAudioSession sharedInstance];
        
        NSError *audioError = nil;
        BOOL successs = [audioSessions overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
        if (!successs) {
            NSLog(@"%@",audioError);
        }
        //播放本地音乐
        [self lianxuPlay:urlStr];
        
        NSMutableArray *urlArray = [NSMutableArray new];
        NSArray *palyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"readStatus"];
        for (NSDictionary *dic in palyArray) {
            [urlArray addObject:dic[@"url"]];
        }
        
        if ([urlArray containsObject:vo.voiceurl]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.bootomView setHidden:YES];
                [self.tableView reloadData];
            });
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
    NSString *strings  = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings ,@"has_profile":@"false",@"question_uuid":questionUuid};
    [self websocketLinke:dics type:@"question"];
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
        //停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                            target:self
                                                          selector:@selector(sixtyTimeStopSendVodio)
                                                          userInfo:nil
                                                           repeats:YES];
    } else {
        
    }
}

//录音结束
- (void)confirmRecord
{
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

//更新录音显示状态,手指向上滑动后 提示松开取消录音
- (void)updateCancelRecord
{
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

//更新录音状态,手指重新滑动到范围内,提示向上取消录音
- (void)updateContinueRecord
{
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

//取消录音
- (void)cancelRecord
{
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

//录音时间短
 
- (void)showShotTimeSign
{
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}

- (void)sixtyTimeStopSendVodio
{
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    
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

//  语音文件存储路径
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

-(void)didStopSoundRecord
{
    NSLog(@"stop");
}

#pragma mark --判断网络连接
- (void)checklinke
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
}

#pragma mark  --录制结束上传音频

- (void)sendSound
{
    [self checklinke];
    [self initStateHud];
    
    NSString *filePath = [[LGSoundRecorder shareInstance] soundFilePath];
    NSData *imageData = [NSData dataWithContentsOfFile: filePath];
    
    _durationTime = [[LGSoundRecorder shareInstance] soundRecordTime];
    
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
                                                       
                                                       NSDictionary *dics = @{@"type":@"voice",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl,@"recordingTime":[NSString stringWithFormat:@"%d",_durationTime],@"transcodingUrl":voiceUrl};
                                                       [self websocketLinke:dics type:@"voice"];
                                                       [self reLoadTableViewCell];
                                                       
                                                       
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
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
            
            if ([vo.currentIndex integerValue] > playIndex) {
                
                if ([urlArray containsObject:vo.voiceurl]) {
                    
                } else {
                    
                    [voArray addObject:vo];
                    NSString *string = [NSString stringWithFormat:@"%d",i];
                    [newArray addObject:string];
                }
            }
        }
    }
    
    if (voArray.count > 0) {
        
        MssageVO *vo = voArray[0];
        if (vo.voiceurl) {
            [self lianxuPlay:vo.voiceurl];
            playVoiceURL = vo.voiceurl;
        }

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
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSURL *url = [[NSURL alloc]initWithString:urlString];
        NSData * audioData = [NSData dataWithContentsOfURL:url];
        if (![playVoiceURL isEqualToString:urlString]) {

            return;
        }else{
            
            ChattingCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playTag  inSection:0]];

            MssageVO *vo = self.listData[cell.tag];
            vo.ifStopAnimal = NO;
            if (vo.ifStopAnimal == NO) {
                [cell setVoicePlayState:LGVoicePlayStatePlaying];
            }else{
                [cell setVoicePlayState:LGVoicePlayStateCancel];
            }
        }
        
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.wav", docDirPath , @"temp"];
        [audioData writeToFile:filePath atomically:YES];
        
        //播放本地音乐
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        player.delegate = self;
        [player play];
    });

}

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
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
    [self alertControllerView:@"是否关闭问题" index:cell.tag];
}

- (void)closeQuestion:(NSString *)questionUuid
{
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
    } else {
        
        if ([bodyDic objectForKey:@"result"]&&[[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"问题关闭成功"];
            currentIndex = nil;
        } else {
            
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}

//原生菊花
- (void)loadActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
        [activity setCenter:CGPointMake(kScreenWidth / 2, 90)];//指定进度轮中心点
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [self.view addSubview:activity];
        [activity startAnimating];
    });
}

#pragma mark --语音转文字
- (void)cellVoiceChangeText:(ChattingCell *)cell
{
    [changeView removeFromSuperview];
    changeView = [[LMChangeTextView alloc] initWithFrame:CGRectMake(55, cell.frame.origin.y, 100, 30)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTextAction:)];
    changeView.tag = cell.tag;
    [changeView addGestureRecognizer:tap];
    [self.tableView addSubview:changeView];
}

- (void)changeTextAction:(UITapGestureRecognizer *)tap
{
    [player stop];
    ChattingCell *cells = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:playTag    inSection:0]];
    [cells setVoicePlayState:LGVoicePlayStateCancel];
    [cells.animalImage stopAnimating];
    [self changeTextRequest:tap.view.tag];
}

- (void)changeTextRequest:(NSInteger)index
{
    [self initStateHud];
    MssageVO *vo = self.listData[index];
    
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
    NSDictionary *bodyDic = [VOUtil parseBody:resp];

    if (!bodyDic) {
        [self textStateHUD:@"转文字失败~"];
        return;
        
    } else {
        
        if ([bodyDic objectForKey:@"result"]&&[[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self hideStateHud];
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

-(void)cellTipAction:(ChattingCell *)cell
{
    ExceptionalView = [[LMExceptionalView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    ExceptionalView.delegate = self;
    ExceptionalView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:ExceptionalView];
    ExceptionalView.tag = cell.tag;
    MssageVO *vo = self.listData[cell.tag];
    [ExceptionalView.headerView sd_setImageWithURL:[NSURL URLWithString:vo.headimgurl]];
    [ExceptionalView.cancelButton addTarget:self action:@selector(closeViewAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)closeViewAction
{
    [ExceptionalView removeFromSuperview];
}

#pragma mark -- 打赏
-(void)ViewForMoney:(LMExceptionalView *)LMview Viewtag:(NSInteger)Viewtag
{
    NSArray *moneyArray = @[@"2",@"5",@"10",@"50",@"100",@"200"];
    MssageVO *vo = self.listData[LMview.tag];
    LMRewardBlanceRequest *request = [[LMRewardBlanceRequest alloc] initWithVoice_uuid:_voiceUuid user_uuid:vo.user_uuid money_reward:moneyArray[Viewtag]];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getrewardMoneyRespond:)
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

-(void)getrewardMoneyRespond:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"打赏失败"];
        return;
    }
    if ([bodyDic objectForKey:@"result"]&&[[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
        
        [self textStateHUD:@"您已成功打赏~~"];
        [self closeViewAction];
        
    }else{
        [self textStateHUD:[bodyDic objectForKey:@"description"]];
    }
    
}

#pragma mark --长按保存图片到相册

- (void)cellloagTapAction:(ChattingCell *)cell
{
    backButtonView = [[LMKeepImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:backButtonView];
    backButtonView.rihgtButton.tag = cell.tag;
    [backButtonView.leftButton addTarget:self action:@selector(CancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButtonView.rihgtButton addTarget:self action:@selector(BesureAction:) forControlEvents:UIControlEventTouchUpInside];
    keepImage = cell.publishImageV.image;

}

- (void)CancelAction:(UIButton *)sender
{
    [backButtonView removeFromSuperview];
}

- (void)BesureAction:(UIButton *)sender
{
    
    [backButtonView removeFromSuperview];
    UIImageWriteToSavedPhotosAlbum(keepImage,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
    
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo
{
    
    if(!error) {
        [self textStateHUD:@"保存成功"];
    }else{
        [self textStateHUD:@"保存失败，请重试~"];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    for (int i=0; i<assets.count; i++) {
        
        ALAsset *asset=assets[i];
        ALAssetRepresentation * representation = asset.defaultRepresentation;
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary assetForURL:representation.url resultBlock:^(ALAsset *asset){
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            // 这个data便是 转换成功的视频data 有了data边可以进行上传了
            videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                
                NSString * date =[asset valueForProperty:ALAssetPropertyDuration];
                float doubleNum =  [date doubleValue] +0.5;
                _timeNum =  (int)(doubleNum+0.5);
                UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                [self getImageURL:image  index:2];
                
            }
            
        }failureBlock:^(NSError *err) {
            NSLog(@"error: ------------------------%@",err);
        }];
    }
}

#pragma mark -- 数据丢包查询
- (void)messageConnect
{
    currentArray = [NSMutableArray new];
    for (MssageVO *vo in self.listData) {
        if (vo.currentIndex &&[vo.currentIndex isKindOfClass:[NSNumber class]]) {
            
            NSString *string = [NSString stringWithFormat:@"%@",vo.currentIndex];
            [currentArray addObject:string];
        }
    }
    
    NSArray *result = [currentArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2]; //升序
    }];
    
    if (result.count>1) {
        [self getmessageRequest:[result[result.count] intValue]];
    }
}

- (void)getmessageRequest:(int)messageNumber
{
    LMNumberMessageRequest *request = [[LMNumberMessageRequest alloc] initWithCurrentIndex:messageNumber andVoiceUuid:_voiceUuid];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(getmessageRespond:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

- (void)getmessageRespond:(NSString *)resp
{
    [self performSelector:@selector(messageConnect) withObject:nil afterDelay:1.0];
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"加载数据失败"];
    }
    
    NSString    *result = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    if (result && [result isEqualToString:@"0"]) {
        
        NSArray *tempArr    = [MssageVO MssageVOListWithArray:[bodyDic objectForKey:@"message"]];
        
        if (tempArr&&![tempArr isEqual:@""]&&[tempArr isKindOfClass:[NSArray class]]) {
            
            for (MssageVO *vo in tempArr) {
                NSString *strings =[NSString stringWithFormat:@"%@",vo.currentIndex];
                
                NSMutableArray *newArray = [NSMutableArray new];
                for (MssageVO *vo in self.listData) {
                    if (vo.currentIndex &&[vo.currentIndex isKindOfClass:[NSNumber class]]) {
                        
                        NSString *string = [NSString stringWithFormat:@"%@",vo.currentIndex];
                        [newArray addObject:string];
                    }
                }
                
                for (int i = 0; i<newArray.count; i++) {
                    if ([newArray[i] isEqual:strings]) {
                        return;
                    }
                }
                
                [self.listData addObjectsFromArray:tempArr];
            }
        }
        [self.tableView reloadData];
        
    }else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }
}

#pragma mark  --上传视频

- (void)sendVideo:(NSData *)data
{
    [self initStateHud];
    [self checklinke];
    
    FirUploadVideoRequest *request = [[FirUploadVideoRequest alloc] initWithFileName:@"file"];
    
    request.videoData = data;
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
                                               NSString    *result = [bodyDict objectForKey:@"result"];
                                               
                                               if (result && [result isKindOfClass:[NSString class]]
                                                   && [result isEqualToString:@"0"]) {
                                                   NSString    *voiceUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (voiceUrl && [voiceUrl isKindOfClass:[NSString class]]) {
                                                       
                                                       NSDictionary *dics = @{@"type":@"video",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":voiceUrl,@"recordingTime":[NSString stringWithFormat:@"%d",_timeNum],@"cover":imageString};
                                                       
                                                       [self websocketLinke:dics type:@"video"];
                                                       [self reLoadTableViewCell];

                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
}

- (void)cellplayVideoAction:(ChattingCell *)cell
{
    MssageVO *vo = self.listData[cell.tag];
    [self video_play:vo.videourl];
}

- (void)video_play:(NSString*)filename
{
    if (filename&&![filename isEqual:@""]) {
        PlayerViewController *playVC=[[PlayerViewController alloc]initWithVideoUrl:filename];
        [self presentViewController:playVC animated:NO completion:nil];
    }else{
        [self textStateHUD:@"未获取视频文件~"];
    }
}

@end
