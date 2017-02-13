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
#import "LMKeepImageView.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZYQAssetPickerController.h"
#import "LMNumberMessageRequest.h"
#import "FirUploadVideoRequest.h"

#define assistViewHeight  200
#define toobarHeight 50
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define secondsToNanoseconds(t) (t * 1000000000) // in nanoseconds
#define gotSignal(semaphore, timeout) ((dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, secondsToNanoseconds(timeout)))) == 0l)


// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

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
LGAudioPlayerDelegate,
ZYQAssetPickerControllerDelegate
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
    NSString *UserID;
    NSTimer *timer;
    CGFloat koardH;
    
    LMKeepImageView *backButtonView;
    UIImage *keepImage;
    NSInteger timerIndex;
    NSTimer *messageTimer;
    NSMutableArray *currentArray;
    
}
@property (nonatomic, weak) NSTimer *timerOf60Second;

@end

@implementation LMChatViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

        self.hidesBottomBarWhenPushed   = NO;
        self.listData   = [NSMutableArray new];
        
        ifloadMoreData =YES;
        isfirst = YES;
        hasShield = NO;
        isShieldReload = NO;
        
        [self createWebSocket];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(websocketConnect) userInfo:nil repeats:YES];
        messageTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(messageConnect) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] addTimer:messageTimer forMode:NSRunLoopCommonModes];
        

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
    if (timerIndex == 1) {
        [timer invalidate];
        timer = nil;
    }else{
        
    }

    
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
    
}

- (void)loadNewer
{
    
    FitBaseRequest * req = [self request];
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:req completed:^(NSString *resp, NSStringEncoding encoding) {
        
        NSArray * items = [self parseResponse:resp];
        
        if (items && [items count]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_listData addObjectsFromArray:items];
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
        
        if (vo.role &&![vo.role isEqualToString:@"student"]) {
            [shieldArray addObject:vo];
        }
    }
    
    reloadCount = 1;
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [bootView removeFromSuperview];
        });
        
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
                [activity stopAnimating];
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self textStateHUD:@"没有更多消息~"];
                [activity stopAnimating];
            });
        }
        
        return tempArr;
    }else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
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
            [self creatBootView];

        }
        if (_sign&&[_sign isEqualToString:@"2"]){
            [self creatToolbarView];
        }
        
    }else{
        
        [self creatToolbarView];
        [bootView removeFromSuperview];
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
            timerIndex = 2;
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
                if (client.connected ==YES) {
                    [client sendTo:urlStr body:string];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue()
                                   , ^{
                                       [self textStateHUD:@"禁言失败，请重试~"];
                                       [client disconnect];
                                       [self createWebSocket];
                                   });
                    
                }
            }
            
            if (_sign&&[_sign isEqualToString:@"2"]) {
                NSDictionary *dics = @{@"type":@"gag",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"sign":@"1"};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                if (client.connected ==YES) {
                    [client sendTo:urlStr body:string];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue()
                                   , ^{
                                       [self textStateHUD:@"解禁失败，请重试~"];
                                       [client disconnect];
                                       [self createWebSocket];
                                   });
                    
                }
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
    } else {
        
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"更换主持人成功！"];
            
            NSDictionary *dics = @{@"type":@"host",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"userId":[NSString stringWithFormat:@"%ld",(long)hostId]};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
            NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
            
            NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
            if (client.connected ==YES) {
                [client sendTo:urlStr body:string];
                
            }else{
                dispatch_async(dispatch_get_main_queue()
                               , ^{
                                   [self textStateHUD:@"更换主持人失败，请重试~"];
                                   [self createWebSocket];
                               });
                
            }
   
            
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
    
    if (vo.type && [vo.type isEqual:@"picture"]) {
        
        return 150+55+10+10;
    }
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        if (vo.ifchangeText ==YES) {
            return 180;
        }else{
          return 55+30+10+10;
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
                
                NSString *urlStr    = [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                
                if (client.connected == YES) {
                    
                    [client sendTo:urlStr body:string];
                    [self textStateHUD:@"问题提交成功"];
                    
                } else {
                    
                   // dispatch_async(dispatch_get_main_queue()
                     //              , ^{
                                       
                                       [self textStateHUD:@"问题提交失败，请重试~"];
                                       [self createWebSocket];
                       //            });
                }

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
                [self textStateHUD:@"发送失败,请重试~"];
                [self createWebSocket];
            }
//            [self.view endEditing:YES];
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
            
            if ([toorbar.inputTextView.text isEqualToString:@""]) {
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
                toorbar.inputTextView.frame = CGRectMake(45, 7, kScreenWidth-45-45, 36);
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            }else{
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toolBarChangeH,kScreenWidth, toolBarChangeH)];
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            }

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
    
    if (item == 1) {//小视频
        NSLog(@"点击进入相册，添加视频");
//        [self textStateHUD:@"该功能暂未开放~"];
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 1;
        picker.assetsFilter = [ALAssetsFilter allVideos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration < 10;
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
    
    [self getImageURL:[ImageHelpTool scaleImage:image]];
    
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
                                                                              [self textStateHUD:@"发送失败，请重试~"];
                                                                              [client disconnect];
                                                                              [self createWebSocket];
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
    
//    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Cookie",@"session=random", nil];
    
//    [client connectWithHeaders:dict completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
//        if (error) {
//        
//            return;
//        }
//        
//        [self subscribeTopic];
//    }];
    
    
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
    NSMutableArray *newNumArray = [NSMutableArray new];
    for (MssageVO *vo in self.listData) {
        if (vo.currentIndex &&[vo.currentIndex isKindOfClass:[NSNumber class]]) {
            [newNumArray addObject:vo.currentIndex];
        }
    }
    NSString *string = [NSString stringWithFormat:@"/topic/room/%@",_voiceUuid];
    
    [client subscribeTo:string messageHandler:^(STOMPMessage *message) {
        
        NSString *resp = [NSString stringWithFormat:@"%@",message.body];
        
        NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *respDict = [NSJSONSerialization
                                  JSONObjectWithData:respData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        MssageVO *vo = [MssageVO MssageVOWithDictionary:respDict];
        NSNumber *number = vo.currentIndex ;
        
        if ([newNumArray containsObject: number]) {
            return ;
        }
        
        
        if (vo.type && [vo.type isEqual:@"chat"]) {
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            NSMutableArray *array = [NSMutableArray new];
            NSString *content = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (content==nil) {
                [dic setObject:vo.content forKey:@"content"];
            }else{
                [dic setObject:content forKey:@"content"];
                
            }
            [dic setObject:vo.time forKey:@"time"];
            [dic setObject:vo.name forKey:@"name"];
            [dic setObject:vo.headimgurl forKey:@"headimgurl"];
            [dic setObject:vo.role forKey:@"role"];
            [dic setObject:vo.currentIndex forKey:@"currentIndex"];
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
        
        if (vo.type&&[vo.type isEqual:@"question"]) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            NSMutableArray *array = [NSMutableArray new];
            NSString *content = [vo.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (content==nil) {
                [dic setObject:vo.content forKey:@"content"];
            }else{
                [dic setObject:content forKey:@"content"];
                
            }
            [dic setObject:vo.time forKey:@"time"];
            [dic setObject:vo.name forKey:@"name"];
            [dic setObject:vo.headimgurl forKey:@"headimgurl"];
            [dic setObject:vo.currentIndex forKey:@"currentIndex"];
            [dic setObject:vo.role forKey:@"role"];
            
            
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
        
        if (vo.type&&([vo.type isEqual:@"picture"]||[vo.type isEqual:@"voice"])) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            NSMutableArray *array = [NSMutableArray new];
            
            if ([vo.type isEqual:@"voice"]) {
                [dic setObject:vo.attachment forKey:@"voiceurl"];
                [dic setObject:@"voice" forKey:@"type"];
                [dic setObject:vo.recordingTime forKey:@"recordingTime"];
                [dic setObject:vo.currentIndex forKey:@"currentIndex"];
                if (vo.transcodingUrl&&![vo.transcodingUrl isEqualToString:@""]) {
                    [dic setObject:vo.transcodingUrl forKey:@"transcodingUrl"];
                   // [dic setObject:vo.currentIndex forKey:@"currentIndex"];
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
            [dic setObject:vo.currentIndex forKey:@"currentIndex"];
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
                
                titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
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
                
                _sign = @"2";
            }else{
                [moreView removeFromSuperview];
                titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                [self addrightItem];
                _sign = @"2";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [bootView removeFromSuperview];
            });
        }
        
        [self performSelector:@selector(reLoadTableViewCell) withObject:nil afterDelay:0.1];
    }];
}

- (void)websocketConnect
{
    if (!client || ![client isKindOfClass:[STOMPClient class]]) {
        
        return;
    }
    
    if (client.connected == NO) {
        
        NSLog(@"0");
        client = [LMWobsocket shareWebsocket];
//        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Cookie",@"session=random", nil];
//        
//        [client connectWithHeaders:dict completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
//            if (error) {
//                
//                return;
//            }
//            
//            [self subscribeTopic];
//        }];
        dispatch_semaphore_t connected = dispatch_semaphore_create(0);
        [client connectWithLogin:@"1"
                        passcode:@"2"
               completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
                   if (!error) {
                       dispatch_semaphore_signal(connected);
                   }
                   [self subscribeTopic];
               }];
        
        
    } else {
        
        NSLog(@"1");
    }
}

#pragma mark ---下拉加载数据

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [changeView removeFromSuperview];

    if (-64 == self.tableView.contentOffset.y) {
        
        [self performSelectorInBackground:@selector(loadNextPage) withObject:nil];
    }
}

- (void)loadNextPage
{
    [self loadActivity];
    
    if (ifloadMoreData == NO) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self textStateHUD:@"没有更多消息~"];
            [activity removeFromSuperview];
        });
        
        return;
    }
    
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
        [activity removeFromSuperview];
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
    NSString *strings  = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings ,@"has_profile":@"false",@"question_uuid":questionUuid};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
    
    if (client.connected == YES) {
        
        [client sendTo:urlStr body:string];
        
    } else {
        
        dispatch_async(dispatch_get_main_queue()
                       , ^{
                           
                           [self textStateHUD:@"发送失败，请重试~"];
                           [client disconnect];
                           [self createWebSocket];
                       });
    }
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
        
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                            target:self
                                                          selector:@selector(sixtyTimeStopSendVodio)
                                                          userInfo:nil
                                                           repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
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

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecord
{
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecord
{
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecord
{
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
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
                                                           [client disconnect];
                                                           [self createWebSocket];
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
    changeView = [[UIView alloc] initWithFrame:CGRectMake(55, cell.frame.origin.y, 100, 30)];
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
    NSLog(@"打赏~~~~~~~~~~~~~~~~~~~~~~~~~~");
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
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        ALAssetRepresentation * representation = asset.defaultRepresentation;
        

        UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
        NSData *data = UIImageJPEGRepresentation(tempImg, 1);
        [self videoWithUrl:representation.url withFileName:representation.filename];
        NSLog(@"~~~~~~~~~%@~~~~~~~",representation.url);
        NSLog(@"~~~~~~~~~%@~~~~~~~",representation.filename);
        
//        NSString* picPath = [NSString stringWithFormat:@"%@/%@",KVideoUrlPath,representation.filename];

    
        
//        if(data){

            
//            NSLog(@"~~~~~~~~~~~~~~~~%@",data);

//        }
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        
        [assetLibrary assetForURL:representation.url resultBlock:^(ALAsset *asset){
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            
            Byte *buffer = (Byte*)malloc(rep.size);
            
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            // 这个data便是 转换成功的视频data 有了data边可以进行上传了
            NSData *Data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            [self sendVideo:Data];
            
        }failureBlock:^(NSError *err) {
            
            NSLog(@"error: ------------------------%@",err);
            
        }];
        

        }
    
    
    
    
    
}

// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 创建存放原始图的文件夹--->VideoURL
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:fileName];
                const char *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 11024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                    
                }
            } failureBlock:nil];
        }
    });
}

- (void)messageConnect
{
    currentArray = [NSMutableArray new];
    for (MssageVO *vo in self.listData) {
        if (vo.currentIndex &&[vo.currentIndex isKindOfClass:[NSNumber class]]) {
            [currentArray addObject:vo.currentIndex];
        }
    }
    
    NSArray *result = [currentArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2]; //升序
        
    }];
    
    if (result.count>1) {
        for (int i = 1; i<result.count-1; i++) {
            if (i+1<=result.count) {
                if ([result[i+1] intValue]-[result[i] intValue]>1) {
                    [self getmessageRequest:[result[i] intValue]+1];
                }
            }
            
        }
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
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                               [self hideStateHud];
                                           }];
    [proxy start];
}

- (void)getmessageRespond:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    if (!bodyDic) {
        [self textStateHUD:@"加载数据失败"];
    }
    
    NSString    *result = [bodyDic objectForKey:@"result"];
    NSString    *description    = [bodyDic objectForKey:@"description"];
    if (result && [result isEqualToString:@"0"]) {
        
        NSArray *tempArr    = [MssageVO MssageVOListWithArray:[bodyDic objectForKey:@"message"]];
        [self.listData addObjectsFromArray:tempArr];
        [self.tableView reloadData];
        
    }else if (description && ![description isEqual:[NSNull null]] && [description isKindOfClass:[NSString class]]) {
        
        [self performSelectorOnMainThread:@selector(textStateHUD:) withObject:description waitUntilDone:NO];
    }

    
    
}


#pragma mark  --上传视频

- (void)sendVideo:(NSData *)data
{
    
    
    
    NSLog(@"~~~~~~~~~~~~~~~~%@~~~~~~~~~~~~",data);
    
    
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    
    [self initStateHud];
    


    
    FirUploadVideoRequest *request = [[FirUploadVideoRequest alloc] initWithFileName:@"file"];
    
    request.videoData = data;
    
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding){
                                               
                                               [self performSelectorOnMainThread:@selector(hideStateHud)
                                                                      withObject:nil
                                                                   waitUntilDone:YES];
                                               NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
//
//                                               NSString    *result = [bodyDict objectForKey:@"result"];
//
//                                               if (result && [result isKindOfClass:[NSString class]]
//                                                   && [result isEqualToString:@"0"]) {
//                                                   NSString    *imgUrl = [bodyDict objectForKey:@"outputFileOSSUrl"];
//                                                   NSString    *voiceUrl = [bodyDict objectForKey:@"attachment_url"];
//                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
//
//                                                       NSDictionary *dics = @{@"type":@"voice",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl,@"recordingTime":[NSString stringWithFormat:@"%d",duration],@"transcodingUrl":voiceUrl};
//
//                                                       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
//                                                       NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
//                                                       NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
//                                                       if (client.connected ==YES) {
//                                                           [client sendTo:urlStr body:string];
//
//                                                       }else{
//                                                           [self textStateHUD:@"发送失败~"];
//                                                           [client disconnect];
//                                                           [self createWebSocket];
//                                                       }
//
//                                                       [self reLoadTableViewCell];
//
//
//                                                   }
//                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}




@end
