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

#define assistViewHeight  200
#define toobarHeight 45

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
AVAudioRecorderDelegate
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
    AVAudioSession *audioSession;
    int duration;
    
    BOOL  isfirst;
    BOOL hasShield;
    BOOL isShieldReload;
    NSArray *titleArray;
    NSArray *iconArray;
    
    
    
    CGPoint _tempPoint;
    UIView *_callView;
    UILabel *_label;
    UIImageView *_imgView;
    NSInteger _endState;
    NSLayoutConstraint *_centerX;
    AVAudioRecorder *_audioRecorder;
    NSURL       *_recordUrl;
    NSTimer *_timer;
    UIImageView *_yinjieBtn;
    
    UIView *_maskView;
    NSLayoutConstraint *_maskH;
    
    UIView *pressView;
    
}

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UIButton *saybutton;

@property(nonatomic,strong)UILabel *sayLabel;//按住说话

@property(nonatomic,strong)UITextView *inputTextView;

@property(nonatomic,strong)UIButton *addButton;

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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    moreView.hidden = YES;
    
    [self extraBottomViewVisiable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self botttomView];
    currentIndex = nil;
    [self setupRefresh];
    reloadCount =0;
    
}

#pragma mark 初始化视图静态界面
-(void)createUI
{
    self.title=@"语音教室";
    [super createUI];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight)];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //导航栏右边按钮
    
    if (_role&&![_role isEqualToString:@"student"]) {
        
        if ([_sign isEqualToString:@"1"]) {
            titleArray=@[@"已禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
        }else{
            titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
        }
        
        
        roleIndex = 2;
        iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
    }
    if (_role&&[_role isEqualToString:@"student"]){
        titleArray=@[@"屏蔽",@"问题"];
        roleIndex = 1;
        iconArray=@[@"moreShieldIcon",@"moreQuestionIcon"];
        
    }
    [self addrightItem];
    
    
}

- (void)addrightItem
{
    rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navRightIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(functionAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    moreView=[[MoreFunctionView alloc]initWithContentArray:titleArray andImageArray:iconArray];
    moreView.delegate=self;
    [moreView setHidden:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}


- (void)getvoiceRecordRequest
{
    
    if (ifloadMoreData==NO) {
        [self textStateHUD:@"没有更多消息~"];
        return;
    }
    
    LMChatRecordsRequest    *request    = [[LMChatRecordsRequest alloc] initWithPageIndex:currentIndex andPageSize:10 voice_uuid:_voiceUuid];
    HTTPProxy *proxy  = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             NSArray * items = [self parseResponse:resp];
                                             if (items && [items count]){
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     if (!self.ifLoadReverse) {
                                                         [self.listData addObjectsFromArray:items];
                                                         
                                                         [self.tableView reloadData];
                                                     } else {
                                                         NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.listData];
                                                         [self.listData removeAllObjects];
                                                         [self.listData addObjectsFromArray:items];
                                                         [self.listData addObjectsFromArray:tempArr];
                                                         NSLog(@"%lu",(unsigned long)items.count);
                                                         [self.tableView reloadData];
                                                         
                                                         //                                                         if (isfirst == NO){
                                                         //                                                             NSLog(@"***********%lu",items.count*(reloadCount-1));
                                                         //                                                                   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                                         //                                                         }
                                                         if (isfirst == YES) {
                                                             [self reLoadTableViewCell];
                                                             isfirst = NO;
                                                         }
                                                         
                                                         
                                                     }
                                                     
                                                 });
                                             }
                                             self.statefulState = FitStatefulTableViewControllerStateIdle;
                                         } failed:^(NSError *error) {
                                             
                                             self.statefulState = FitStatefulTableViewControllerStateIdle;
                                         }];
    
    [proxy start];
}


#pragma mark --屏蔽学员

- (void)getShieldstudentData
{
    
    if (ifloadMoreData==NO) {
        [self textStateHUD:@"没有更多消息~"];
        return;
    }
    
    LMShieldstudentRequest    *request    = [[LMShieldstudentRequest alloc] initWithPageIndex:currentIndex andPageSize:10 voice_uuid:_voiceUuid];
    HTTPProxy *proxy  = [HTTPProxy loadWithRequest:request
                                         completed:^(NSString *resp, NSStringEncoding encoding) {
                                             NSArray * items = [self parseResponse:resp];
                                             if (items && [items count]){
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     if (!self.ifLoadReverse) {
                                                         [self.listData addObjectsFromArray:items];
                                                         
                                                         [self.tableView reloadData];
                                                     } else {
                                                         NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.listData];
                                                         [self.listData removeAllObjects];
                                                         [self.listData addObjectsFromArray:items];
                                                         [self.listData addObjectsFromArray:tempArr];
                                                         NSLog(@"%lu",(unsigned long)items.count);
                                                         [self.tableView reloadData];
                                                         
                                                         //                                                         if (isfirst == NO){
                                                         //                                                             NSLog(@"***********%lu",items.count*(reloadCount-1));
                                                         //                                                                   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                                         //                                                         }
                                                         if (isfirst == YES) {
                                                             [self reLoadTableViewCell];
                                                             isfirst = NO;
                                                         }
                                                         
                                                         
                                                     }
                                                     
                                                 });
                                             }
                                             self.statefulState = FitStatefulTableViewControllerStateIdle;
                                         } failed:^(NSError *error) {
                                             
                                             self.statefulState = FitStatefulTableViewControllerStateIdle;
                                         }];
    
    [proxy start];
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
            
            for (int i = 0; i < tempArr.count; i ++) {
                
                MssageVO   *vo     = [tempArr objectAtIndex:i];
                vo.ifShowTimeLbl    = YES;
                
                for (int j = 0; j < i; j ++) {
                    
                    MssageVO   *olderVO    = [tempArr objectAtIndex:j];
                    
                    if ([olderVO.time timeIntervalSince1970] - [vo.time timeIntervalSince1970]  < 180 && olderVO.ifShowTimeLbl) {
                        
                        vo.ifShowTimeLbl    = NO;
                        break;
                    }
                }
            }
        }
        if (tempArr.count > 0) {
            MssageVO   *vo     = [tempArr objectAtIndex:0];
            
            if (currentIndex!=nil&&[currentIndex intValue] - [vo.currentIndex intValue]<9) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self textStateHUD:@"没有更多消息~"];
                    ifloadMoreData =NO;
                });
                
                
            }else if([currentIndex intValue] !=[vo.currentIndex intValue]){
                currentIndex = [NSString stringWithFormat:@"%d",[vo.currentIndex intValue]];
                reloadCount = reloadCount+1;
                
            }
            
        }
        
        return tempArr;
    }
    return nil;
    
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
                                                        [self.listData removeAllObjects];
                                                        
                                                        
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
                                                            
                                                            [self getvoiceRecordRequest];
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
                                                        [self.listData removeAllObjects];
                                                        
                                                        if (hasShield == NO &&isShieldReload ==NO) {
                                                            [self getShieldstudentData];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                titleArray=@[@"禁言",@"问题",@"已屏蔽",@"主持",@"关闭"];
                                                                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                                                                [self addrightItem];
                                                                
                                                            });
                                                            
                                                        }
                                                        if (hasShield == YES &&isShieldReload ==YES) {
                                                            [self getvoiceRecordRequest];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                                                                iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                                                                [self addrightItem];
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


//选择主持人代理
- (void)backhostName:(NSString *)liveRoom andId:(NSString *)userId
{
    LMChangeHostRequest *request = [[LMChangeHostRequest alloc] initWithUserId:userId nickname:liveRoom voice_uuid:_voiceUuid];
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
        [self textStateHUD:@"选择主持人失败！"];
    }else{
        if ([[bodyDic objectForKey:@"result"] isEqual:@"0"]) {
            [self textStateHUD:@"选择主持人成功！"];
        }else{
            [self textStateHUD:[bodyDic objectForKey:@"description"]];
        }
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.listData.count   %lu",(unsigned long)self.listData.count);
    return self.listData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MssageVO *vo = self.listData[indexPath.row];
    
    if (vo.type&&([vo.type isEqual:@"chat"]||[vo.type isEqual:@"question"])) {
        NSString *contentStr=vo.content;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
        
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
        CGSize contenSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-75, MAXFLOAT)                                           options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TEXT_FONT_LEVEL_2,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        
        return contenSize.height+55;
    }
    if (vo.type&&[vo.type isEqual:@"picture"]) {
        
        return 150+55;
    }
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        return 55+30;
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChattingCell *cell=[ChattingCell cellWithTableView:tableView];
    
    MssageVO *vo = self.listData[indexPath.row];
    [cell setCellValue:vo];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark 输入完成后发送消息，（数组中添加数据并重新加载cell）
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length==0||[textView.text isEqual:@""]) {
            [self textStateHUD:@"请输入文字"];
            return NO;
        }else{
            
            if (textView.text.length>5&&[[textView.text substringToIndex:5] isEqualToString:@"#问题# "]) {
                NSString *strings  = [_inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings ,@"has_profile":@"false"};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
                
                _inputTextView.text=@"";
            }else{
                NSString *strings  = [_inputTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dics = @{@"type":@"chat",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"content":strings};
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                
                NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                [client sendTo:urlStr body:string];
                
                _inputTextView.text=@"";
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



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    moreView.hidden = YES;
    
    NSTimeInterval timeValue;
    if (_visiableTime) {
        timeValue=_visiableTime;
    }else{
        timeValue=0.2f;
    }
    [UIView animateWithDuration:timeValue animations:^{
        self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
    }];
}
#pragma mark 语音说话及加号的执行方法（语音收缩、增加展示）

-(void)selectItem:(NSInteger)item
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
-(void)assistViewSelectItem:(NSInteger)item
{
    NSLog(@"=========选择照片及提问的执行方法==========%ld",(long)item);
    if (item==1) {//照片
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalTransitionStyle = UIModalPresentationCustom;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
    if (item==2) {//提问
        _inputTextView.text = @"#问题# ";
        
    }
}

#pragma mark 选择照片后添加数组 重新加载cell
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self getImageURL:image];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
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
    
    UIImage *headImage  = [ImageHelpTool scaleImage:image];
    request.imageData   = UIImageJPEGRepresentation(headImage, 1);
    
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
                                                       [client sendTo:urlStr body:string];
                                                       
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
-(void)extraBottomViewVisiable:(BOOL)state
{
    moreView.hidden = YES;
    NSTimeInterval timeValue;
    if (_visiableTime) {
        timeValue=_visiableTime;
    }else{
        timeValue=0.2f;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (state) {
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-assistViewHeight-toobarHeight);
                [self scrollTableToFoot:YES];
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-assistViewHeight-toobarHeight,kScreenWidth, toobarHeight)];
                [assistView setFrame:CGRectMake(0, kScreenHeight-assistViewHeight, kScreenWidth, assistViewHeight)];
            } ];
        }else{
            [UIView animateWithDuration:timeValue animations:^{
                
                self.tableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-toobarHeight);
                [self scrollTableToFoot:YES];
                
                [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
                [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
            }];
        }
    });
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
        
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyboardRect.size.height - toobarHeight);
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight-keyboardRect.size.height, kScreenWidth, toobarHeight)];
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        
    }];
    [self scrollTableToFoot:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _visiableTime=animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [toorbar setFrame:CGRectMake(0, kScreenHeight-toobarHeight,kScreenWidth, toobarHeight)];
        [assistView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, assistViewHeight)];
        
        self.tableView.frame           = CGRectMake(0, 0, kScreenWidth, kScreenHeight - toobarHeight);
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
}

#pragma mark   滚动表格到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}


-(void)createWebSocket
{
    NSURL *websocketUrl = [NSURL URLWithString:@"ws://121.43.40.58/live-connect/websocket"];
    client=[[STOMPClient alloc]initWithURL:websocketUrl webSocketHeaders:nil useHeartbeat:NO];
    
    
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Cookie",@"session=random", nil];
    
    [client connectWithHeaders:dict completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
        if (error) {
            NSLog(@"================连接失败=============%@", error);
            return;
        }
        NSString *string = [NSString stringWithFormat:@"/topic/room/%@",_voiceUuid];
        
        [client subscribeTo:string messageHandler:^(STOMPMessage *message) {
            NSLog(@"=========topic/greetings===订阅消息=============%@",message);
            NSLog(@"%@",message.body);
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
                [dic setObject:@"chat" forKey:@"type"];
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
                [array addObject:dic];
                NSArray *array2 = [MssageVO MssageVOListWithArray:array];
                if ([vo.type isEqual:@"chat"]) {
                    [self.listData addObjectsFromArray:array2];
                }
                
            }
            
            if (vo.type&&([vo.type isEqual:@"picture"]||[vo.type isEqual:@"voice"])) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                NSMutableArray *array = [NSMutableArray new];
                
                if ([vo.type isEqual:@"voice"]) {
                    [dic setObject:vo.attachment forKey:@"voiceurl"];
                    [dic setObject:@"voice" forKey:@"type"];
                    [dic setObject:vo.recordingTime forKey:@"recordingTime"];
                }
                if ([vo.type isEqual:@"picture"]) {
                    [dic setObject:vo.attachment forKey:@"imageurl"];
                    [dic setObject:@"picture" forKey:@"type"];
                }
                [dic setObject:vo.time forKey:@"time"];
                [dic setObject:vo.name forKey:@"name"];
                [dic setObject:vo.headimgurl forKey:@"headimgurl"];
                [array addObject:dic];
                NSArray *array2 = [MssageVO MssageVOListWithArray:array];
                [self.listData addObjectsFromArray:array2];
                
            }
            
            if (vo.type&&[vo.sign isEqual:@"1"]&&[vo.type isEqualToString:@"gag"]) {
                
                if ([vo.role isEqual:@"student"]) {
                    bootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-toobarHeight, kScreenWidth, toobarHeight)];
                    bootView.backgroundColor = [UIColor whiteColor];
                    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, toobarHeight)];
                    textLable.text = @"已禁言";
                    textLable.font = TEXT_FONT_LEVEL_2;
                    textLable.textAlignment = NSTextAlignmentCenter;
                    textLable.textColor = LIVING_COLOR;
                    [bootView addSubview:textLable];
                    [self.view addSubview:bootView];
                }else{
                    [moreView removeFromSuperview];
                    
                    titleArray=@[@"已禁言",@"问题",@"已屏蔽",@"主持",@"关闭"];
                    iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [self addrightItem];
                    
                    _sign = @"2";
                }
                
            }
            if (vo.type&&([vo.sign isEqual:@"2"]&&[vo.type isEqualToString:@"gag"])) {
                if ([vo.role isEqual:@"student"]) {
                    [bootView removeFromSuperview];
                }else{
                    [moreView removeFromSuperview];
                    titleArray=@[@"禁言",@"问题",@"屏蔽",@"主持",@"关闭"];
                    iconArray=@[@"stopTalkIcon",@"moreQuestionIcon",@"moreShieldIcon",@"morePresideIcon",@"moreClose"];
                    [self addrightItem];
                    _sign = @"1";
                }
            }
            [self reLoadTableViewCell];
            
        }];
        
    }];
    
    
}


#pragma mark  --录制结束上传音频

- (void)voiceFinish:(NSURL *)string time:(int)timeLong
{
    NSLog(@"%@",string);
    duration = timeLong;
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"/recodOutput.caf"];
    NSData *imageData = [NSData dataWithContentsOfFile: filePath];
    NSLog(@"*******voiceData******%@",imageData);
    
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
                                                   NSString    *imgUrl = [bodyDict objectForKey:@"attachment_url"];
                                                   if (imgUrl && [imgUrl isKindOfClass:[NSString class]]) {
                                                       
                                                       NSDictionary *dics = @{@"type":@"voice",@"voice_uuid":_voiceUuid,@"user_uuid":[FitUserManager sharedUserManager].uuid, @"attachment":imgUrl,@"recordingTime":[NSString stringWithFormat:@"%d",duration]};
                                                       
                                                       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                                                       NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
                                                       NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
                                                       [client sendTo:urlStr body:string];
                                                       
                                                       [self reLoadTableViewCell];
                                                       
                                                       
                                                   }
                                               }
                                           } failed:^(NSError *error) {
                                               [self hideStateHud];
                                           }];
    [proxy start];
}


- (void)setupRefresh
{
    moreView.hidden = YES;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //tableView刚出现时，进行刷新操作
    [self.tableView headerBeginRefreshing];
    
}

- (void)headerRereshing
{
    // 2.0秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)
                                 (1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
        if (hasShield == NO) {
            [self getvoiceRecordRequest];
        }else{
            [self getShieldstudentData];
        }
        
    });
}

- (void)cellClickVoice:(ChattingCell *)cell
{
    moreView.hidden = YES;
    MssageVO *vo = self.listData[cell.tag];
    
    if (vo.type&&[vo.type isEqual:@"voice"]) {
        NSString *urlStr = vo.voiceurl;
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        NSData * audioData = [NSData dataWithContentsOfURL:url];
        
        //将数据保存到本地指定位置
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *outputPath = [documentPath stringByAppendingString:@"/recodOutput.caf"];
//        NSURL *outputUrl = [NSURL fileURLWithPath:outputPath];
        [audioData writeToFile:outputPath atomically:YES];
        
        //播放本地音乐
        NSError *audioError = nil;
        BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
        if(!success)
        {
            NSLog(@"error doing outputaudioportoverride - %@", [audioError localizedDescription]);
        }
        player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
        player.delegate = self;
        [player play];
    }
}

- (void)cellClickImage:(ChattingCell *)cell
{
    moreView.hidden = YES;
    NSMutableArray *array = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
    for (int i = 0; i < self.listData.count; i++) {
        
        MssageVO *Projectslist=self.listData[i];
        
        if (Projectslist.imageurl && [Projectslist.imageurl isKindOfClass:[NSString class]] && ![Projectslist.imageurl isEqual:@""]) {
            
            [imageArray addObject: Projectslist.imageurl];
        }
    }
    
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

#pragma mark --问题列表返回问题

- (void)backDic:(NSString *)userId content:(NSString *)content
{
    NSString *strings  = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dics = @{@"type":@"question",@"voice_uuid":_voiceUuid,@"user_uuid":userId, @"content":strings ,@"has_profile":@"true"};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    NSString *urlStr= [NSString stringWithFormat:@"/message/room/%@",_voiceUuid];
    [client sendTo:urlStr body:string];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)addView
{
    
    _callView = [[UIView alloc] initWithFrame:CGRectZero];
    _callView.hidden = YES;
    _callView.translatesAutoresizingMaskIntoConstraints = NO;
    _callView.layer.cornerRadius = 10;
    _callView.clipsToBounds = YES;
    _callView.backgroundColor = [UIColor blackColor ];
    _callView.alpha = 0.5;
    [self.view addSubview:_callView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.text = @"手指上滑，取消发送";
    _label.layer.cornerRadius = 5;
    _label.clipsToBounds = YES;
    _label.textColor = [UIColor whiteColor];
    [_callView addSubview:_label];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.translatesAutoresizingMaskIntoConstraints = NO;
    _imgView.image = [UIImage imageNamed:@"yuyin"];
    [_callView addSubview:_imgView];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectZero];
    _maskView.translatesAutoresizingMaskIntoConstraints = NO;
    _maskView.backgroundColor = [UIColor whiteColor];
    [_callView addSubview:_maskView];
    
    _yinjieBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
    _yinjieBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _yinjieBtn.image = [UIImage imageNamed:@"yinjie（6）"];
    [_callView addSubview:_yinjieBtn];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_callView, _label, _imgView, _yinjieBtn, _maskView);
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-120-[_callView]-120-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_callView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_callView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_label]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label]-|" options:0 metrics:nil views:views]];
    _centerX = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-20];
    [self.view addConstraint:_centerX];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yinjieBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yinjieBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView]-[_maskView]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_yinjieBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    _maskH = [NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.view addConstraint:_maskH];
    
    
}

- (void)endPress {
    switch (_endState) {
        case 0: {
            NSLog(@"取消发送");
            break;
        }
        case 1: {
            
            break;
        }
        default:
            break;
    }
}

- (void)changeImage {
    [toorbar.recoder updateMeters];//更新测量值
    float avg = [toorbar.recoder averagePowerForChannel:0];
    float minValue = -60;
    float range = 60;
    float outRange = 100;
    if (avg < minValue) {
        avg = minValue;
    }
    float decibels = (avg + range) / range * outRange;
    _maskH.constant = _yinjieBtn.frame.size.height - decibels * _yinjieBtn.frame.size.height / 100;
    _maskView.layer.frame = CGRectMake(0, _yinjieBtn.frame.size.height - decibels * _yinjieBtn.frame.size.height / 100, _yinjieBtn.frame.size.width, _yinjieBtn.frame.size.height);
    [_yinjieBtn.layer setMask:_maskView.layer];
}


- (void)longPressBegin
{
    [self addView];
    _callView.hidden = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)longPressChanged
{
    CGPoint point = [toorbar.longPressReger locationInView:self.view];
    if (point.y < _tempPoint.y - 10) {
        _centerX.constant = 0;
        _endState = 0;
        _yinjieBtn.hidden = YES;
        _label.text = @"松开手指，取消发送";
        _label.backgroundColor = [UIColor clearColor];
        _imgView.image = [UIImage imageNamed:@"chexiao"];
        
        if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {
            _tempPoint = point;
            [_callView removeFromSuperview];
        }
        
        
    }
}

- (void)longPressEnd
{
    [_callView removeFromSuperview];
}

- (void)longPressCancelled
{
    NSLog(@"取消");
}




@end
